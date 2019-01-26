//
//  GameType.swift
//  mindgon
//
//  Created by Jonas Andersson on 30.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit

/**
 All possible gamemodes
 - ## cases:
     - normal
     - time
     - monochrom
     - special
*/
enum GameType: Int {
    
    //MARK: - Cases
    
    case normal, time, monochrom, special
    
    //MARK: - Attributes
    
    ///computed property that returns the id of the given gametype
    var id: String {
        
        switch self {
        
        case .normal:
        
            return "normal"
        
        case .time:
        
            return "time"
        
        case .monochrom:
        
            return "monochrome"
        
        case .special:
        
            return "special"
        
        }
        
    }
    
    ///computed property that returns a localized name of the given gametype as a String
    var name: String {
        
        return "\(self.id)title".localized
        
    }
    
    ///computed property that returns the rotation for a card in the menu that represents the given gametype
    var rotation: CGFloat {
        
        switch self {
        
        case .normal:
        
            return -0.105
        
        case .time:
        
            return -0.035
        
        case .monochrom:
        
            return 0.035
       
        case .special:
            
            return 0.105
        
        }
        
    }
    
    ///computed property that returns a symbolImage for the gametype representating `menuCard
    var image: SKTexture {
        
        switch self {
            
        case .normal:
            
            return SKTexture(imageNamed: "normalbild")
            
        default:
            
            return SKTexture(imageNamed: "normalbild")
            
        }
        
    }
    
}
