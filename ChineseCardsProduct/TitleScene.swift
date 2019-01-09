//
//  TitleScene.swift
//  ChineseCardsProduct
//
//  Created by Kevin Zhou on 8/16/17.
//  Copyright © 2017 Kevin Zhou. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class TitleScene:SKScene{
    var titleLabel:SKLabelNode!
    var playLabel:SKLabelNode!
    var helpNode:SKNode!
    var tutorialPage:SKNode!
    var inTutorial:Bool!
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(size:CGSize){
        super.init(size:size)

        backgroundColor = SKColor(red: 21/255, green: 27/255, blue: 31/255, alpha: 1.0)
        
        helpNode = SKNode()
        
        titleLabel = SKLabelNode(text: "华语闪卡")
//        titleLabel.fontName = "TimeBurner"
        titleLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/4*3)
        titleLabel.fontColor = SKColor(red: 176/255, green: 196/255, blue: 222/255, alpha: 1.0)
        titleLabel.fontSize = 40
        addChild(titleLabel)
        
        playLabel = SKLabelNode(text: "Swipe Right to Play")
//        playLabel.fontName = "TimeBurner"
        playLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/4)
        playLabel.fontColor = SKColor(red: 176/255, green: 196/255, blue: 222/255, alpha: 1.0)
        playLabel.fontSize = 40
        addChild(playLabel)
        
        addChild(helpNode)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first?.location(in: self)
        let node = self.atPoint(touch!)
        if node.children.count == 0{
            if node == helpNode.children[0] || node == helpNode.children[1] || node == helpNode{
                if tutorialPage.position.y != 0{
                    tutorialPage.run(SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.25))
                    inTutorial = true
                }else{
                    tutorialPage.run(SKAction.move(to: CGPoint(x: 0, y: -self.frame.size.height-10), duration: 0.25))
                    inTutorial = false
                }
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        let previousLocation = touch?.previousLocation(in: self)
        
        if ((location?.x)! > (previousLocation?.x)!){
            let transition = SKTransition.flipVertical(withDuration: 0.5)
            let gameScene = GradeScene(size: self.size)
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
    
    
}
