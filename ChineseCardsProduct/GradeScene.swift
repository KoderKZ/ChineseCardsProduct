//
//  GradeScene.swift
//  ChineseCardsProduct
//
//  Created by Kevin Zhou on 8/16/17.
//  Copyright © 2017 Kevin Zhou. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

class GradeScene:SKScene{
    var backButton:SKSpriteNode!
    var gradeLabel:SKLabelNode!
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(size:CGSize){
        super.init(size:size)
        
        backgroundColor = SKColor(red: 21/255, green: 27/255, blue: 31/255, alpha: 1.0)
        
        backButton = SKSpriteNode(imageNamed: "backButton.png")
        var size:CGFloat
        if self.size.width > self.size.height{
            size = self.size.height/30
        }else{
            size = self.size.width/30
        }
        backButton.size = CGSize(width: size, height: size*2)
        backButton.position = CGPoint(x: backButton.size.height*1.5, y: self.frame.size.height-backButton.size.height*1.5)
        addChild(backButton)
        
        gradeLabel = SKLabelNode(text: "Fourth Grade")
        gradeLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        gradeLabel.horizontalAlignmentMode = .center
        gradeLabel.verticalAlignmentMode = .center
        gradeLabel.fontColor = SKColor(red: 176/255, green: 196/255, blue: 222/255, alpha: 1.0)
        gradeLabel.fontSize = 40
        
        let background = SKSpriteNode(color: .darkGray, size: CGSize(width: gradeLabel.frame.size.width+20, height: gradeLabel.frame.size.height+20))
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        gradeLabel.addChild(background)
        
        addChild(gradeLabel)
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch = touches.first?.location(in: self)
        let node = self.atPoint(touch!)
        if node == gradeLabel{
            let transition = SKTransition.flipVertical(withDuration: 0.5)
            let gameScene = ClassScene(size: self.size)
            gameScene.setGradeName(name: gradeLabel.text!)
            self.view?.presentScene(gameScene, transition: transition)
        }else if GameUtil.checkIfNodeInTouch(node: backButton, touch: touch!, multiplier: 1.5){
            let transition = SKTransition.flipVertical(withDuration: 0.5)
            let gameScene = TitleScene(size: self.frame.size)
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
}
