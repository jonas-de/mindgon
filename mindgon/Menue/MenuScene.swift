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
    
    ///the cardstack as an array
    var cards : [MenuCard]!
    
    ///the frame in which the content is safely drawn
    var safeframe: CGRect!
    
    ///Indicates wheter the settings are open
    var opensettings = false
    
    ///Saves the touch of the card on the top of the stack
    var topcardtouch: UITouch?
    ///Startposition of the `topcardtouch`
    var topcardtouchorigin: CGPoint?
    
    
    //MARK: - Nodes
    
    var settingsbutton: SKSpriteNode!
    var settingsfield: Settingsmenu!
    var settingsfocus: SKSpriteNode!
    
    
    //MARK: - Textures
    let settingstexture = SKTexture(imageNamed: "zahnrad")

    
    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        safeframe = getsafearea()
        //showsafeframe()

        initializenodesfromcode()
        
        setupcardstack()
    }
    
    
    //MARK: - Custom initializer
    
    ///Creates and setups the nodes programmatically
    private func initializenodesfromcode(){
        //Settings
        let settingsfactor: CGFloat = 0.12
        settingsbutton = SKSpriteNode(texture: settingstexture,
                                      color: .clear,
                                      size: CGSize(width: safeframe.width * settingsfactor,
                                                   height: safeframe.width * settingsfactor))
        settingsbutton.position = CGPoint(x: safeframe.maxX - safeframe.width * settingsfactor * 0.5,
                                          y: safeframe.maxY - safeframe.width * settingsfactor * 0.5)
        addChild(settingsbutton)
        
        //Settingsfocus
        settingsfocus = SKSpriteNode(color: #colorLiteral(red: 0.1180000007, green: 0.1570000052, blue: 0.2349999994, alpha: 1), size: self.size)
        settingsfocus.zPosition = 9
    }
    
    
    //MARK: - Handle touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let topcard = cards[cards.count - 1]
        for touch in touches {
            let location = touch.location(in: self)
            
            //Check if the topcard is touched
            if (topcard.contains(location) &&
                topcardtouch == nil &&
                !opensettings &&
                !topcard.didtouch(touch)) {
                
                topcardtouch = touch
                topcardtouchorigin = location
            }
            
            //Handle settings
            if (opensettings) {
                let loc = self.convert(location, to: settingsfield)
                settingsfield.starttouch(loc)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            
            //Handle setting
            if settingsbutton.contains(location) && !opensettings{
                doopensettings()
            } else if(opensettings){
                if (settingsfield.contains(location)){
                    let loc = self.convert(location, to: settingsfield)
                    settingsfield.endtouch(loc)
                } else {
                    closesettings()
                }
            }
            
            //Handle play
            cards[cards.count - 1].didtouchreleased(touch)
            
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
    
    
    //MARK: - Handle cardstack
    
    private func swipecards(right: Bool) {
        
        if (right){
            
            //topcard -> down
             let topcard = cards.remove(at: cards.count - 1)
            
            let turnrightaction = SKAction.rotate(toAngle: -0.05, duration: 0.2)
            let turnleftaction = SKAction.rotate(toAngle: topcard.getrotation(), duration: 0.2)
            
            let scaleright = SKAction.scale(to: CGSize(width: safeframe.width*0.85 * 1.1,
                                                       height: (safeframe.width*0.85)*1.5*1.1),
                                            duration: 0.2)
            let scaleleft = SKAction.scale(to: CGSize(width: safeframe.width*0.85,
                                                      height: (safeframe.width*0.85)*1.5),
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
            
            let scaleright = SKAction.scale(to: CGSize(width: safeframe.width*0.85,
                                                       height: (safeframe.width*0.85)*1.5),
                                            duration: 0.2)
            let scaleleft = SKAction.scale(to: CGSize(width: safeframe.width*0.85*1.1,
                                                      height: (safeframe.width*0.85)*1.5*1.1),
                                           duration: 0.2)
            
            
            let moveleftaction = SKAction.moveBy(x: -downcard.size.width - 15, y: 30, duration: 0.2)
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
    
    private func setupcardstack() {
        
        //Create cards
        cards = [MenuCard(cardtyp: .special, safearea: safeframe),
                 MenuCard(cardtyp: .monochrom, safearea: safeframe),
                 MenuCard(cardtyp: .time, safearea: safeframe),
                 MenuCard(cardtyp: .normal, safearea: safeframe)]
        
        //Set z-coordinate
        var z: CGFloat = 1
        for card in cards {
            card.zPosition=z
            z = z+1
            addChild(card)
        }
        
        //Set rotation with animation
        for card in cards {
            card.run(SKAction.sequence([SKAction.wait(forDuration: 0.2),
                                        SKAction.rotate(toAngle: card.getrotation(), duration: 0.2)]))
            }
        
        //Change the stack so that the last saved topcard is topcard again
        let topmode = GameTyp(rawValue: UserDefaults.standard.integer(forKey: "menutopcard"))
        while(cards[cards.count - 1].typ != topmode) {
            let topcard = cards.remove(at: 0)
            topcard.zPosition = cards[cards.count - 1].zPosition
            for card in cards {
                card.zPosition = card.zPosition - 1
            }
            cards.append(topcard)
        }
    }
    
    
    //MARK: - Handle Settings
    
    private func doopensettings() {
        
        if(settingsfield == nil){
            settingsfield = Settingsmenu(safeframe: safeframe)
        }
        addChild(settingsfield)
        
        opensettings = true
        
        settingsbutton.run(SKAction.rotate(byAngle: -0.6, duration: 0.2))
        settingsfocus.run(SKAction.fadeAlpha(to: 0.6, duration: 0.2))
        settingsfield.run(SKAction.fadeIn(withDuration: 0.2), completion: {
            self.settingsfield.shownodes()
        })
    }
    
    private func closesettings() {
        
        opensettings = false
        
        let fadeout = SKAction.fadeOut(withDuration: 0.2)
        
        settingsfield.closenodes()
        
        settingsbutton.run(SKAction.rotate(byAngle: 0.6, duration: 0.2))
        settingsfocus.run(fadeout)
        settingsfield.run(fadeout, completion: {
            self.settingsfield.removeFromParent()
        })
    
    }
    
    
    //MARK: - Debug
    
    private func showsafeframe(){
        let safenode = SKShapeNode(rect: self.safeframe)
        safenode.fillColor = .red
        safenode.strokeColor = .white
        addChild(safenode)
    }
}





