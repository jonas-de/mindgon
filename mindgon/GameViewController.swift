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
    
    
    //MARK: - Overridden methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        firststartsetup()
        
    }
    
    override func viewWillLayoutSubviews() {
        if let view = self.view as! SKView? {
            
            // Load the SKScene from 'MenuScene.sks'
            if let scene = MenuScene(fileNamed: "MenuScene") {
                
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
    
    
    //MARK: - Custom functions
    
    ///Initializes the settings when the app is started the first time
    private func firststartsetup() {
        let defs = UserDefaults.standard
        if (!defs.bool(forKey: "firststartsetup")) {
            
            defs.set(true, forKey: "firststartsetup")
            defs.set(true, forKey: "settingsvibration")
            
        }
    }
}
