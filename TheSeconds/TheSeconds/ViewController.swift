//
//  ViewController.swift
//  TheSeconds
//
//  Created by Edoardo de Cal on 15/06/17.
//  Copyright © 2017 Edoardo de Cal. All rights reserved.
/////

import UIKit
import SAConfettiView
import GameKit

enum PowerEffect {
    case none
    case freeze
    case fire
    case green
}

class ViewController: UIViewController {
    
    var powerStatus: PowerEffect = .none {
        didSet {
            switch powerStatus {
            case .freeze:
                shouldShowOverlayEffect(image: #imageLiteral(resourceName: "ScreenIced"), isHidden: false)
            case .fire:
                shouldShowOverlayEffect(image: #imageLiteral(resourceName: "ScreenIced"), isHidden: false)
            default:
                break
            }
        }
    }
    
    var score = 0 {
        didSet {
            buttonScore.setTitle("Score: \(score)", for: .normal)
            if score > best {
                best = score
            }
        }
    }
    
    var best = 0 {
        didSet {
            buttonBest.setTitle("Best: \(best)", for: .normal)
        }
    }
    
    @IBOutlet weak var circleProgress: CircleProgress!
    var timer = Timer()
    var timeIntervalIce = Timer()
    var seconds = 0
    var milliseconds = 0
    var prova2 = true
    var suffix = 0
    var isTimerRunning = false
    var isTimerRunningIce = false
    var confettiView: SAConfettiView!
    var containerViewController: ContainerController?
    var durationRotate = 0.9
    var count = 1
    var prova = true
    let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    let trackLayer = CAShapeLayer()
    let bestDefault = UserDefaults.standard
    var radiusCircle = CGFloat(0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfetti()
        best = bestDefault.integer(forKey: "best")
        shouldShowOverlayEffect(image: #imageLiteral(resourceName: "ScreenIced"), isHidden: true)
        buttonBest.setTitle("Best: \(best)", for: .normal)
        best = bestDefault.integer(forKey: "bestScore")
        print("best: \(best)")
    }
    
    @IBAction func buttonShop(_ sender: Any) {
        timer.invalidate()
        startStopButton.setTitle("Start", for: .normal)
        milliseconds = 0
        seconds = 0
    }
    
    @IBOutlet weak var buttonBest: UIButton!
    @IBOutlet weak var buttonScore: UIButton!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var imageWood: UIImageView!
    @IBAction func startStopButtonTapped(_ sender: Any) {
        buttonTapped()
        prova2 = true
    }
    
    @IBOutlet weak var buttonViewIce: UIButton!
    
    func shouldShowOverlayEffect(image: UIImage, isHidden: Bool) {
        containerViewController?.overlayEffectImageView.isHidden = isHidden
        // nascondi dopo tot sec
    }
    
    
    @IBAction func buttonIceTapped(_ sender: Any) {
        /*
        powerStatus = .freeze
        prova2 = false
        if isTimerRunning == true {
            shouldShowOverlayEffect(image: #imageLiteral(resourceName: "ScreenIced"), isHidden: false)
            isTimerRunningIce = true
            timer.invalidate()
            timer = Timer(timeInterval: 0.1, repeats: true, block: { (_) in
                self.incrementMiliseconds()
            })
            RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
            buttonViewIce.isUserInteractionEnabled = false
            self.stopAnimationForView(self.imageWood)
            self.durationRotate = 3
            self.rotate()
            circleProgress.pause()
            if isTimerRunning == true {
                timeIntervalIce = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(intervalTime) , userInfo: nil, repeats: true)
                count = 0
            }
        }else{
            //normalRun()
        }
 */
    }
    
    @objc func intervalTime() {
        durationRotate = 0.9
        timeIntervalIce.invalidate()
        isTimerRunningIce = false
        //button()
       //normalRun()
    }
    
/*
    func button() {
        if prova == true {
            circleProgress.start()
            prova = false
        } else {
            circleProgress.pause()
            prova = true
        }
        ////Timer stops
        circleProgress.pause()
        isTimerRunning = false
        timeIntervalIce.invalidate()
        isTimerRunningIce = false
        self.stopAnimationForView(self.imageWood)
        self.durationRotate = 0.9
        rotate()
        /// buttonViewIce.isUserInteractionEnabled = false
        startStopButton.setTitle("Start", for: .normal)
        stopAnimationForView(self.imageWood)
        timer.invalidate()
    }
 */
    
    func buttonTapped() {

        
        if prova == true {
            circleProgress.start()
            prova = false
        } else {
            circleProgress.pause()
            prova = true
        }

        if isTimerRunning {
            ////Timer stops
            circleProgress.pause()
            isTimerRunning = false
            timeIntervalIce.invalidate()
            isTimerRunningIce = false
            self.stopAnimationForView(self.imageWood)
            self.durationRotate = 0.9
            self.rotate()
           /// buttonViewIce.isUserInteractionEnabled = false
            startStopButton.setTitle("Start", for: .reserved)
            self.stopAnimationForView(self.imageWood)
            if seconds >= 1 && suffix == 0 {
                score += 1
                bestDefault.set(best, forKey: "bestScore")
                circleProgress.fullColorWin()
            }else{
                if prova2 {
                score = 0
                milliseconds = 0
                }
            }
            timer.invalidate()
            count = 0
        }else{
            timer.invalidate()
            circleProgress.resetColor()
            count = 0
            isTimerRunningIce = false
            isTimerRunning = true
            shouldShowOverlayEffect(image: #imageLiteral(resourceName: "ScreenIced"), isHidden: true)
            
            timeIntervalIce.invalidate()
            startStopButton.setTitle("Stop", for: .reserved)
            rotate()
            buttonViewIce.isUserInteractionEnabled = true
            timer = Timer(timeInterval: 0.01, repeats: true, block: { (_) in
                self.incrementMiliseconds()
                self.count += 1
                if self.count == 101 {
                    self.count = 1
                    self.circleProgress.start()
                }
            })
            RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
            
        }
    }

    func normalRun() {
        isTimerRunning = true
        timeIntervalIce.invalidate()
        startStopButton.setTitle("Stop", for: .normal)
        rotate()
        buttonViewIce.isUserInteractionEnabled = true
        timer.invalidate()
        timer = Timer(timeInterval: 0.01, repeats: true, block: { (_) in
            print(self.count)
            self.incrementMiliseconds()
            self.count += 1
            if self.count == 101 {
                self.count = 1
                self.circleProgress.start()
            }
        })
        prova = !prova
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
    
    func rotate() {
        rotationAnimation.toValue = NSNumber(value: .pi * 3.5)
        rotationAnimation.duration = Double(durationRotate);
        rotationAnimation.isCumulative = true;
        rotationAnimation.repeatCount = .infinity;
        self.imageWood?.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopAnimationForView(_ myView: UIView) {
        let transform = myView.layer.presentation()?.transform
        myView.layer.transform = transform!
        myView.layer.removeAllAnimations()
    }
}
