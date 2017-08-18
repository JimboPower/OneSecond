//
//  ViewController.swift
//  TheSeconds
//
//  Created by Edoardo de Cal on 15/06/17.
//  Copyright © 2017 Edoardo de Cal. All rights reserved.
/////

import UIKit
import SAConfettiView
import SwiftyTimer

class ViewController: UIViewController {
    var timer = Timer()
    var seconds = 0
    var milliseconds = 0
    var score = 0
    var suffix = 0
    var best = 0
    var isTimerRunning = false
    var isTimerRunningIce = false
    var confettiView: SAConfettiView!
    let bestDefault = UserDefaults.standard
    var speed = 5
    var timeIntervalIce = Timer()
    var durationRuotate = 0.9
    let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    @IBOutlet weak var labelRecord: UILabel!
    @IBOutlet weak var imageIce: UIImageView!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var leafScore: UIImageView!
    @IBOutlet weak var imageWood: UIImageView!
    @IBOutlet weak var leafBest: UIImageView!
    @IBAction func startStopButtonTapped(_ sender: Any) {
        buttonTapped()
    }
    
    @IBOutlet weak var buttonViewIce: UIButton!
    
    @IBAction func buttonIceTapped(_ sender: Any) {
        print("True va, False no")
        if isTimerRunning == true {
            imageIce.isHidden = false
            isTimerRunningIce = true
            timer.invalidate()
            timer = Timer(timeInterval: 0.1, repeats: true, block: { (_) in
                self.incrementMiliseconds()
            })
            RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
            buttonViewIce.isUserInteractionEnabled = false
            self.stopAnimationForView(self.imageWood)
            self.durationRuotate = 4
            self.ruotate()
            if isTimerRunning == true {
                timeIntervalIce = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(intervalTime) , userInfo: nil, repeats: true)
            }
        }else{
            normalRun()
        }
    }
    
    
    func intervalTime() {
        if self.isTimerRunningIce == true {
            self.durationRuotate = 0.9
            self.isTimerRunningIce = false
            self.buttonTapped()
            self.normalRun()
        }else{
            normalRun()
        }
    }
    
    func buttonTapped() {
        if isTimerRunning {
            isTimerRunning = false
            isTimerRunningIce = false
            self.stopAnimationForView(self.imageWood)
            self.durationRuotate = 0.9
            self.ruotate()
            buttonViewIce.isUserInteractionEnabled = false
            startStopButton.setTitle("Start", for: .normal)
            self.stopAnimationForView(self.imageWood)
            timer.invalidate()
        } else {
            isTimerRunningIce = false
            isTimerRunning = true
            imageIce.isHidden = true
            milliseconds = 0
            startStopButton.setTitle("Stop", for: .normal)
            ruotate()
            buttonViewIce.isUserInteractionEnabled = true
            timer = Timer(timeInterval: 0.01, repeats: true, block: { (_) in
                self.incrementMiliseconds()
            })
            RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        }
    }
    
    
    func normalRun() {
        isTimerRunning = true
        imageIce.isHidden = true
        milliseconds = 0
        startStopButton.setTitle("Stop", for: .normal)
        ruotate()
        buttonViewIce.isUserInteractionEnabled = true
        timer = Timer(timeInterval: 0.01, repeats: true, block: { (_) in
            self.incrementMiliseconds()
        })
        RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func display(miliseconds: Int) {
        seconds = miliseconds / 100
        suffix = miliseconds - (seconds * 100)
        if suffix < 10 {
            labelTimer.text = String(seconds) + ".0" + String(suffix)
        } else {
            labelTimer.text = String(seconds) + "." + String(suffix)
        }
    }
    
    func incrementMiliseconds() {
        milliseconds += 1
        display(miliseconds: milliseconds)
    }
    
    func labelUpdate() {
        labelScore.text = "Score: \(score)"
        labelRecord.text = "Best: \(best)"
    }
    
    func setupButtonAndLabel() {
        startStopButton.layer.shadowOpacity = 0.2
        startStopButton.layer.shadowColor = UIColor.black.cgColor
        startStopButton.layer.shadowRadius = 4
        startStopButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        startStopButton.layer.masksToBounds =  false
    }
    
    func setupConfetti() {
        self.confettiView = SAConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        confettiView.type = .image(UIImage(named: "ConfettiLeaf")!)
        confettiView.isUserInteractionEnabled = false
    }
    
    func setupLabels() {
        labelScore.transform = CGAffineTransform(rotationAngle: 270)
        labelRecord.transform = CGAffineTransform(rotationAngle: -50)
    }
    
    func ruotate() {
        rotationAnimation.toValue = NSNumber(value: .pi * 3.5)
        rotationAnimation.duration = Double(durationRuotate);
        rotationAnimation.isCumulative = true;
        rotationAnimation.repeatCount = .infinity;
        self.imageWood?.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func setupbests() {
        if let best = bestDefault.value(forKey: "best") as? Int {
            self.best = best
            labelRecord.text = "Best: \(best)"
        }
    }
    
    func stopAnimationForView(_ myView: UIView) {
        let transform = myView.layer.presentation()?.transform
        myView.layer.transform = transform!
        myView.layer.removeAllAnimations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfetti()
        imageIce.isHidden = true
        setupLabels()
        setupbests()
        buttonViewIce.isUserInteractionEnabled = false
    }
}
