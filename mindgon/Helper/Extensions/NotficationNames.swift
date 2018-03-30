//
//  NotficationNames.swift
//  mindgon
//
//  Created by Jonas Andersson on 30.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit


extension Notification.Name {
    
    ///Notification to inform the `GameViewController` that he should present the menu
    static let showmenu = Notification.Name("showmenu")
    
    /**
     Notification to inform the `GameViewController` that he should present a game scene
     - Warning: information about the game type must be delivered in the data
    */
    static let startgame = Notification.Name("startgame")
    
}
