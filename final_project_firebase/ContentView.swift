//
//  ContentView.swift
//  final_project_firebase
//
//  Created by 蔡竣傑 on 2024/5/31.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

struct ContentView: View {
    @State private var isPickerShowing = false
    @State private var selectedImage:UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var retrieveImages = [UIImage]()
    var body: some View {
        VStack {
//            if selectedImage != nil {
//                Image(uiImage: selectedImage!)
//                    .resizable()
//                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
//            }
            
            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                Image(uiImage: selectedImage ?? UIImage(systemName: "star")!)
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
            }
            
//            Button{
//                isPickerShowing = true
//            } label: {
//                Text("Select a image")
//            }
            
            if selectedImage != nil{
                Button{
                    uploadPhoto()
                } label: {
                    Text("Upload")
                }
            }
            
            Divider()
            
            HStack{
                ForEach(retrieveImages, id: \.self){ image in
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100,height: 100)
                }
            }
        }
        .onAppear{
            retrievePhotos()
        }
        .onChange(of: photosPickerItem) { _, _ in
            Task {
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self){
                    if let image = UIImage(data: data){
                        selectedImage = image
                    }
                }
                photosPickerItem = nil
            }
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
    
    func retrievePhotos(){
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
        
        //get image from storage for each ref
    }
}

#Preview {
    ContentView()
}
