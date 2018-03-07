//
//  ShopController.swift
//  TheSeconds
//
//  Created by Owner on 19/08/17.
//  Copyright © 2017 Edoardo de Cal. All rights reserved.
//

import UIKit
import Kingfisher

class ShopController: UIViewController, UICollectionViewDelegateFlowLayout {

    var powerUps = [PowerUp]()

    @IBAction func backButtonTapped(_ sender: Any) {
    
    }
    
let cellIdentifier = "cellIdentifier"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var acornNumber = 0
    var iceNumber = 0
    var greenNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        observePowerUps()
        labelAcorn.text = "\(acornNumber)"
        labelGreen.text = "\(greenNumber)"
        labelIce.text = "\(iceNumber)"
        print(acornNumber)
        print(iceNumber)
        print(greenNumber)
    }
    
    
    @IBOutlet weak var labelAcorn: UILabel!
    
    @IBOutlet weak var labelIce: UILabel!
    @IBOutlet weak var labelGreen: UILabel!
    internal func observePowerUps() {
        APIService.observePowerUps {
            (powerUp) in
            self.powerUps.append(powerUp)
            self.powerUps = self.powerUps.sorted(by: { (p1, p2) -> Bool in
                if let tier1 = p1.tier, let tier2 = p1.tier {
                    return tier1 < tier2
                } else {
                    return true
                }
            })
            self.collectionView.reloadData()
        }
    }
    
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let numberOfCells = Int(view.frame.width/2)
        print("OK YOU HAVE", numberOfCells, "CELLS")
        print("ruota!!!")
    }
}

// MARK: - Setup
extension ShopController {
    internal func setupTableView() {
        collectionView.register(UINib(nibName:"ShopTableViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
    }
}

extension ShopController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if view.frame.width == 320 {
            return CGSize(width: 320, height: 192)

        }
        return CGSize(width: 365, height: 237)
    }
}

extension ShopController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return powerUps.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ShopTableViewCell
        
        let powerUp = powerUps[indexPath.row]
        cell.titleLabel.text = powerUp.title
       
        
        if let cost = powerUp.cost {
            cell.labelPrize.text = String(describing: cost)
        }
        
        if let text = powerUp.text {
            cell.labelDescription.text = text
        }
        
        if let imageUrl = powerUp.imageUrl {
            let url = URL(string: imageUrl)
            cell.leftImageView.kf.setImage(with: url)
        } else {
            cell.leftImageView.image = nil
            
        }
        
        
        ///if let onSale = powerUp.isOnSale {
           // cell.saleRibbonImageView.isHidden = !onSale
        //} else {
          ///  cell.saleRibbonImageView.isHidden = true
       // }
        
        
        return cell
    }
    
    ////https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/CreateATableView.html per risolvere immagini offline
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Hello")
        
        if acornNumber >= 5 {
            acornNumber -= 5
            UserDefaults.standard.set(acornNumber, forKey: "acorn")
            if indexPath.row == 0 {
                greenNumber += 1
                UserDefaults.standard.set(greenNumber, forKey: "green")
            }else{
                iceNumber += 1
                UserDefaults.standard.set(iceNumber, forKey: "ice")
            }
            labelAcorn.text = "\(acornNumber)"
            labelGreen.text = "\(greenNumber)"
            labelIce.text = "\(iceNumber)"
        }
    
    }
    
    func buttonAction(sender: UIButton) {
        print("Ciao")
    }
    
}
