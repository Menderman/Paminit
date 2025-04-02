//
//  MenuPageView.swift
//  final_project_firebase
//
//  Created by 許哲維 on 2024/6/10.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

struct MenuPageView: View {
    @State private var showStoryboard = false
    @State private var isPickerShowing = false
    @State private var selectedImage:UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var retrieveImages = [UIImage]()
    @State private var isShowingPhotosPicker = false
    
    var body: some View {
        VStack
        {
            HStack
            {
                Text("Gallery").font(.title)
                Spacer()
                /*Button(action: {
                    NotificationCenter.default.post(name: AllNotification.toSecondViewController, object: nil)
                }, label: {
                    VStack
                    {
                        Image(systemName: "doc.badge.plus")
                        Text("New Canvas").font(.system(size: 8))
                    }
                }).foregroundColor(.black)*/

                Button(action: {
                    //showStoryboard = true
                    if let window = UIApplication.shared.windows.first {
                        let storyboard = UIStoryboard(name: "CanvasUI", bundle: nil)
                            let viewController = storyboard.instantiateViewController(withIdentifier: "CanvasUI")
                            
                            // 設置過渡效果
                            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                                window.rootViewController = viewController
                                window.makeKeyAndVisible()
                            }, completion: nil)
                    }
                }, label: {
                    VStack
                    {
                        Image(systemName: "doc.badge.plus")
                        Text("New Canvas").font(.system(size: 8))
                    }
                }).foregroundColor(.black)
                    //.fullScreenCover(isPresented: $showStoryboard, content: {
                        //storyBoardView(delegate: self)
                   // })
                Divider().frame(height: 30)
                //
                VStack
                {
                    Button(action: {
                        isPickerShowing = true
                    }, label: {
                        VStack
                        {
                            Image(systemName: "square.and.arrow.up.on.square")
                            Text("Upload").font(.system(size: 8))
                        }
                    })
                    .foregroundColor(.black)
                    .photosPicker(isPresented: $isPickerShowing, selection: $photosPickerItem, matching: .images)
                    .onChange(of: photosPickerItem)
                    {
                        newItem in
                        if let newItem1 = newItem
                        {
                            Task
                            {
                                if let data = try? await newItem1.loadTransferable(type: Data.self), let uiImage = UIImage(data: data)
                                {
                                    selectedImage = uiImage
                                    uploadPhoto()
                                }
                            }
                        }
                    }
                }
                //
            }.padding()
            
            Divider()
            
            ScrollView
            {
                ForEach(retrieveImages, id: \.self)
                {
                    image in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 250,height: 250)
                    Divider()
                }
            }.onAppear{
                retrievePhotos()
            }
            /*.onChange(of: photosPickerItem) { _, _ in
                Task {
                    if let photosPickerItem,
                       let data = try? await photosPickerItem.loadTransferable(type: Data.self){
                        if let image = UIImage(data: data){
                            selectedImage = image
                        }
                    }
                    photosPickerItem = nil
                }
            }*/
        }
    }
    
    func uploadPhoto(){
        //safety
        guard selectedImage != nil else{
            return
        }
        
        //storage ref
        let storageRef = Storage.storage().reference()
        //image to data
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else{
            return
        }
        //specify path and name
        let path = "image/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        //upload data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil{
                //save file ref
                let db = Firestore.firestore()
                db.collection("images").document().setData(["url":path], completion: { error in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.retrieveImages.append(self.selectedImage!)
                        }
                    }
                })
            }
        }
    }
    
    func retrievePhotos()
    {
        //get data from db
        let db = Firestore.firestore()
        
        db.collection("images").getDocuments{ snapshot, error in
            if error == nil && snapshot != nil{
                var paths = [String]()
                
                for doc in snapshot!.documents{
                    paths.append(doc["url"] as! String)
                }
                
                for path in paths {
                    //print("path:\(path)")
                    //get ref through storage
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                    
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if error == nil && data != nil{
                            if let image = UIImage(data: data!){
                                DispatchQueue.main.async{
                                    retrieveImages.append(image)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

/*extension MenuPageView: StoryboardViewControllerDelegate
{
    func didDismissViewController() {
        showStoryboard = false
    }
}*/

/*struct storyBoardView: UIViewControllerRepresentable
{
    weak var delegate: StoryboardViewControllerDelegate?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "CanvsUI", bundle: nil)
        let viewContainer = storyboard.instantiateViewController(withIdentifier: "CanvasViewUI") as! ViewController
        viewContainer.delegate = delegate
        
        return viewContainer
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
}*/

#Preview {
    MenuPageView()
}
