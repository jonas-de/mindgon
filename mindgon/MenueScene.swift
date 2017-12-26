//
//  MenueScene.swift
//  mindgon
//
//  Created by Jonas Andersson on 24.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import SpriteKit

class MenueScene: SKScene {

    //MARK: - Attributes
    
    ///the frame in which the content is safely drawn
    var safeframe: CGRect!
    
    ///Day- / Nightmode (updates automatically)
    var lightmode: LightMode! {
        didSet{
            UserDefaults.standard.set(lightmode.rawValue, forKey: "lightmode")
        }
    }
    
    //MARK: - Nodes
    var lightmodeindicator: SKSpriteNode!
    var background: SKSpriteNode!
    
    
    //MARK: - Graphics
    lazy var lighttextures = [SKTexture(imageNamed: "mond"), SKTexture(imageNamed: "sonne")]

    //MARK: - Overridden functions
    
    override func didMove(to view: SKView) {
        safeframe = getsafearea()
        
        lightmode = LightMode(rawValue: UserDefaults.standard.integer(forKey: "lightmode"))!
        
        initializenodesfromeditor()
        initializenodesfromcode()
        
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
        }
    }
    
    
    //MARK: - Custom functions
    
    func switchlightmode(to: LightMode) {
        lightmode = to
        
        let changetexture = SKAction.animate(with: [lighttextures[lightmode.rawValue]], timePerFrame: 0)
        let buttonout = SKAction(named: "buttonout")!
        let butttonin = SKAction(named: "buttonin")!
        let buttoncomplete = SKAction.sequence([buttonout, changetexture, butttonin])
        
        
        let recolor = SKAction.sequence([SKAction.wait(forDuration: 0.1),
                                         SKAction.colorize(with: getnewbackgroundcolor(), colorBlendFactor: 0, duration: 0.2)])
        
        lightmodeindicator.run(buttoncomplete)
        background.run(recolor)
        
    }
    
    ///Setups the nodes created in MenueScene.sks
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
    
    
    
}




