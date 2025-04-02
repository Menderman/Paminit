//
//  CanvasTool.swift
//  final_project_firebase
//
//  Created by 許哲維 on 2024/6/9.
//

import UIKit
import Foundation

class CanvasTool: UIView
{
    var selectColor = UIColor.black
    var penThick:CGFloat = 12
    var penPath:UIBezierPath = UIBezierPath()
    var touchPoint:CGPoint!
    var startPoint:CGPoint!
    
    override func touchesBegan(_ touch: Set<UITouch>, with event: UIEvent?)
    {
        startPoint = touch.first?.location(in: self)
    }
    
    override func touchesMoved(_ touch: Set<UITouch>, with event: UIEvent?)
    {
        touchPoint = touch.first?.location(in: self)
        penPath = UIBezierPath()
        penPath.move(to: startPoint)
        penPath.addLine(to: touchPoint)
        startPoint = touchPoint
        drawCanvas()
    }

    func drawCanvas()
    {
        let drawShape = CAShapeLayer()
        
        drawShape.path = penPath.cgPath
        drawShape.strokeColor = selectColor.cgColor
        drawShape.lineWidth = penThick
        drawShape.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(drawShape)
        self.setNeedsDisplay()
    }
    
    func clearCanvas()
    {
        if(!penPath.isEmpty)
        {
            penPath.removeAllPoints()
        }
        
        self.layer.sublayers = nil
        self.setNeedsDisplay()
    }

}
