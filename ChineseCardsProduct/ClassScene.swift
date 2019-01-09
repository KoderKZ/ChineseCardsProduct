//
//  ClassScene.swift
//  ChineseCardsProduct
//
//  Created by Kevin Zhou on 8/16/17.
//  Copyright © 2017 Kevin Zhou. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit
class ClassScene:SKScene{
    var backButton:SKSpriteNode!
    var gradeName:String!
    var classNames:NSMutableArray!
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(size:CGSize){
        super.init(size:size)

        
        backgroundColor = SKColor(red: 21/255, green: 27/255, blue: 31/255, alpha: 1.0)
        
        classNames = NSMutableArray()
        
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
    }
    
    func setGradeName(name:String) {
        gradeName = name
        let grade = JSONFileUtil.readGradeFromFile(gradeName: gradeName)
        for var i in 0..<grade.classes.count{
            classNames.add(grade.classes.object(at: i))
        }
        createLabels()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch = touches.first?.location(in: self)
        let node = self.atPoint(touch!)
        if self.children.contains(node) && node != backButton{
            let label = node as! SKLabelNode
            let transition = SKTransition.flipVertical(withDuration: 0.5)
            let gameScene = CardScene(size: self.frame.size)
            gameScene.setCourseAndGradeNames(course: label.text!, grade: gradeName)
            self.view?.presentScene(gameScene, transition: transition)
        }else if GameUtil.checkIfNodeInTouch(node: backButton, touch: touch!, multiplier: 1.5){
            let transition = SKTransition.flipVertical(withDuration: 0.5)
            let gameScene = GradeScene(size: self.frame.size)
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
    
    func getView() -> SKView {
        return self.view!
    }
    
    func createLabels() {
        var counter = 0
        let heightDivider = Int(classNames.count/4)+2
        var vertCounter = 1

        for var i in 0..<classNames.count{
            counter += 1
            let label = SKLabelNode(text: classNames.object(at: i) as? String)
            label.position = CGPoint(x: self.size.width/CGFloat(4)*CGFloat(counter), y: self.size.height/CGFloat(heightDivider)*CGFloat(heightDivider-vertCounter))
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .center
            label.fontColor = SKColor(red: 176/255, green: 196/255, blue: 222/255, alpha: 1.0)
            label.fontSize = 20
            addChild(label)
            if counter == 3{
                vertCounter += 1
                counter = 0
            }
        }
    }
    
    
}
