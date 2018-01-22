//
//  PowerUp.swift
//  TheSeconds
//
//  Created by Owner on 19/08/17.
//  Copyright © 2017 Edoardo de Cal. All rights reserved.
//

import Foundation

class PowerUp: NSObject {
    var cost: Int?
    var imageUrl: String?
    var title: String?
    var maximumLevels: Int?
    var backgroundEffectImageUrl: String?
    var text: String?
    ///var isOnSale: Bool?
    var tier: Int?
    
    init(dictionary: [String: Any]) {
        if let cost = dictionary["cost"] as? Int {
            self.cost = cost
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let name = dictionary["name"] as? String {
            self.title = name
        }
        
        if let levels = dictionary["maximumLevels"] as? Int {
            self.maximumLevels = levels
        }
        
        if let backgroundImageUrl = dictionary["backgroundEffectImageUrl"] as? String {
            self.backgroundEffectImageUrl = backgroundImageUrl
        }
        
        if let text = dictionary["description_it"] as? String {
            self.text = text
        }
        
        //if let onSale = dictionary["isOnSale"] as? Bool {
          //  self.isOnSale = onSale
        //}
        
        if let tier = dictionary["tier"] as? Int {
            self.tier = tier
        }
    }
}
