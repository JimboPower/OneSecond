//
//  ViewController.swift
//  TheSeconds
//
//  Created by Edoardo de Cal on 15/06/17.
//  Copyright © 2017 Edoardo de Cal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer = Timer()
    var minutes = 0
    var seconds = 0
    var milliseconds = 0
    var isTimerRunning = true
    var stopWatchString = ""
    var score = 0
    var record = 0

///
    
    @IBOutlet weak var labelRecord: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBAction func startStopTapped(_ sender: Any) {

        if isTimerRunning {
            isTimerRunning = !isTimerRunning
            timer = Timer.scheduledTimer(timeInterval: 0.0055, target: self, selector: #selector(updateStopwatch) , userInfo: nil, repeats: true)
            startStopButton.setTitle("Stop", for: .normal)
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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension ViewController {
    
}

