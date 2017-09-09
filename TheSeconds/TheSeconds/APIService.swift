//
//  APIService.swift
//  TheSeconds
//
//  Created by Owner on 03/09/17.
//  Copyright © 2017 Edoardo de Cal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class APIService: NSObject {
    class func observePowerUps(completion: ((_ powerUp: PowerUp) -> Void)?) {
        Database.database().reference().child("power-ups").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let powerUp = PowerUp(dictionary: dictionary)
                completion?(powerUp)
            }
        }, withCancel: nil)
    }
}
