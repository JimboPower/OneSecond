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
import AVFoundation
//import SimulatorStatusMagic

enum PowerEffect {
    case none
    case freeze
    case fire
    case green
}

class ViewController: UIViewController, GKGameCenterControllerDelegate {

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
        }
    }
    var best = 0 {
        didSet {
            buttonBest.setTitle("Best: \(best)", for: .normal)
        }
    }
    
    var isTimerRunning = false {
        didSet {
            showHideButtons()
        }
    }
    
    var timer = Timer()
    var boolCheckUserDefault = UserDefaults.standard.bool(forKey: "bool")
    var timeIntervalIce = Timer()
    var seconds = 0
    var milliseconds = 0
    var suffix = 0
    
    var isTimerRunningIce = false
    var confettiView: SAConfettiView!
    var containerViewController: ContainerController?
    var durationRotate = 0.9
    var count = 1
    var checkerCirlceProgress = true
    let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    let trackLayer = CAShapeLayer()
    let userDefault = UserDefaults.standard
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    let leaderboardID = "com.score.OneSecond"
    var greenActiveted = false
    var acornNumber = UserDefaults.standard.integer(forKey: "acorn") {
        didSet{
            userDefault.set(acornNumber, forKey: "acorn")
            labelAcorn.text = "\(acornNumber)"
            acornNumber = userDefault.integer(forKey: "acorn")
        }
    }
    var greenNumber = UserDefaults.standard.integer(forKey: "green") {
        didSet{
            userDefault.set(greenNumber, forKey: "green")
            greenNumber = userDefault.integer(forKey: "green")
            buttonViewGreen.setTitle(String(greenNumber), for: .normal)
        }
    }
    var iceNumber = UserDefaults.standard.integer(forKey: "ice") {
        didSet{
            userDefault.set(iceNumber, forKey: "ice")
            buttonViewIce.setTitle(String(iceNumber), for: .normal)
            iceNumber = userDefault.integer(forKey: "ice")
        }
    }
    
    ///IBOutlet
    @IBOutlet weak var circleProgress: CircleProgress!
    @IBOutlet weak var labelAcorn: UILabel!
    @IBOutlet weak var buttonBest: UIButton!
    @IBOutlet weak var buttonScore: UIButton!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var imageWood: UIImageView!
    @IBOutlet weak var buttonViewIce: UIButton!
    @IBOutlet weak var buttonViewGreen: UIButton!
    @IBOutlet weak var buttonShop: UIButton!
    
    
    
    @IBAction func buttonIceTapped(_ sender: Any) {
        powerStatus = .freeze
        isTimerRunningIce = true
        timer.invalidate()
        timer = Timer(timeInterval: 0.15, repeats: true, block: { (_) in
            self.incrementMiliseconds()
        })
        RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        self.stopAnimationForView(self.imageWood)
        self.durationRotate = 3
        setUpTimer()
        iceNumber -= 1
        userDefault.set(iceNumber, forKey: "ice")
        iceNumber = userDefault.integer(forKey: "ice")
    }
    @IBAction func buttonGreenTapped(_ sender: Any) {
        buttonViewGreen.isUserInteractionEnabled = false
        circleProgress.greenPowerUp()
        greenActiveted = true
        greenNumber -= 1
        print(greenNumber)
    }
    @IBAction func startStopButtonTapped(_ sender: Any) {
        buttonTapped()
    }
    @IBAction func buttonBestTapped(_ sender: Any) {
        buttonGameCenter()
    }
    @IBAction func buttonScoreTapped(_ sender: Any) {
        buttonGameCenter()
    }
    @IBAction func buttonShop(_ sender: Any) {
        if isTimerRunning {
            timerStops()
            checkBestScore()
            checkerCirlceProgress = !checkerCirlceProgress
        }
    }
    
    
    ///Override
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shopController = segue.destination as? ShopController {
            shopController.acornNumber = acornNumber
            shopController.greenNumber = greenNumber
            shopController.iceNumber = iceNumber
            print("Acorn: \(shopController.acornNumber)")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        setupUserDefaultSetLabel()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfetti()
        shouldShowOverlayEffect(image: #imageLiteral(resourceName: "ScreenIced"), isHidden: true)
        authenticateLocalPlayer()
        setupUserDefaultSetLabel()
        showHideButtons()
    }
    
    func showHideButtons() {
        buttonViewIce.isHidden = !isTimerRunning
        buttonViewGreen.isHidden = !isTimerRunning
        buttonShop.isHidden = isTimerRunning
    }
    
    func shouldShowOverlayEffect(image: UIImage, isHidden: Bool) {
        containerViewController?.overlayEffectImageView.isHidden = isHidden
    }
    
    func setUpTimer() {
        self.rotate()
        circleProgress.pause()
        buttonViewIce.isUserInteractionEnabled = false
    }
    
    func timerStops() {
        ////Timer stops
        isTimerRunning = false
        timeIntervalIce.invalidate()
        isTimerRunningIce = false
        buttonViewGreen.isUserInteractionEnabled = false
        self.stopAnimationForView(self.imageWood)
        self.durationRotate = 0.9
        timer.invalidate()
        setUpTimer()
        startStopButton.setTitle("Start", for: .normal)
        self.stopAnimationForView(self.imageWood)
        if seconds >= 1 && suffix == 0 {
            score += 1
            acornNumber += 1
            userDefault.set(acornNumber, forKey: "acorn")
            acornNumber = userDefault.integer(forKey: "acorn")
            userDefault.set(best, forKey: "best")
            best = userDefault.integer(forKey: "best")
            circleProgress.fullColorWin()
        }else{
            count = 0
            if !greenActiveted {
                if score > best {
                    best = score
                    userDefault.set(best, forKey: "best")
                    best = userDefault.integer(forKey: "best")
                    confettiView.startConfetti()
                    print("Score: \(score)")
                    print("BEst: \(best)")
                }
    
                score = 0
                circleProgress.resetColor()
            }
            milliseconds = 0
        }
    }
    
    func checkCirlceProgress() {
        if checkerCirlceProgress == true {
            circleProgress.start()
            checkerCirlceProgress = false
        } else {
            circleProgress.pause()
            checkerCirlceProgress = true
        }
    }
    
    func buttonTapped() {
        checkCirlceProgress()
        if isTimerRunning {
            timerStops()
        }else{
            //Timer runs
            checkBestScore()
            confettiView.stopConfetti()
            timer.invalidate()
            if score <= 1 && greenActiveted {
                circleProgress.greenPowerUp()
            }else{
                circleProgress.resetColor()
                greenActiveted = false
            }
            count = 0
            isTimerRunningIce = false
            isTimerRunning = true
            shouldShowOverlayEffect(image: #imageLiteral(resourceName: "ScreenIced"), isHidden: true)
            timeIntervalIce.invalidate()
            startStopButton.setTitle("Stop", for: .normal)
            rotate()
            buttonViewIce.isUserInteractionEnabled = true
            buttonViewGreen.isUserInteractionEnabled = true
            
            if greenNumber == 0 {
                buttonViewGreen.isUserInteractionEnabled = false
                print(greenNumber)
            }else{
                buttonViewGreen.isUserInteractionEnabled = true
            }
            
            if iceNumber == 0 {
                buttonViewIce.isUserInteractionEnabled = false
            }else{
                buttonViewIce.isUserInteractionEnabled = true
            }
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
    
    
    func setupUserDefaultSetLabel() {
        best = userDefault.integer(forKey: "best")
        buttonBest.setTitle("Best: \(best)", for: .normal)
        
        print("\(boolCheckUserDefault) Eccolo")
        
        if boolCheckUserDefault {
            greenNumber = userDefault.integer(forKey: "green")
            buttonViewGreen.setTitle(String(greenNumber), for: .normal)
            iceNumber = userDefault.integer(forKey: "ice")
            buttonViewIce.setTitle(String(iceNumber), for: .normal)
            print("Lol \(iceNumber)")
            acornNumber = userDefault.integer(forKey: "acorn")
            labelAcorn.text = "\(acornNumber)"
            
        }else{
            if iceNumber == 0 {
                userDefault.set(5, forKey: "ice")
                iceNumber = userDefault.integer(forKey: "ice")
                buttonViewIce.setTitle(String(iceNumber), for: .normal)
            }
            if greenNumber == 0 {
                userDefault.set(5, forKey: "green")
                greenNumber = userDefault.integer(forKey: "green")
            }
            if acornNumber == 0 {
                userDefault.set(20, forKey: "acorn")
                acornNumber = userDefault.integer(forKey: "acorn")
                labelAcorn.text = "\(acornNumber)"
            }
            userDefault.set(true, forKey: "bool")
            boolCheckUserDefault = userDefault.bool(forKey: "bool")
        }
    }
    
    ////Game Center SetUp
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error)
            }
        }
    }
    
    func checkBestScore() {
        let bestScoreInt = GKScore(leaderboardIdentifier: leaderboardID)
        bestScoreInt.value = Int64(best)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
    
    func buttonGameCenter() {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = leaderboardID
        present(gcVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
