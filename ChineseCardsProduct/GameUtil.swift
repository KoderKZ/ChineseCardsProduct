//
//  GameUtil.swift
//  ChineseCardsProduct
//
//  Created by Kevin Zhou on 8/19/17.
//  Copyright © 2017 Kevin Zhou. All rights reserved.
//

import Foundation
import SpriteKit

class GameUtil{
    static func checkIfNodeInTouch(node: SKNode, touch: CGPoint, multiplier: CGFloat) -> Bool {
        if touch.x < node.position.x+node.frame.size.width*multiplier &&
            touch.x > node.position.x-node.frame.size.width*multiplier &&
            touch.y < node.position.y+node.frame.size.height*multiplier &&
            touch.y > node.position.y-node.frame.size.height*multiplier {
            
            return true
        }else{
            return false
        }
    }
}
