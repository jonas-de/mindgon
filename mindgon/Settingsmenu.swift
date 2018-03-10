//
//  Settingsmenu.swift
//  mindgon
//
//  Created by Jonas Andersson on 26.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import SpriteKit

class Settingsmenu: SKSpriteNode {

    //MARK: - Attributes
    var lightmode: LightMode!
    var shouldvibrate = UserDefaults.standard.bool(forKey: "settingsvibration") {
        didSet {
            UserDefaults.standard.set(shouldvibrate, forKey: "settingsvibration")
            self.setvibrationtexture()
        }
    }
    
    
    //MARK: - Nodes
    var vibration: SKSpriteNode!
    
    //MARK: - Textures
    lazy var lighttexture = SKTexture(imageNamed: "settingsfieldhell")
    lazy var darktexture = SKTexture(imageNamed: "settingsfielddark")
    
    lazy var vibrationonhelltexture = SKTexture(imageNamed: "vibrationonhell")
    lazy var vibrationondarktexture = SKTexture(imageNamed: "vibrationondark")
    lazy var vibrationoffhelltexture = SKTexture(imageNamed: "vibrationoffhell")
    lazy var vibrationoffdarktexture = SKTexture(imageNamed: "vibrationoffdark")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(safeframe: CGRect, lm: LightMode){

        lightmode = lm
        
        
        super.init(texture: getfieldtexture(),
                   color: .clear,
                   size: CGSize(width: 375, height: 125))
        
        
        self.position = CGPoint(x: safeframe.midX, y: safeframe.midY)
        self.zPosition = 10
        
        
        vibration = SKSpriteNode(texture: getvibrationtexture(), color: .clear, size: CGSize(width: 80, height: 80))
        vibration.position = CGPoint.zero
        vibration.alpha = 0
        addChild(vibration)
    }
    
    func setnodes(){
        let appear = SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction(named: "appear")!])
        vibration.run(appear)
    }
    
    private func getfieldtexture() -> SKTexture {
        if lightmode == .day {
            return lighttexture
        }
        return darktexture
    }
    
    private func gettitlecolor() -> UIColor {
        if lightmode == .day {
            return #colorLiteral(red: 0.1490000039, green: 0.1490000039, blue: 0.1490000039, alpha: 1)
        }
        return .white
    }
    
    private func getvibrationtexture() -> SKTexture {
        if (lightmode == .day) {
            if (shouldvibrate){
                return vibrationondarktexture
            }
            return vibrationoffdarktexture
        }
        if(shouldvibrate){
            return vibrationonhelltexture
        }
        return vibrationoffhelltexture
        
    }
    
    private func setvibrationtexture() {
        let scalesmaller = SKAction.scale(to: 0.8, duration: 0.125)
        let scalebigger = SKAction.scale(to: 1.0, duration: 0.125)
        vibration.run(scalesmaller, completion: {
            self.vibration.texture = self.getvibrationtexture()
            self.vibration.run(scalebigger)
        })
        
    }
    
    func handletouch(_ l: CGPoint) {
        
        //Check vibration
        if (vibration.contains(l) && shouldvibrate ) {
            shouldvibrate = false
        } else if (vibration.contains(l)){
            shouldvibrate = true
        }
        
    }
    
    
}
