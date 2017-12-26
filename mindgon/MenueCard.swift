//
//  MenueCard.swift
//  mindgon
//
//  Created by Jonas Andersson on 26.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import SpriteKit

enum CardTyp: Int {
    case normal, time
}

class MenueCard: SKSpriteNode {

    //MARK: - Attributes
    
    ///The gamemodus that makes the difference between the cards
    var typ: CardTyp!
    
    
    //MARK: - Nodes
    let title = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    let last = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    let best = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    
    
    //MARK: - Initializer
    
    init(cardtyp: CardTyp, safearea: CGRect) {
        
        typ = cardtyp
        
        super.init(texture: gettexture(), color: .clear, size: CGSize(width: 600, height: 900))
        self.position = CGPoint(x: safearea.midX, y: safearea.midY)
        
        /*
        title.fontSize = 40
        title.fontColor = .white
        title.text = gettitle()
        
        last.text = "\(UserDefaults.standard.integer(forKey: "\(gettitle())last"))"
        best.text = "\(UserDefaults.standard.integer(forKey: "\(gettitle())best"))"
        */
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Custom functions
    private func gettexture() -> SKTexture {
        return SKTexture(imageNamed: "card")
    }
    
    private func gettitle() -> String {
        return "NORMAL"
    }
    
    
    
    
}
