//
//  ViewController.swift
//  final_project_firebase
//
//  Created by 許哲維 on 2024/6/9.
//

import Foundation
import UIKit
import SwiftUI

/*protocol StoryboardViewControllerDelegate: AnyObject {
    func didDismissViewController()
}*/

class ViewController: UIViewController {
    //weak var delegate: StoryboardViewControllerDelegate?

    @IBOutlet weak var paintCanvas: CanvasTool!
    @IBOutlet var settingsContainer: [UIView]!
    var thisColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    /*Label*/
    var thickSetLabel: UILabel!
    var thickShowSetLable: UILabel!
    var eraserSetLabel: UILabel!
    var eraserShowSetLable: UILabel!
    var colorSetLabel: UILabel!
    var colorShowSetLabel: UILabel!
    /*Button*/
    var clearButton: UIButton!
    var saveButton: UIButton!
    /*Slider*/
    var thickSet: UISlider!
    var eraserSet: UISlider!
    var colorRSet: UISlider!
    var colorGSet: UISlider!
    var colorBSet: UISlider!
    
    //MARK: 筆粗選項初始設定
    func setThick()
    {
        thickSet = UISlider(frame: CGRect(x:0, y:0, width: 300, height: 119.5))
        thickSet.maximumValue = 60
        thickSet.minimumValue = 1
        thickSet.value = 12
        thickSet.isContinuous = true
        thickSet.addTarget(self, action: #selector(ViewController.sliderThick), for: UIControl.Event.valueChanged)
        thickSet.center = CGPoint(x:180.5, y:179.25)
        thickSet.minimumTrackTintColor = UIColor.black
        //
        thickSetLabel = UILabel(frame: CGRect(x:0, y:0, width: 180.5, height: 119.5))
        thickSetLabel.text = "⏺︎"//String(thickSet.value)
        thickSetLabel.font = UIFont.systemFont(ofSize: CGFloat(thickSet.value)*2)
        thickSetLabel.textAlignment = NSTextAlignment.center
        thickSetLabel.center = CGPoint(x:180.5, y:80)
        //
        thickShowSetLable = UILabel(frame: CGRect(x:0, y:0, width: 180.5, height: 25))
        thickShowSetLable.text = String(Int(thickSet.value))
        thickShowSetLable.font = UIFont.systemFont(ofSize: 16)
        thickShowSetLable.textAlignment = NSTextAlignment.center
        thickShowSetLable.center = CGPoint(x:180.5, y:140)
        settingsContainer[0].addSubview(thickSetLabel)
        settingsContainer[0].addSubview(thickShowSetLable)
        settingsContainer[0].addSubview(thickSet)
    }
    
    //MARK: 橡皮擦選項初始設定
    func setEraser()
    {
        eraserSet = UISlider(frame: CGRect(x:0, y:0, width: 300, height: 119.5))
        eraserSet.maximumValue = 60
        eraserSet.minimumValue = 1
        eraserSet.value = 12
        eraserSet.isContinuous = true
        eraserSet.addTarget(self, action: #selector(ViewController.sliderEraser), for: UIControl.Event.valueChanged)
        eraserSet.center = CGPoint(x:180.5, y:179.25)
        eraserSet.minimumTrackTintColor = UIColor.black
        //
        eraserSetLabel = UILabel(frame: CGRect(x:0, y:0, width: 80, height: 80))
        eraserSetLabel.text = "⏺︎"//String(thickSet.value)
        eraserSetLabel.font = UIFont.systemFont(ofSize: CGFloat(eraserSet.value)*2)
        eraserSetLabel.textAlignment = NSTextAlignment.center
        eraserSetLabel.center = CGPoint(x:180.5, y:80)
        //
        eraserShowSetLable = UILabel(frame: CGRect(x:0, y:0, width: 180.5, height: 25))
        eraserShowSetLable.text = String(Int(eraserSet.value))
        eraserShowSetLable.font = UIFont.systemFont(ofSize: 16)
        eraserShowSetLable.textAlignment = NSTextAlignment.center
        eraserShowSetLable.center = CGPoint(x:180.5, y:140)
        settingsContainer[1].addSubview(eraserSetLabel)
        settingsContainer[1].addSubview(eraserShowSetLable)
        settingsContainer[1].addSubview(eraserSet)
    }
    
    //MARK: 顏色選項初始設定
    func setColor()
    {
        colorRSet = UISlider(frame: CGRect(x:0, y:0, width: 200, height: 30))
        colorRSet.maximumValue = 255
        colorRSet.minimumValue = 0
        colorRSet.value = 0
        colorRSet.isContinuous = true
        colorRSet.minimumTrackTintColor = UIColor.red
        colorRSet.addTarget(self, action: #selector(ViewController.sliderColor), for: UIControl.Event.valueChanged)
        colorRSet.center = CGPoint(x:230, y:60)
        colorGSet = UISlider(frame: CGRect(x:0, y:0, width: 200, height: 30))
        colorGSet.maximumValue = 255
        colorGSet.minimumValue = 0
        colorGSet.value = 0
        colorGSet.isContinuous = true
        colorGSet.minimumTrackTintColor = UIColor.green
        colorGSet.addTarget(self, action: #selector(ViewController.sliderColor), for: UIControl.Event.valueChanged)
        colorGSet.center = CGPoint(x:230, y:120)
        colorBSet = UISlider(frame: CGRect(x:0, y:0, width: 200, height: 30))
        colorBSet.maximumValue = 255
        colorBSet.minimumValue = 0
        colorBSet.value = 0
        colorBSet.isContinuous = true
        colorBSet.minimumTrackTintColor = UIColor.blue
        colorBSet.addTarget(self, action: #selector(ViewController.sliderColor), for: UIControl.Event.valueChanged)
        colorBSet.center = CGPoint(x:230, y:180)
        settingsContainer[2].addSubview(colorRSet)
        settingsContainer[2].addSubview(colorGSet)
        settingsContainer[2].addSubview(colorBSet)
        //
        colorSetLabel = UILabel(frame: CGRect(x:0, y:0, width: 80, height: 80))
        colorSetLabel.text = "▇"//String(thickSet.value)
        colorSetLabel.layer.shadowOpacity = 0.2
        colorSetLabel.font = UIFont.systemFont(ofSize: 100)
        colorSetLabel.textAlignment = NSTextAlignment.center
        colorSetLabel.center = CGPoint(x:60, y:110)
        //
        colorShowSetLabel = UILabel(frame: CGRect(x:0, y:0, width: 80, height: 25))
        colorShowSetLabel.text = "#000000"
        colorShowSetLabel.font = UIFont.systemFont(ofSize: 16)
        colorShowSetLabel.textAlignment = NSTextAlignment.center
        colorShowSetLabel.center = CGPoint(x:60, y:170)
        settingsContainer[2].addSubview(colorSetLabel)
        settingsContainer[2].addSubview(colorShowSetLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paintCanvas.clipsToBounds = true
        paintCanvas.isMultipleTouchEnabled = false
        
        /*筆粗*/
        setThick()
        /*橡皮擦*/
        setEraser()
        /*顏色*/
        setColor()
        
        for settingButton in settingsContainer
        {
            settingButton.isHidden = true
        }
        settingsContainer[0].isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(toSecondViewController(noti: )), name: AllNotification.toSecondViewController, object: nil)
    }
    
    @objc func sliderThick()
    {
        thickSetLabel.text = String("⏺︎")
        thickSetLabel.font = UIFont.systemFont(ofSize: CGFloat(thickSet.value)*2)
        paintCanvas.selectColor = thisColor
        paintCanvas.penThick = CGFloat(thickSet.value)
        thickShowSetLable.text = String(Int(thickSet.value))
    }
    
    @objc func sliderEraser()
    {
        eraserSetLabel.text = String("⏺︎")
        eraserSetLabel.font = UIFont.systemFont(ofSize: CGFloat(eraserSet.value)*2)
        paintCanvas.selectColor = UIColor.white
        paintCanvas.penThick = CGFloat(eraserSet.value)
        eraserShowSetLable.text = String(Int(eraserSet.value))
    }
    
    @objc func sliderColor()
    {
        let getHex = String.init(format: "#%02lx%02lx%02lx", lroundf(colorRSet.value), lroundf(colorGSet.value), lroundf(colorBSet.value))
        
        thisColor = UIColor(red: CGFloat(colorRSet.value)/255, green: CGFloat(colorGSet.value)/255, blue: CGFloat(colorBSet.value)/255, alpha: 1)
        paintCanvas.selectColor = thisColor
        colorSetLabel.textColor = thisColor
        colorShowSetLabel.text = getHex
    }
    
    @IBAction func selectSettings(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        for settingsButton in settingsContainer
        {
            settingsButton.isHidden = true
        }
        
        settingsContainer[sender.selectedSegmentIndex].isHidden = false

        if(sender.selectedSegmentIndex == 0)
        {
            sliderThick()
        }
        else if(sender.selectedSegmentIndex == 1)
        {
            sliderEraser()
        }
        else if(sender.selectedSegmentIndex == 2)
        {
            sliderThick()
            sliderColor()
        }
    }
    
    @IBAction func saveCanvas(_ sender: UIButton) {
        showAlert(message: "Save This Canvas")
        let frame = paintCanvas.frame
        UIGraphicsBeginImageContext(frame.size)
        paintCanvas.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImageView()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image as! UIImage, nil, nil, nil)
    }
    
    @IBAction func createNewCanvas(_ sender: UIButton) {
        showAlert(message: "Delete and Opne New Canvas")
        paintCanvas.clearCanvas()
    }
    
    @IBAction func backToMenuPage(_ sender: UIButton) {
        //delegate?.didDismissViewController()
        if let window = UIApplication.shared.windows.first
        {
            let swiftUIview = UIHostingController(rootView: MenuPageView())
            
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = swiftUIview
                window.makeKeyAndVisible()
            }, completion: nil)
        }
        dismiss(animated: true, completion: nil)
        print("click")
        //let swiftUIPage = MenuPageView()
        //let hostingController = UIHostingController(rootView: swiftUIPage)
        //navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc func toSecondViewController(noti: Notification)
    {
        
        let sb = storyboard?.instantiateViewController(withIdentifier: "LoginUI") as! LoginViewUI
        //sb.modalTransitionStyle = .fullScreen
        present(sb, animated: true, completion: nil)
    }
    
    func showAlert(message: String)
    {
        let alert = UIAlertController(title: "Hint", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
}
