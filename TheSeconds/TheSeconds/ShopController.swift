//
//  ShopController.swift
//  TheSeconds
//
//  Created by Owner on 19/08/17.
//  Copyright © 2017 Edoardo de Cal. All rights reserved.
//

import UIKit

class ShopController: UIViewController {

    var powerUps = [PowerUp]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        let icePowerUp = PowerUp(title: "Ice Freeze", text: "Serve a rallentare il tempo.", cost: 40)
        powerUps.append(icePowerUp)
    }
}

// MARK: - Setup
extension ShopController {
    internal func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: ShopTableViewCell.identifier, bundle: .main), forCellReuseIdentifier: ShopTableViewCell.identifier)
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
        return cell
    }
}
