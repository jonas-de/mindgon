//
//  Enumerations.swift
//  mindgon
//
//  Created by Jonas Andersson on 30.03.18.
//  Copyright © 2018 bambuzleapps. All rights reserved.
//

import SpriteKit


//MARK: - States

/**
 Represents the state of the current game
 - ## cases:
    - running
    - revive
    - end
 */
enum GameState {
    
    case running, preparerevive, revive
    
}

/**
 Represents the status of highlighting nodes after revive
 - ## cases
    - running
    - shouldStop
    - stop
 */
enum HighlightingState {
    
    case running, shouldStop, stop
    
}

/**
 Represents the state of the `firstNode`
 - ## cases
    - untouched(touch: UITouch)
    - touched(touch: UITouch)
 - holds the touch of the node
*/
enum NodeState{
    
    case untouched, touched
    
}

/**
 Represents the state of the `timeLabel` in `TimeScene`
    - ## cases
        - no
        - increase
        - decrease
        - decrease
*/
enum ChangingTimeState {
    
    case no, increase, decrease, reset, waitForDecrease, waitForIncrease
    
}


//MARK: - Other

/**
 Represents the type of haptical feedback that should be occur
 - ## cases
    - impact
    - wrong
*/
enum FeedbackType {

    case impact, wrong

}

/**
 represents the direction in wich the cardstack should swipe or indicates that no swipe should happen
 - ## cases
 - right
 - left
 - noSwipe
 */
enum SwipeDirection {
    
    case right, left, noSwipe
    
}



