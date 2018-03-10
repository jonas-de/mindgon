//
//  MenuCard.swift
//  mindgon
//
//  Created by Jonas Andersson on 26.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import SpriteKit

//MARK: - Enumeration

/// All possible gamemodes
enum CardTyp: Int {
    case normal, time, special
}

//MARK: - Class

/// A spritenode to choose the gamemode
class MenuCard: SKSpriteNode {

    
    //MARK: - Attributes
    
    ///The gamemodus that makes the difference between the cards
    var typ: CardTyp!
    
    ///the lightmode of the menuscene
    var lightmode: LightMode! {
        didSet {
            setrim()
        }
    }
    
    ///saves the touch of the playbutton of the topcard
    var playbtntouch: UITouch?
    
    
    //MARK: - Nodes
    let title = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    let last = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    let best = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    var rimhell: SKShapeNode!
    var rimdark: SKShapeNode!
    var image: SKSpriteNode!
    var playbtn: SKSpriteNode!
    var playbtnrim: SKShapeNode!
    var scalefactor: CGFloat!
    
    
    //MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(cardtyp: CardTyp, safearea: CGRect, lm: LightMode) {
        
        lightmode = lm
        typ = cardtyp
        
        super.init(texture: gettexture(), color: .clear, size: CGSize(width: Values.cardwith, height: Values.cardwith * 1.5))
        
        self.position = CGPoint(x: safearea.midX, y: safearea.midY)
        let oldwidth = self.size.width
        self.scale(to: CGSize(width: safearea.width-100,
                              height: (safearea.width-100)*1.5))
        scalefactor = self.size.width / oldwidth
        print("width: \(scalefactor!)")
        
        
        setuprim()
        
        //symbol image
        image = SKSpriteNode(texture: getimage(),
                             color: .clear,
                             size: CGSize(width: 300, height: 300))
        addChild(image)
        
        setupplaybtn()
        
        
        title.fontSize = 75
        title.fontColor = .white
        title.text = gettitle()
        title.horizontalAlignmentMode = .left
        title.position = CGPoint(x: self.frame.minX + 50, y: (self.frame.height/2) - 120)
        addChild(title)
        
    }
    
    
    //MARK: - Setup
    
    ///setups the nodes to show the rim
    private func setuprim() {
        
        rimhell = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 600, height: 900), cornerRadius: 60)
        rimdark = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 600, height: 900), cornerRadius: 60)
        
        rimhell.run(SKAction.scale(by: scalefactor, duration: 0))        
        rimdark.run(SKAction.scale(by: scalefactor, duration: 0))
        
        rimhell.position = CGPoint(x: -(self.size.width/2), y: -(self.size.height/2))
        rimhell.strokeColor = .white
        rimhell.lineWidth = 17.5
        
        rimdark.position = CGPoint(x: -(self.size.width/2), y: -(self.size.height/2))
        rimdark.strokeColor = #colorLiteral(red: 0.1490000039, green: 0.1490000039, blue: 0.1490000039, alpha: 1)
        rimdark.lineWidth = 17.5
        
        if (lightmode == .day) {
            rimhell.alpha = 0
            addChild(rimdark)
        } else {
            rimdark.alpha = 0
            addChild(rimhell)
        }
    }
    
    private func setupplaybtn() {
        
        playbtn = SKSpriteNode(texture: SKTexture(imageNamed: "playbtn"),
                               color: .clear,
                               size: CGSize(width: 300, height: 120))
        playbtn.position = CGPoint(x: 0, y: -(self.size.height/2) + 200)
        addChild(playbtn)
        /*
        playbtnrim = SKShapeNode(rect: CGRect(x: (-(playbtn.size.width/2)+5),
                                              y: playbtn.position.y-(playbtn.size.height/2)+5,
                                              width: 290,
                                              height: 110),
                                 cornerRadius: 20)
        playbtnrim.lineWidth = 7.5
        playbtnrim.strokeColor = .white
        addChild(playbtnrim)
        */
        
    }
    
    
    
    
    //MARK: - Getter
    
    ///return the texture of the card depending on the cardtyp
    private func gettexture() -> SKTexture {
        return SKTexture(imageNamed: "kartemenu")
    }
    
    ///returns the title of the card depending on the cardtyp as String
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
    
    ///returns the texture of the symbolimage
    private func getimage() -> SKTexture {
        switch typ {
        default:
            return SKTexture(imageNamed: "normalbild")
        }
    }
    
    ///returns the rotation of the card depending on the cardtyp as CGFloat
    func getrotation() -> CGFloat {
        switch typ {
        case .normal:
            return -0.07
        case .special:
            return 0.07
        default:
            return 0
        }
    }
    
    
    //MARK: - Setter
    func setrim(){
        let fadein = SKAction.fadeIn(withDuration: 0.2)
        if(lightmode == .day) {
            addChild(rimdark)
            rimdark.run(fadein, completion: {
                self.rimhell.removeFromParent()
                self.rimhell.alpha = 0
            })
        } else {
            addChild(rimhell)
            rimhell.run(fadein, completion: {
                self.rimdark.removeFromParent()
                self.rimdark.alpha = 0
            })
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
    
    func didtouchcancel(_ touch: UITouch) {
        if(touch.isEqual(playbtntouch)) {
            let normal = SKAction.scale(to: 1, duration: 0.1)
            playbtn.run(normal)
            playbtntouch = nil
        }
        
        
    }
    
    
}
