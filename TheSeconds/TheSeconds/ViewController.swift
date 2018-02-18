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
    var boolCheckUserDefault: Bool = UserDefaults.standard.bool(forKey: "bool")
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
    let userDefault = UserDefaults.standard
    var radiusCircle = CGFloat(0)
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    let leaderboardID = "com.score.OneSecond"
    var greenActiveted = false
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserDefaultSetLabel()
    }
    
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
            labelGreenNumber.text = "\(greenNumber)"

        }
    }
    
    var number = 0
    
    var iceNumber = UserDefaults.standard.integer(forKey: "ice") {
        didSet{
            userDefault.set(iceNumber, forKey: "ice")
            labelIceNumber.text = "\(iceNumber)"
            iceNumber = userDefault.integer(forKey: "ice")
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfetti()
        shouldShowOverlayEffect(image: #imageLiteral(resourceName: "ScreenIced"), isHidden: true)
        authenticateLocalPlayer()
        buttonViewGreen.isUserInteractionEnabled = false
        buttonViewIce.isUserInteractionEnabled = false
        setupUserDefaultSetLabel()
    }
    

    
    
    func setupUserDefaultSetLabel() {
        best = userDefault.integer(forKey: "best")
        buttonBest.setTitle("Best: \(best)", for: .normal)
        
        if boolCheckUserDefault {
        
        if iceNumber == 0 {
            userDefault.set(5, forKey: "ice")
            iceNumber = userDefault.integer(forKey: "ice")
            labelIceNumber.text = "\(iceNumber)"
        }
        
        if greenNumber == 0 {
            userDefault.set(5, forKey: "green")
            greenNumber = userDefault.integer(forKey: "green")
            labelGreenNumber.text = "\(greenNumber)"
        }
        
        if acornNumber == 0 {
            userDefault.set(20, forKey: "acorn")
            acornNumber = userDefault.integer(forKey: "acorn")
            labelAcorn.text = "\(acornNumber)"
        }
            
        userDefault.set(false, forKey: "bool")
        boolCheckUserDefault = userDefault.bool(forKey: "bool")
            
        }else{
            greenNumber = userDefault.integer(forKey: "green")
            labelGreenNumber.text = "\(greenNumber)"
            
            iceNumber = userDefault.integer(forKey: "ice")
            labelIceNumber.text = "\(iceNumber)"
            print("Lol \(iceNumber)")
            
            acornNumber = userDefault.integer(forKey: "acorn")
            labelAcorn.text = "\(acornNumber)"
        }
    }
    
    @IBAction func buttonBestTapped(_ sender: Any) {
        buttonGameCenter()
    }
    
    @IBAction func buttonScoreTapped(_ sender: Any) {
        buttonGameCenter()
    }
    
    
    @IBAction func buttonShop(_ sender: Any) {
        checkCirlceProgress()
        timerStops()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shopController = segue.destination as? ShopController {
            shopController.acornNumber = acornNumber
            shopController.greenNumber = greenNumber
            shopController.iceNumber = iceNumber
            print("Acorn: \(shopController.acornNumber)")
        }
    }
    
    @IBOutlet weak var labelAcorn: UILabel!
    @IBOutlet weak var buttonBest: UIButton!
    @IBOutlet weak var buttonScore: UIButton!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var imageWood: UIImageView!
    @IBAction func startStopButtonTapped(_ sender: Any) {
        buttonTapped()
    }
    
    @IBOutlet weak var labelIceNumber: UILabel!
    @IBOutlet weak var labelGreenNumber: UILabel!
    
    @IBOutlet weak var buttonViewIce: UIButton!
    @IBOutlet weak var buttonViewGreen: UIButton!
    
    func shouldShowOverlayEffect(image: UIImage, isHidden: Bool) {
        containerViewController?.overlayEffectImageView.isHidden = isHidden
    }
    
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
            userDefault.set(best, forKey: "best")
            circleProgress.fullColorWin()
        }else{
            if !greenActiveted {
                score = 0
                circleProgress.resetColor()
            }
            milliseconds = 0
        }
        count = 0
    }
    func checkCirlceProgress() {
        if prova == true {
            circleProgress.start()
            prova = false
        } else {
            circleProgress.pause()
            prova = true
        }
    }
    
    func buttonTapped() {
        checkCirlceProgress()
        if isTimerRunning {
            timerStops()
        }else{
            //Timer runs
            checkBestScore()
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
