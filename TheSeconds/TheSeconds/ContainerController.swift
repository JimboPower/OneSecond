//
//  ContainerController.swift
//  TheSeconds
//
//  Created by Owner on 19/08/17.
//  Copyright © 2017 Edoardo de Cal. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var overlayEffectImageView: UIImageView!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "main" {
            if let mainVC = segue.destination as? ViewController {
                mainVC.containerViewController = self
            }
        }
    }
}
