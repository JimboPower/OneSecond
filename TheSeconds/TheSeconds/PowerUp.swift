//
//  PowerUp.swift
//  TheSeconds
//
//  Created by Owner on 19/08/17.
//  Copyright © 2017 Edoardo de Cal. All rights reserved.
//

import UIKit

class PowerUp: NSObject {
    var cost: Int?
    var title: String?
    var text: String?
    var image: UIImage?
    
    init(title: String, text: String, cost: Int) {
        super.init()
        self.cost = cost
        self.title = title
        self.text = text
    }
}
