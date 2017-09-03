//
//  ShopController.swift
//  TheSeconds
//
//  Created by Owner on 19/08/17.
//  Copyright © 2017 Edoardo de Cal. All rights reserved.
//

import UIKit
import Kingfisher

class ShopController: UIViewController {

    var powerUps = [PowerUp]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        observePowerUps()
    }
    
    internal func observePowerUps() {
        APIService.observePowerUps { (powerUp) in
            self.powerUps.append(powerUp)
            self.tableView.reloadData()
        }
    }
}

// MARK: - Setup
extension ShopController {
    internal func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: ShopTableViewCell.identifier, bundle: .main), forCellReuseIdentifier: ShopTableViewCell.identifier)
        tableView.separatorColor = .clear
    }
}

extension ShopController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

extension ShopController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return powerUps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopTableViewCell.identifier, for: indexPath) as! ShopTableViewCell
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
        return cell
    }
}
