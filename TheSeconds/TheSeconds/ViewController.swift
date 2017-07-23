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
    var minutes = 0
    var seconds = 0
    var lifeHeart = 3
    var milliseconds = 0
    var score = 0
    var highscore = 0
    var isTimerRunning = true
    var stopWatchString = ""
    var confettiView: SAConfettiView!
    let HighscoreDefault = UserDefaults.standard
    let customGreen = UIColor(red: 41/255, green: 248/255, blue: 150/255, alpha: 1)
    let customLightBlue = UIColor(red: 0, green: 176/255, blue: 255/255, alpha: 1)
    let customPink = UIColor(red: 240/255, green: 98/255, blue: 146/255, alpha: 1)
    var image: UIImage = UIImage(named:"ImageShare")!
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
        case 1:
            stackHeartView.alpha = 1
            zenGame()
<<<<<<< HEAD
            labelRecord.text = "Highscore: \(highscoreZen)"
            reset()
            resetHeart()
=======
>>>>>>> parent of 7fb2824... Bugs fixed
        default:
            break; 
        }
    }
    
    
////////////////////////
    
<<<<<<< HEAD
    func reset() {
        minutes = 0
        seconds = 0
        score = 0
        milliseconds = 0
        labelScore.text = "Score: \(score)"
        labelTimer.text = "00:00.00"
        print(stopWatchString)
        if isZen == true {
                resetHeart()
        }
    }
    
=======
>>>>>>> parent of 7fb2824... Bugs fixed
    func zenGame() {
        
        if lifeHeart == 2  {
            heart.alpha = 0
        }else if lifeHeart == 1{
            heart2.alpha = 0

        }else if lifeHeart == 0 {
            heart3.alpha = 0
        }else if lifeHeart == 3 {
            print("niente")
        }else{

            lifeHeart = 3
            heart3.alpha = 1
            heart2.alpha = 1
            heart.alpha = 1
        }
        
    }
    
<<<<<<< HEAD
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
        print(milliseconds)
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
=======
    @IBAction func shareButtonTapped(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [self.image, "Hi Man dowload this app! My highscore is \(highscore)!"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
>>>>>>> parent of 7fb2824... Bugs fixed
    }
    
    
    func buttonTapped() {
        if isTimerRunning {
            print("\(seconds)")

            isTimerRunning = !isTimerRunning
<<<<<<< HEAD

            timer = Timer.scheduledTimer(timeInterval: 1.ms, target: self, selector: #selector(updateStopwatch), userInfo: nil, repeats: true)
=======
            startDisplayLink()
>>>>>>> parent of 7fb2824... Bugs fixed
            startStopButton.setTitle("Stop", for: .normal)
            confettiView.stopConfetti()
            labelScore.text = "Score: \(score)"
            labelRecord.text = "Highscore: \(highscore)"
        }else{
            isTimerRunning = !isTimerRunning
            stopDisplayLink()
            startStopButton.setTitle("Start", for: .normal)
            if seconds > 1 {
                score += 1
                print("Ciaoen")

                labelScore.text = "Score: \(score)"
            }else{
                if score > highscore {
                    highscore = score
                    confettiView.startConfetti()
                    HighscoreDefault.set(highscore, forKey: "highscore")
                }else if score >= 1{
                    UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        self.view.backgroundColor = UIColor.red
                    }, completion: nil)
                }
                self.lifeHeart -= 1
                zenGame()
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
        if let highscore = HighscoreDefault.value(forKey: "highscore") as? Int {
            self.highscore = highscore
            labelRecord.text = "Highscore: \(highscore)"
        }
        stackHeartView.alpha = 0
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



extension ViewController {
    
}

