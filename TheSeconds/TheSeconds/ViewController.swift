//
//  ViewController.swift
//  TheSeconds
//
//  Created by Edoardo de Cal on 15/06/17.
//  Copyright © 2017 Edoardo de Cal. All rights reserved.
/////

import UIKit
import SAConfettiView

class ViewController: UIViewController {

    var minutes = 0
    var seconds = 0
    var milliseconds = 0
    var score = 0
    var record = 0
    var timer = Timer()
    var isTimerRunning = true
    var stopWatchString = ""
    var confettiView: SAConfettiView!
    let customGreen = UIColor(red: 41/255, green: 248/255, blue: 150/255, alpha: 1)
    let customLightBlue = UIColor(red: 0, green: 176/255, blue: 255/255, alpha: 1)
    let customPink = UIColor(red: 240/255, green: 98/255, blue: 146/255, alpha: 1)
    
    @IBOutlet weak var labelRecord: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBAction func startStopTapped(_ sender: Any) {
        buttonTapped()
    }
    
    func updateStopwatch() {
        milliseconds += 1
        if milliseconds == 100 {
            seconds += 1
            milliseconds = 0
        }
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        let millisecondsString = milliseconds > 9 ?"\(milliseconds)" : "0\(milliseconds)"
        let secondsString = seconds > 9 ?"\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ?"\(minutes)" : "0\(minutes)"
        stopWatchString = "\(minutesString):\(secondsString).\(millisecondsString)"
        labelTimer.text = stopWatchString
    }
    
    func buttonTapped() {
        if isTimerRunning {
            isTimerRunning = !isTimerRunning
            timer = Timer.scheduledTimer(timeInterval: 0.0055, target: self, selector: #selector(updateStopwatch) , userInfo: nil, repeats: true)
            startStopButton.setTitle("Stop", for: .normal)
            confettiView.stopConfetti()
            ///
            labelScore.text = "Score: \(score)"
            labelRecord.text = "Record: \(record)"
        }else{
            isTimerRunning = !isTimerRunning
            timer.invalidate()
            startStopButton.setTitle("Start", for: .normal)
            if milliseconds == 0 && seconds >= 1 {
                score += 1
                labelScore.text = "Score: \(score)"
            }else{
                if score > record {
                    record = score
                    confettiView.startConfetti()
                }
                milliseconds = 0
                seconds = 0
                minutes = 0
                score = 0
                
            }
        }
    }
    
    func setupBackgroundColor() {
        UIView.animate(withDuration: 5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
            self.view.backgroundColor = self.customGreen
        }) { (Bool) -> Void in
             UIView.animate(withDuration: 5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                self.view.backgroundColor = UIColor.cyan
            }, completion: { (Bool) -> Void in
                 UIView.animate(withDuration: 5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                    self.view.backgroundColor = self.customLightBlue
                }, completion: { (Bool) -> Void in
                     UIView.animate(withDuration: 5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                        self.view.backgroundColor = self.customPink
                    }, completion: { (Bool) -> Void in
                        self.setupBackgroundColor()
                    })
                })
            })
        }
    }
    
    func setupConfetti() {
        self.view.addSubview(confettiView)
        confettiView.type = .confetti
        confettiView.isUserInteractionEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confettiView = SAConfettiView(frame: self.view.bounds)
        setupConfetti()
        setupBackgroundColor()
        self.labelTimer.adjustsFontSizeToFitWidth = true

    }

}

extension ViewController {
    
}

