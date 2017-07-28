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
    var best = 0
    var isTimerRunning = true
    var stopWatchString = ""
    var confettiView: SAConfettiView!
    let bestDefault = UserDefaults.standard
    @IBOutlet weak var labelRecord: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var leafScore: UIImageView!
    @IBOutlet weak var imageWood: UIImageView!
    @IBOutlet weak var leafBest: UIImageView!
    @IBAction func startStopButtonTapped(_ sender: Any) {
        buttonTapped()
    }
    
    func buttonTapped() {
        if isTimerRunning {
            isTimerRunning = !isTimerRunning
            confettiView.stopConfetti()
            timer = Timer.scheduledTimer(timeInterval: 5.ms, target: self, selector: #selector(updateStopwatch), userInfo: nil, repeats: true)
            startStopButton.setTitle("Stop", for: .normal)
            ruotate()
            labelUpdate()
        }else{
            isTimerRunning = !isTimerRunning
            timer.invalidate()
            startStopButton.setTitle("Start", for: .normal)
            stopAnimationForView(imageWood)
            if seconds == 1 && milliseconds == 0 {
                score += 1
                labelUpdate()
            }else{
                if score > best {
                    best = score
                    bestDefault.set(best, forKey: "best")
                    score = 0
                    confettiView.startConfetti()
                }
                score = 0
                seconds = 0
                milliseconds = 0
            }
        }
    }
    
    func labelUpdate() {
        labelScore.text = "Score: \(score)"
        labelRecord.text = "Best: \(best)"
    }
    
    func updateStopwatch() {
        milliseconds += 1
        print(milliseconds)
        if milliseconds == 100 {
            milliseconds = 0
            seconds += 1
        }
        let millisecondsString = milliseconds > 9 ?"\(milliseconds)" : "0\(milliseconds)"
        let secondsString = seconds > 9 ?"\(seconds)" : "\(seconds)"
        stopWatchString = "\(secondsString).\(millisecondsString)"
        labelTimer.text = stopWatchString
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
        labelScore.transform = CGAffineTransform(rotationAngle: -120)
        labelRecord.transform = CGAffineTransform(rotationAngle: 145)
    }
    
    func ruotate() {
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: .pi * 2.0)
        rotationAnimation.duration = 0.5;
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
        setupButtonAndLabel()
        setupLabels()
        setupbests()
    }
}
