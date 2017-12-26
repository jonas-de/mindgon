//
//  MenuCard.swift
//  mindgon
//
//  Created by Jonas Andersson on 26.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import SpriteKit

enum CardTyp: Int {
    case normal, time, special
}

class MenuCard: SKSpriteNode {

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
        
        super.init(texture: gettexture(), color: .clear, size: CGSize(width: Values.cardwith, height: Values.cardwith * 1.5))
        self.position = CGPoint(x: safearea.midX, y: safearea.midY)
        self.scale(to: CGSize(width: safearea.width-100,
                              height: (safearea.width-100)*1.5))
        
        zRotation = getrotation()
        
        title.fontSize = 40
        title.fontColor = .white
        title.text = gettitle()
        title.position = CGPoint.zero
        addChild(title)
        /*
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
        switch typ {
        case .time:
            return "AUF ZEIT"
        case .special:
            return "SPEZIAL"
        default:
            return "NORMAL"
        }
    }
    
    func getrotation() -> CGFloat {
        switch typ {
        case .normal:
            return -0.05
        case .time:
            return 0
        case .special:
            return 0.05
        default:
            return 0
        }
    }
    
    
    
    
}
