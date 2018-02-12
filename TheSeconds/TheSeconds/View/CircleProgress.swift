//
//  CircleProgress.swift
//  TheSeconds
//
//  Created by Edoardo de Cal on 30/01/18.
//  Copyright © 2018 Edoardo de Cal. All rights reserved.
//

import UIKit

class CircleProgress: UIView {
    
    private var trackLayer = CAShapeLayer()
    private var shapeLayer = CAShapeLayer()
    private var basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    
    override func draw(_ rect: CGRect) {
        setupTrackLayer()
        setupShapeLayer()
    }
    
    func start() {
        basicAnimation.toValue = 1.00
        basicAnimation.isAdditive = true
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.duration = CFTimeInterval(1.259026275)
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.speed = 1
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    func setupTrackLayer() {
        
        let centerPoint = CGPoint(x: bounds.width/2 , y: bounds.height/2)

        print(centerPoint)
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: frame.width/2, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.lineWidth = 20
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = #colorLiteral(red: 1, green: 0.9450980392, blue: 0.462745098, alpha: 1).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        layer.addSublayer(trackLayer)
    }
    
    func fullColorWin() {
        trackLayer.strokeColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor
    }
    
    func resetColor() {
        trackLayer.strokeColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor
    }
    
    func greenPowerUp() {
        trackLayer.strokeColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1).cgColor
    }
    
    
    func setupShapeLayer() {
        let centerPoint = CGPoint(x: bounds.width/2 , y: bounds.height/2)
        let circularPath = UIBezierPath(arcCenter: centerPoint, radius: frame.width/2, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.lineWidth = 20
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 0.4117647059, green: 0.8, blue: 0.968627451, alpha: 1)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0.0
        layer.addSublayer(shapeLayer)
    }
    
    func pause(){
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
    }
}
