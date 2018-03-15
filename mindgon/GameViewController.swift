//
//  GameViewController.swift
//  mindgon
//
//  Created by Jonas Andersson on 24.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    
    //MARK: - Attributes
    
    ///the standard UserDefaultsObject
    let defaults = UserDefaults.standard
    
    
    //MARK: - Overridden attributes
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    
    //MARK: - Scenes
    lazy var menu = MenuScene(fileNamed: "MenuScene")
    lazy var normalgame = NormalScene(fileNamed: "NormalScene")
    lazy var timegame = TimeScene(fileNamed: "TimeScene")
    lazy var monogame = MonoScene(fileNamed: "MonoScene")
    lazy var specialgame = SpecialScene(fileNamed: "SpecialScene")
    
    
    //MARK: - Overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firststartsetup()
        
    }
    
    override func viewWillLayoutSubviews() {
        if let view = self.view as! SKView? {
            
            // Load the SKScene from 'MenuScene.sks'
            if let scene = menu {
                
                //Setup the scene
                scene.size = view.bounds.size
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            //Debug
            let shoulddebug: Bool = true
            view.showsFPS = shoulddebug
            view.showsNodeCount = shoulddebug
            view.showsDrawCount = shoulddebug
            view.showsQuadCount = shoulddebug
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("add observers")
        NotificationCenter.default.addObserver(self, selector: #selector(showmenu(_:)), name: .showmenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startgame(_:)), name: .startgame, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    //MARK: - Custom functions
    
    ///Initializes the settings when the app is started the first time
    private func firststartsetup() {
        let defs = UserDefaults.standard
        if (!defs.bool(forKey: "firststartsetup")) {
            
            defs.set(true, forKey: "firststartsetup")
            defs.set(true, forKey: "settingsvibration")
            
        }
    }
    
    private func getscene(forgametyp typ: GameTyp) -> SKScene? {
        
        switch (typ) {
        case .normal:
            return normalgame
        case .time:
            return timegame
        case .monochrom:
            return monogame
        case .special:
            return specialgame
        }
        
    }
    
    
    //MARK: - Handle scenes
    
    @objc func showmenu(_ notification: Notification) {
        if let scene = menu {
            
            if let view = self.view as! SKView? {
                let transition = SKTransition.fade(with: #colorLiteral(red: 0.1180000007, green: 0.1570000052, blue: 0.2349999994, alpha: 1), duration: 1)
                
                //Setup the scene
                scene.size = view.bounds.size
                scene.scaleMode = .aspectFill
                
                view.presentScene(scene, transition: transition)
                
            }
        }
    }
    
    @objc func startgame(_ notification: Notification) {
        print("start game")
        
        var typ: GameTyp = .normal
        if let data = notification.userInfo {
            typ = GameTyp(rawValue: (data["typ"] as? Int ?? 0) ) ?? .normal
        }
        
        print(typ)
        if let scene = getscene(forgametyp: typ) {
            print("hasscene")
            if let view = self.view as! SKView? {
                let transition = SKTransition.fade(with: #colorLiteral(red: 0.1180000007, green: 0.1570000052, blue: 0.2349999994, alpha: 1) , duration: 1)
                
                //Setup the scene
                scene.size = view.bounds.size
                scene.scaleMode = .aspectFill
                
                view.presentScene(scene, transition: transition)
            }
        }
    }
}
