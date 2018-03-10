//
//  GameViewController.swift
//  mindgon
//
//  Created by Jonas Andersson on 24.12.17.
//  Copyright © 2017 bambuzleapps. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

enum LightMode: Int {
    case day, night
}


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
    
    
    //MARK: - Overridden methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        if let view = self.view as! SKView? {
            
            // Load the SKScene from 'MenuScene.sks'
            if let scene = MenuScene(fileNamed: "MenuScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    
}
