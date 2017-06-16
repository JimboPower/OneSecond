//
//  ViewController.swift
//  TheSeconds
//
//  Created by Edoardo de Cal on 15/06/17.
//  Copyright © 2017 Edoardo de Cal. All rights reserved.
//

import UIKit
import Hue
import SAConfettiView

class ViewController: UIViewController {

    var timer = Timer()
    var minutes = 0
    var seconds = 0
    var milliseconds = 0
    var isTimerRunning = true
    var stopWatchString = ""
    var score = 0
    var record = 0
    var confettiView: SAConfettiView!
    
    @IBOutlet weak var labelRecord: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBAction func startStopTapped(_ sender: Any) {
        buttonTapped()
    }
    
    func updateLabelColors() {
        /*
        guard let isLight = self.view.backgroundColor?.isLight() else { return }
        let lightColor = UIColor.white
        let darkColor = UIColor.black
        if isLight {
            labelTimer.textColor = darkColor
            labelScore.textColor = darkColor
            labelRecord.textColor = darkColor
            startStopButton.tintColor = darkColor
        } else {
            labelTimer.textColor = lightColor
            labelScore.textColor = lightColor
            labelRecord.textColor = lightColor
            startStopButton.tintColor = lightColor
        }
        */
    }
    
    func updateStopwatch() {
        self.updateLabelColors()
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
            if seconds >= 1 {
                timer.invalidate()
                UIView.animate(withDuration: 1, animations: {() -> Void in
                    self.view.backgroundColor = UIColor.red
                })
            }
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
                    labelRecord.text = "Record: \(record)"
                    
                }
                milliseconds = 0
                seconds = 0
                minutes = 0
                score = 0
                labelScore.text = "Score: \(score)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confettiView = SAConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        confettiView.type = .confetti
        confettiView.startConfetti()
    }

}

extension ViewController {
    
}

