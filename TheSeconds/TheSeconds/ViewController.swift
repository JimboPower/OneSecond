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
import SquishButton

class ViewController: UIViewController {
    var seconds = 0
    var lifeHeart = 3
    var milliseconds = 0
    var score = 0
    var timer = Timer()
    var isZen = true
    var highscore = 0
    var isTimerRunning = true
    var stopWatchString = ""
    var confettiView: SAConfettiView!
    let HighscoreDefault = UserDefaults.standard
    @IBOutlet weak var labelRecord: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var startStopButton: SquishButton!
    @IBOutlet weak var leafScore: UIImageView!
    @IBOutlet weak var imageWood: UIImageView!
    @IBOutlet weak var leafBest: UIImageView!
    
    @IBAction func startStopButtonTapped(_ sender: Any) {
        buttonTapped()
    }
    
    func ruotate() {
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: M_PI * 2.5)
        rotationAnimation.duration = 1;
        rotationAnimation.isCumulative = true;
        rotationAnimation.repeatCount = .infinity;
        self.imageWood?.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func buttonTapped() {
        if isTimerRunning {
            ruotate()
            print("\(seconds)")
            isTimerRunning = !isTimerRunning
            confettiView.stopConfetti()
            timer = Timer.scheduledTimer(timeInterval: 8.ms, target: self, selector: #selector(updateStopwatch), userInfo: nil, repeats: true)
            startStopButton.setTitle("Stop", for: .normal)
            labelScore.text = "Score: \(score)"
            labelRecord.text = "Best: \(highscore)"
        }else{
            isTimerRunning = !isTimerRunning
            timer.invalidate()
            self.imageWood?.layer.removeAnimation(forKey: "rotationAnimation")
            startStopButton.setTitle("Start", for: .normal)
            if seconds == 1 && milliseconds == 0 {
                score += 1
                labelScore.text = "Score: \(score)"
            }else{
                if score > highscore {
                    highscore = score
                    HighscoreDefault.set(highscore, forKey: "highscore")
                    score = 0
                    confettiView.startConfetti()
                }else if score >= 1{
                    UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        self.view.backgroundColor = UIColor.red
                    }, completion: nil)
                }
                labelScore.text = "Score: \(score)"
                seconds = 0
                milliseconds = 0
            }
        }
    }
    
    func reset() {
        seconds = 0
        score = 0
        milliseconds = 0
        labelScore.text = "Score: \(score)"
        labelTimer.text = "0.00"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confettiView = SAConfettiView(frame: self.view.bounds)
        setupConfetti()
        setupButtonAndLabel()
        setupLabels()
        setupHighscores()
    }
    
    func setupButtonAndLabel() {
        startStopButton.layer.shadowOpacity = 0.2
        startStopButton.layer.shadowColor = UIColor.black.cgColor
        startStopButton.layer.shadowRadius = 4
        startStopButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        startStopButton.layer.masksToBounds =  false
    }
    
    func setupConfetti() {
        self.view.addSubview(confettiView)
        confettiView.type = .image(UIImage(named: "ConfettiLeaf")!)
        confettiView.isUserInteractionEnabled = false
    }
    
    func setupLabels() {
        labelScore.transform = CGAffineTransform(rotationAngle: -120)
        labelRecord.transform = CGAffineTransform(rotationAngle: 145)
    }
    
    func setupHighscores() {
        if let highscore = HighscoreDefault.value(forKey: "highscore") as? Int {
            self.highscore = highscore
            labelRecord.text = "Best: \(highscore)"
        }
    }
}

