//
//  MenuActions.swift
//  mindgon
//
//  Created by Jonas Andersson on 29.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit

extension MenuScene {
    
    
    //MARK: - Actions and attributes for the Settings
    
    var settingsAnimationDuration: TimeInterval {
        
        return 0.2
        
    }
    
    func animateSettingsButton() -> SKAction {
        
        return SKAction.rotate(byAngle: -0.78,
                               duration: settingsAnimationDuration)
    
    }
    
    func animateSettingsFocus() -> SKAction {
        
        return SKAction.fadeAlpha(to: 0.75,
                                  duration: settingsAnimationDuration)
        
    }
    
    func animateSettingsMenu() -> SKAction {
        
        return SKAction.fadeIn(withDuration: settingsAnimationDuration)
        
    }
    
    func animateCloseSettings() -> SKAction {
        
        return SKAction.fadeOut(withDuration: settingsAnimationDuration)
        
    }
    
    
    //MARK: - Actions for the cardStack
    
    func animateCardRotation(_ gametype: GameType) -> SKAction {
        
        let rotation = SKAction.rotate(toAngle: gametype.rotation, duration: 0.2)
        rotation.timingMode = .easeOut
        
        return SKAction.sequence([SKAction.wait(forDuration: 0.2),
                                  rotation])
        
    }

    
    //MARK: - Attributes for swipes
    
    var cardAnimationDuration: TimeInterval {
        
        return 0.2
        
    }
    
    var cardAnimationRotation: CGFloat {
        
        return 0.2
        
    }
    
    var cardAnimationScale: CGFloat {
        
        return 1.1
        
    }
    

    //MARK: - Actions for right swipe
    
    private func animateMoveRight(_ topCard: MenuCard) -> SKAction {
        
        //TODO: GET Extrempoints of cardstack
        
        return SKAction.moveBy(x: getFactor(0.04, max: 30) + topCard.size.width,
                               y: getFactor(0.08, max: 60),
                               duration: cardAnimationDuration)
        
    }
    
    func animateRightSwipeRight(_ topCard: MenuCard) -> SKAction {
        
        let turnRight = SKAction.rotate(toAngle: -cardAnimationRotation,
                                        duration: cardAnimationDuration)
        
        let scaleRight = SKAction.scale(to: cardAnimationScale,
                                        duration: cardAnimationDuration)
        
        return SKAction.group([turnRight, scaleRight, animateMoveRight(topCard)])
        
    }
    
    func animateRightSwipeLeft(_ topCard: MenuCard) -> SKAction {
        
        let turnLeft = SKAction.rotate(toAngle: topCard.gameType.rotation,
                                       duration: cardAnimationDuration)
        
        let scaleLeft = SKAction.scale(to: 1,
                                       duration: cardAnimationDuration)
        
        return SKAction.group([turnLeft, scaleLeft, animateMoveRight(topCard).reversed()])
        
    }
    
    
    //MARK: - Actions for left swipe
    
    private func animateMoveLeft(_ downCard: MenuCard) -> SKAction {
        
        return SKAction.moveBy(x: -(getFactor(0.04, max: 30) + downCard.size.width),
                               y: getFactor(0.08, max: 60),
                               duration: cardAnimationDuration)
        
    }
    
    func animateLeftSwipeLeft(_ downCard: MenuCard) -> SKAction {
        
        let turnLeft = SKAction.rotate(toAngle: cardAnimationRotation,
                                       duration: cardAnimationDuration)
        
        let scaleLeft = SKAction.scale(to: cardAnimationScale,
                                       duration: cardAnimationDuration)
        
        return SKAction.group([turnLeft, scaleLeft, animateMoveLeft(downCard)])
        
    }
    
    func animateLeftSwipeRight(_ downCard: MenuCard) -> SKAction {
        
        let turnRight = SKAction.rotate(toAngle: downCard.gameType.rotation,
                                        duration: cardAnimationDuration)
        
        let scaleRight = SKAction.scale(to: 1,
                                        duration: cardAnimationDuration)
        
        return SKAction.group([turnRight, scaleRight, animateMoveLeft(downCard).reversed()])
        
    }

}
