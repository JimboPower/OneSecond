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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTrackLayer()
        setupShapeLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func start() {
        basicAnimation.toValue = 1.00
        basicAnimation.isAdditive = true
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.duration = CFTimeInterval(1.25902626)
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.speed = 1
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    func setupTrackLayer() {
        let circularPath = UIBezierPath(arcCenter: center, radius: 0, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.lineWidth = 20
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = #colorLiteral(red: 1, green: 0.9450980392, blue: 0.462745098, alpha: 1).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        layer.addSublayer(trackLayer)
    }
    
    func setupShapeLayer() {
        let circularPath = UIBezierPath(arcCenter: center, radius: 0, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.lineWidth = 20
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 0.0
        layer.addSublayer(shapeLayer)
    }
    
    func pauseAnimation() {
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
    }
}
