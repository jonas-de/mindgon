//
//  MenuCard.swift
//  mindgon
//
//  Created by Jonas Andersson on 26.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import SpriteKit


//MARK: - Enumerations

/// All possible gamemodes
enum CardTyp: Int {
    case normal, time, monochrom, special
}


/// A spritenode to choose the gamemode
class MenuCard: SKSpriteNode {

    
    //MARK: - Attributes
    
    ///The gamemodus that makes the difference between the cards
    var typ: CardTyp!
    
    ///saves the touch of the playbutton of the topcard
    var playbtntouch: UITouch?
    
    
    //MARK: - Nodes
    
    let title = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    let last = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    let best = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    var rim: SKShapeNode!
    var image: SKSpriteNode!
    var playbtn: SKSpriteNode!
    
    
    //MARK: - Textures
    
    lazy var cardtexture = SKTexture(imageNamed: "kartemenu")
    lazy var newhightexture = SKTexture(imageNamed: "kartenewhigh")
    
    
    //MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(cardtyp: CardTyp, safearea: CGRect) {
        
        typ = cardtyp
        super.init(texture: SKTexture(imageNamed: "kartemenu"),
                   color: .clear,
                   size: CGSize(width: 0.85 * safearea.width,
                                height: 0.85 * safearea.width * 1.5))
        self.position = CGPoint(x: safearea.midX, y: safearea.midY)
        
        setuprim()
        setupplaybtn()
        setupimage()
        
        title.fontSize = 35
        title.fontColor = .white
        title.text = gettitle()
        title.horizontalAlignmentMode = .left
        title.position = CGPoint(x: -self.size.width/2 + self.size.width * 0.08, y: (self.frame.height/2) - self.size.height * 0.11)
        addChild(title)
        
    }
    
    
    //MARK: - Setup
    
    ///setups the nodes to show the rim
    private func setuprim() {
        
        rim = SKShapeNode(rect: CGRect(x: -(self.size.width / 2),
                                       y: -(self.size.height / 2),
                                       width: self.size.width, height: self.size.height),
                          cornerRadius: 0.1 * self.size.width)
        
        rim.strokeColor = .white
        rim.lineWidth = 7.5
        
        addChild(rim)
    }
    
    private func setupplaybtn() {
        
        playbtn = SKSpriteNode(texture: SKTexture(imageNamed: "playbtn"),
                               color: .clear,
                               size: CGSize(width: 0.6 * self.size.width,
                                            height: 0.4 * 0.6 * self.size.width))
        playbtn.position = CGPoint(x: 0, y: -(self.size.height / 3))
        
        addChild(playbtn)
    }
    
    ///returns the texture of the symbolimage
    private func setupimage(){
        
        var texture: SKTexture
        
        switch typ {
        case .normal:
            texture = SKTexture(imageNamed: "normalbild")
        default:
            texture = SKTexture(imageNamed: "normalbild")
        }
        
        let factor: CGFloat = 0.6
        
        image = SKSpriteNode(texture: texture,
                             color: .clear,
                             size: CGSize(width: self.size.width * factor,
                                          height: self.size.width * factor))
        image.position = CGPoint(x: 0, y: self.size.width * factor * 0.025)
        addChild(image)
        
    }
    
    
    
    
    //MARK: - Getter
    
    ///return the texture of the card depending on the cardtyp
    private func gettexture() -> SKTexture {
        return cardtexture
    }
    
    ///returns the title of the card depending on the cardtyp as String
    private func gettitle() -> String {
        switch typ {
        case .time:
            return "AUF ZEIT"
        case .monochrom:
            return "MONOCHROM"
        case .special:
            return "SPEZIAL"
        default:
            return "NORMAL"
        }
    }
    
    ///returns the rotation of the card depending on the cardtyp as CGFloat
    func getrotation() -> CGFloat {
        switch typ {
        case .normal:
            return -0.105
        case .time:
            return -0.035
        case .monochrom:
            return 0.035
        case .special:
            return 0.105
        default:
            return 0
        }
    }
    
    
    //MARK: - Handle touches
    
    func didtouch(_ touch: UITouch) -> Bool {
        let loc = touch.location(in: self)
        if (playbtn.contains(loc)) {
            let bigger = SKAction.scale(to: 1.1, duration: 0.1)
            playbtn.run(bigger)
            playbtntouch = touch
            return true
        }
        return false
    }
    
    func didtouchreleased(_ touch: UITouch) {
        let loc = touch.location(in: self)
        if(touch.isEqual(playbtntouch)) {
            let normal = SKAction.scale(to: 1, duration: 0.1)
            playbtn.run(normal)
            playbtntouch = nil
            if (playbtn.contains(loc)) {
                print("play \(gettitle())")
            }
        }
    }
    
    
}
