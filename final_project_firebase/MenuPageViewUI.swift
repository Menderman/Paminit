//
//  MenuPageViewUI.swift
//  final_project_firebase
//
//  Created by 許哲維 on 2024/6/10.
//

import Foundation
import UIKit
import SwiftUI

class MenuPageViewUI: UIViewController
{
    @IBSegueAction func showMenuUI(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: MenuPageView())
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(toSecondViewController(noti: )), name: AllNotification.toSecondViewController, object: nil)
    }
    
    @objc func toSecondViewController(noti: Notification)
    {
        
        let sb = storyboard?.instantiateViewController(withIdentifier: "CanvasUI") as! ViewController
        sb.modalPresentationStyle = .fullScreen
        present(sb, animated: true, completion: nil)
    }
}
