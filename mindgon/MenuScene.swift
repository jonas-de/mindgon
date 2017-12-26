//
//  MenuScene.swift
//  mindgon
//
//  Created by Jonas Andersson on 24.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {

    //MARK: - Attributes
    
    ///the frame in which the content is safely drawn
    var safeframe: CGRect!
    
    ///Day- / Nightmode (updates automatically)
    var lightmode: LightMode! {
        didSet{
            UserDefaults.standard.set(lightmode.rawValue, forKey: "lightmode")
        }
    }
    
    ///Saves the touch of the card on the top of the stack
    var topcardtouch: UITouch?
    ///Startposition of the `topcardtouch`
    var topcardtouchorigin: CGPoint?
    
    //MARK: - Nodes
    var lightmodeindicator: SKSpriteNode!
    var settingsbutton: SKSpriteNode!
    var background: SKSpriteNode!
    
    var cards : [MenuCard]!
    
    
    //MARK: - Graphics
    lazy var lighttextures = [SKTexture(imageNamed: "mond"), SKTexture(imageNamed: "sonne")]
    lazy var settingstextures = [SKTexture(imageNamed: "zahnraddark"), SKTexture(imageNamed: "zahnradhell")]

    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        safeframe = getsafearea()
        
        lightmode = LightMode(rawValue: UserDefaults.standard.integer(forKey: "lightmode"))!
        
        initializenodesfromeditor()
        initializenodesfromcode()
        
        setupcardstack()
        var z: CGFloat = 1
        for card in cards! {
            card.zPosition=z
            
            z = z+1
            addChild(card)
        }
        
    }
    
    
    
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            //Handle touches on the Lightmodebutton
            if lightmodeindicator.contains(location) {
                if lightmode == .day {
                    switchlightmode(to: .night)
                } else {
                    switchlightmode(to: .day)
                }
            }
            
            //Handle card swipes
            if touch.isEqual(topcardtouch) {
                
                if (location.x > topcardtouchorigin!.x + 75) {
                    swipecards(right: true)
                } else if (location.x < topcardtouchorigin!.x - 75){
                    swipecards(right: false)
                }
                topcardtouch = nil
                topcardtouchorigin = nil
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            //Check if the topcard is touched
            if (cards[cards.count - 1].contains(location) && topcardtouch == nil){
                topcardtouch = touch
                topcardtouchorigin = location
            }
        }
    }
    
    
    //MARK: - Custom functions
    
    func switchlightmode(to: LightMode) {
        lightmode = to
        
        let changetexture = SKAction.setTexture(lighttextures[lightmode.rawValue])
        let buttonout = SKAction(named: "buttonout")!
        let butttonin = SKAction(named: "buttonin")!
        let buttoncomplete = SKAction.sequence([buttonout, changetexture, butttonin])
        
        
        let recolor = SKAction.sequence([SKAction.wait(forDuration: 0.1),
                                         SKAction.colorize(with: getnewbackgroundcolor(), colorBlendFactor: 0, duration: 0.2)])
        
        let changesettingstexture = SKAction.sequence([SKAction.wait(forDuration: 0.1),
                                                       SKAction.animate(with: [settingstextures[lightmode.rawValue]], timePerFrame: 0.2)])
        
        lightmodeindicator.run(buttoncomplete)
        background.run(recolor)
        settingsbutton.run(changesettingstexture)
        
    }
    
    
    ///Setups the nodes created in MenuScene.sks
    private func initializenodesfromeditor(){
        //background
        background = childNode(withName: "background") as! SKSpriteNode
        background.color = getnewbackgroundcolor()
    }
    
    
    ///Creates and setups the nodes programmatically
    private func initializenodesfromcode(){
        //lightmodebutton
        lightmodeindicator = SKSpriteNode(texture: lighttextures[lightmode.rawValue],
                                          color: .clear,
                                          size: CGSize(width: Values.lightmodesize, height: Values.lightmodesize))
        lightmodeindicator.position = CGPoint(x: safeframe.minX + lightmodeindicator.frame.width/2,
                                              y: safeframe.maxY - lightmodeindicator.frame.height/2)
        addChild(lightmodeindicator)
        
        
        //settings
        settingsbutton = SKSpriteNode(texture: settingstextures[lightmode.rawValue],
                                      color: .clear,
                                      size: CGSize(width: Values.settingsbtnsize, height: Values.settingsbtnsize))
        settingsbutton.position = CGPoint(x: safeframe.maxX - Values.settingsbtnsize/2, y: safeframe.maxY - Values.settingsbtnsize/2)
        addChild(settingsbutton)
        
    }
    
    private func showsafeframe(){
        let safenode = SKShapeNode(rect: safeframe)
        safenode.fillColor = .red
        safenode.strokeColor = .white
        addChild(safenode)
    }
    
    private func getnewbackgroundcolor() -> UIColor {
        if (lightmode == .day){
            return .white
        }
        return #colorLiteral(red: 0.1490000039, green: 0.1490000039, blue: 0.1490000039, alpha: 1)
    }
    
    private func swipecards(right: Bool) {
        
        if (right){
            
            //topcard -> down
             let topcard = cards.remove(at: cards.count - 1)
            
            let turnrightaction = SKAction.rotate(toAngle: -0.05, duration: 0.2)
            let turnleftaction = SKAction.rotate(toAngle: topcard.getrotation(), duration: 0.2)
            
            let scaleright = SKAction.scale(to: CGSize(width: safeframe.width-100 * 1.1,
                                                       height: (safeframe.width-100)*1.5*1.1),
                                            duration: 0.2)
            let scaleleft = SKAction.scale(to: CGSize(width: safeframe.width-100,
                                                      height: (safeframe.width-100)*1.5),
                                           duration: 0.2)
            
            let moverightaction = SKAction.moveBy(x: topcard.size.width + 15, y: 30, duration: 0.2)
            let adjustz = SKAction.run {
                for card in self.cards {
                    card.zPosition = card.zPosition + 1
                }
                topcard.zPosition = 1
            }
            
            let groupright = SKAction.group([turnrightaction, moverightaction, scaleright])
            let groupleft = SKAction.group([turnleftaction, moverightaction.reversed(), scaleleft])
            let complete = SKAction.sequence([groupright, adjustz, groupleft])
            
            topcard.run(complete, completion: {
                
                self.cards.insert(topcard, at: 0)
            })
        } else {
            //test: lowest card up
            let downcard = cards.remove(at: 0)
            
            
            
            let turnrightaction = SKAction.rotate(toAngle: downcard.getrotation(), duration: 0.2)
            let turnleftaction = SKAction.rotate(toAngle: 0.02, duration: 0.2)
            
            let scaleright = SKAction.scale(to: CGSize(width: safeframe.width-100,
                                                       height: (safeframe.width-100)*1.5),
                                            duration: 0.2)
            let scaleleft = SKAction.scale(to: CGSize(width: safeframe.width-100*1.1,
                                                      height: (safeframe.width-100)*1.5*1.1),
                                           duration: 0.2)
            
            
            let moveleftaction = SKAction.moveBy(x: -downcard.position.x - (getstackframe().maxX - getstackframe().minX) - 15, y: 30, duration: 0.2)
            let adjustz = SKAction.run {
                for card in self.cards {
                    card.zPosition = card.zPosition - 1
                }
                downcard.zPosition = self.cards[self.cards.count - 1].zPosition + 1
            }
            
            let groupright = SKAction.group([turnrightaction, moveleftaction.reversed(), scaleright])
            let groupleft = SKAction.group([turnleftaction, moveleftaction, scaleleft])
            let complete = SKAction.sequence([groupleft, adjustz, groupright])
            
            downcard.run(complete, completion: {

                self.cards.append(downcard)
            })
        }
        UserDefaults.standard.set(cards[cards.count-1].typ.rawValue, forKey: "menutopcard")
    }
    
    private func getstackframe() -> CGRect {
        var minx: CGFloat = 10000
        var miny: CGFloat = 10000
        var maxx: CGFloat = -10000
        var maxy: CGFloat = -10000
        
        for card in cards {
            if(card.frame.minX < minx){
                minx = card.frame.minX
            }
            if(card.frame.minY < miny){
                miny = card.frame.minY
            }
            if(card.frame.maxX > maxx){
                maxx = card.frame.maxX
            }
            if(card.frame.maxY > maxy){
                maxy = card.frame.maxY
            }
        }
        return CGRect(x: minx + (maxx - minx) / 2,
                      y: miny + (maxy - miny) / 2,
                      width: maxx - minx,
                      height: maxy - miny)
    }
    
    private func setupcardstack() {
        
        cards = [MenuCard(cardtyp: .special, safearea: safeframe),
                 MenuCard(cardtyp: .time, safearea: safeframe),
                 MenuCard(cardtyp: .normal, safearea: safeframe)]
        
        let topmode = CardTyp(rawValue: UserDefaults.standard.integer(forKey: "menutopcard"))
        
        while(cards[cards.count - 1].typ != topmode) {
            
            let topcard = cards.remove(at: 0)
            topcard.zPosition = cards[cards.count - 1].zPosition
            for card in cards {
                card.zPosition = card.zPosition - 1
            }
            cards.append(topcard)
        }
    }
    
    
    
}




