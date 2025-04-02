//
//  LoginView.swift
//  final_project_firebase
//
//  Created by 蔡竣傑 on 2024/6/7.
//

import SwiftUI
import FirebaseAuth
import UIKit

struct StoryboardViewController: UIViewControllerRepresentable 
{
    //weak var delegate: StoryboardViewControllerDelegate?
    
    func makeUIViewController(context: Context) -> UIViewController {
        // 從Storyboard中載入目標ViewController
        let storyboard = UIStoryboard(name: "CanvasUI", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CanvasViewUI")
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 不需要更新
    }
}

struct LoginView: View {
    @State private var showStoryboard = false
    @State private var email = ""
    @State private var password = ""
    @State private var msg = ""
    
    var body: some View {
        //peter@neverland.com
        //123456
        ZStack
        {
            Image("login_background").resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            Color(uiColor: UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 0.9)).ignoresSafeArea()
            
            VStack
            {
                Text("Paminit")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading)
                {
                    Text("信箱")
                        .foregroundColor(.black).font(.headline)
                    
                    TextField("請輸入信箱", text: $email , prompt: Text("請輸入信箱"))
                        .padding()
                        .frame(height:42)
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke())
                    Text("")
                    Text("密碼")
                        .foregroundColor(.black).font(.headline)
                    
                    TextField("6 - 12字元", text: $password, prompt: Text("6 - 12字元"))
                        .padding()
                        .frame(height:42)
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke())
                }.padding()
                
                HStack
                {
                    Button("Login")
                    {
                        Auth.auth().signIn(withEmail: email, password: password) { result, error in
                            guard error == nil else {
                                print(error?.localizedDescription)
                                msg = "Error:\(error?.localizedDescription)"
                                return
                            }
                            
                            print("success")
                            msg = "Login success!"
                            
                            // 登入成功後發送通知
                            //NotificationCenter.default.post(name: AllNotification.toSecondViewController, object: nil)
                            let menuPageViewController = UIHostingController(rootView: MenuPageView())
                            if let window = UIApplication.shared.windows.first {
                                // 設置過渡動畫效果
                                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                                    window.rootViewController = menuPageViewController
                                    window.makeKeyAndVisible()
                                }, completion: nil)
                            }
                            //if let window = UIApplication.shared.windows.first {
                                //window.rootViewController = UIStoryboard(name: "CanvasUI", bundle: nil).instantiateViewController(withIdentifier: "CanvasViewUI")
                                //window.makeKeyAndVisible()
                            //}
                        }
                    }.padding(12)
                        .foregroundColor(.white)
                        .background(Color(red: 57/255, green: 65/255, blue: 59/255, opacity: 1),
                                    in: RoundedRectangle(cornerRadius: 12))
                    
                    // MARK: Create Account
                    Button("Create Account")
                    {
                        Auth.auth().createUser(withEmail: email, password: password) { result, error in
                            
                            guard let user = result?.user,
                                  error == nil else {
                                print(error?.localizedDescription)
                                msg = "Error:\(error?.localizedDescription)"
                                return
                            }
                            print(user.email, user.uid)
                            msg = "Create account:\(user.email), \(user.uid)"
                        }
                    }.padding(12)
                        .foregroundColor(.white)
                        .background(Color(red: 57/255, green: 65/255, blue: 59/255, opacity: 1),
                                    in: RoundedRectangle(cornerRadius: 12))
                    
                    //Text(msg)
                }
                
                Text("\n"+msg).padding()
            }.frame(width: 400.0)
        }
    }
}

/*extension LoginView: StoryboardViewControllerDelegate {
    func didDismissViewController() {
        showStoryboard = false
    }
}*/

#Preview {
    LoginView()
}
