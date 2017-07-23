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
    var lifeHeart = 4
    var milliseconds = 0
    var score = 0
    var onesecond = Int(elapsedTime.truncatingRemainder(dividingBy: 60))
    var highscore = 0
    var highscoreZen = 0
    var timer = Timer()
    var isTimerRunning =  true
    var isZen = false
    var stopWatchString = ""
    var confettiView: SAConfettiView!
    let HighscoreDefault = UserDefaults.standard
    let HighscoreZenDefault = UserDefaults.standard
    let customGreen = #colorLiteral(red: 0.5683236718, green: 0.9822289348, blue: 0.4701448679, alpha: 1)
    let customLightBlue = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    let customPink = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
    @IBOutlet weak var labelRecord: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var stackHeartView: UIStackView!
    
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    
    
    
    
    @IBAction func startStopTapped(_ sender: Any) {
        buttonTapped()
    }
    
///////segmented////////

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            stackHeartView.alpha = 0
            labelRecord.text = "Highscore: \(highscore)"
            isZen = !isZen
            reset()
        case 1:
            stackHeartView.alpha = 1
            isZen = !isZen
            zenGame()
            labelRecord.text = "Highscore: \(highscoreZen)"
            reset()
        default:
            break; 
        }
    }
    
    
////////////////////////
    
    func reset() {
        minutes = 0
        seconds = 0
        score = 0
        milliseconds = 0
        labelScore.text = "Score: \(score)"
        labelTimer.text = "00:00.00"
        print(stopWatchString)
        resetHeart()
    }
    
    func zenGame() {
        if lifeHeart == 3  {
            heart.alpha = 0.2
        }else if lifeHeart == 2{
            heart2.alpha = 0.2
        }else if lifeHeart == 1 {
            heart3.alpha = 0.2
        }
    }
    
    func resetHeart() {
        lifeHeart = 4
        heart2.alpha = 1
        heart.alpha = 1
        heart3.alpha = 1
        score = 0
        labelScore.text = "Score: \(score)"
    }

    func updateStopwatch() {
        milliseconds += 1
        if milliseconds == 100 {
            milliseconds = 0
            seconds += 1
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
        ////timer goes/////
        if isTimerRunning {
            isTimerRunning = !isTimerRunning
            timer = Timer.scheduledTimer(timeInterval: Double(onesecond), target: self, selector: #selector(updateStopwatch), userInfo: nil, repeats: true)
            startStopButton.setTitle("Stop", for: .normal)
            confettiView.stopConfetti()
            labelScore.text = "Score: \(score)"
            labelRecord.text = "Highscore: \(highscore)"
            if isZen == true {
                labelRecord.text = "Highscore: \(highscoreZen)"
            }
            if lifeHeart == 0 {
                resetHeart()
            }
        }else{
            /////timer stop/////
            isTimerRunning = !isTimerRunning
            timer.invalidate()
            startStopButton.setTitle("Start", for: .normal)
            /////check timer///
            if milliseconds == 0 && seconds >= 1 {
                score += 1
                labelScore.text = "Score: \(score)"
            }else{
                if score > highscore {
                    highscore = score
                    if isZen == true {
                        highscoreZen = score
                    }
                    confettiView.startConfetti()
                    HighscoreDefault.set(highscore, forKey: "highscore")
                }else if score >= 1{
                    UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        self.view.backgroundColor = UIColor.red
                    }, completion: nil)
                }
                if isZen == true {
                    self.lifeHeart -= 1
                }
                zenGame()
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
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func setupConfetti() {
        self.view.addSubview(confettiView)
        confettiView.type = .confetti
        confettiView.isUserInteractionEnabled = false
    }
    
    func setupHighScores() {
        if let highscore = HighscoreDefault.value(forKey: "highscore") as? Int {
            self.highscore = highscore
            labelRecord.text = "Highscore: \(highscore)"
            
            if let highscoreZen = HighscoreZenDefault.value(forKey: "highscoreZen") as? Int {
                self.highscoreZen = highscoreZen
                labelRecord.text = "Highscore: \(highscoreZen)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupHighScores()
        self.confettiView = SAConfettiView(frame: self.view.bounds)
        setupConfetti()
        setupBackgroundColor()
        stackHeartView.alpha = 0
    }
}


