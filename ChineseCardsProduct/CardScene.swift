//
//  CardScene.swift
//  ChineseCardsProduct
//
//  Created by Kevin Zhou on 8/19/17.
//  Copyright © 2017 Kevin Zhou. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit
class CardScene:SKScene{
    var backButton:SKSpriteNode!
    var card:CardNode!
    var courseName:String!
    var movedAmount:CGFloat!
    var cardArray:NSMutableArray!
    var cardNumber:Int!
    var gradeName:String!
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(size:CGSize){
        super.init(size:size)
        
        movedAmount = 0
        cardNumber = 0
        
        cardArray = NSMutableArray()
        
        backgroundColor = SKColor(red: 21/255, green: 27/255, blue: 31/255, alpha: 1.0)
        card = CardNode()
        addChild(card)
        card.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        
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
    
    func setCourseAndGradeNames(course:String,grade:String) {
        courseName = course
        gradeName = grade
        let course = JSONFileUtil.readCourseFromFile(courseName: courseName)
        courseName = course.courseName
        for var i in 0..<course.cards.count{
            let dict = JSONFileUtil.convertToDictionary(text: course.cards[i] as! String)
            let card = FlashCard(chinese: dict?["chinese"] as! String, english: dict?["english"] as! String, pinyin: dict?["pinyin"] as! String, imageFileName: dict?["imageFileName"] as! String, audioStartTime: dict?["audioStartTime"] as! Double, audioDuration: dict?["audioDuration"] as! Double)
            cardArray.add(card)
        }
        
        card.setCardToNode(card: cardArray.object(at: 0) as! FlashCard, courseName: courseName)
        card.setupNodes()
        cardNumber! += 1
        

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        let previousLocation = touch?.previousLocation(in: self)
        var up:Bool = false
        if ((location?.y)! > (previousLocation?.y)!){
            up = true
        }else if ((location?.y)! < (previousLocation?.y)!){
            up = false
        }
        movedAmount = movedAmount+(location?.x)!-(previousLocation?.x)!
        if !card.inFlip && !card.rotating{
            if movedAmount > size.width/6{
                card.moveCardOut(left: false, up: up)
                card.rotateCard(up: up, left: false)
                if cardNumber == cardArray.count{
                    cardNumber = 0
                }
                card.setCardToNode(card: cardArray.object(at: cardNumber) as! FlashCard, courseName: courseName)
                delay(2){
                    self.card.resetCard()
                    self.movedAmount = 0
                    self.cardNumber! += 1
                }
            }else if -size.width/6 > movedAmount{
                card.moveCardOut(left: true, up: up)
                card.rotateCard(up: up, left: true)
                if cardNumber == cardArray.count{
                    cardNumber = 0
                }
                card.setCardToNode(card: cardArray.object(at: cardNumber) as! FlashCard, courseName: courseName)
                delay(2){
                    self.card.resetCard()
                    self.movedAmount = 0
                    self.cardNumber! += 1
                }
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movedAmount = 0
        var touch = touches.first?.location(in: self)
        let node = self.atPoint(touch!)
        if node == card.speakerSprite{
            card.playAudio()
        }else if node == card || card.children.contains(node) || node == card.imageSprite{
            card.flipCard()
        }else if GameUtil.checkIfNodeInTouch(node: backButton, touch: touch!, multiplier: 1.5){
            let transition = SKTransition.flipVertical(withDuration: 0.5)
            let gameScene = ClassScene(size: self.frame.size)
            gameScene.setGradeName(name: gradeName)
//            let view = gameScene.getView()
//            SKView.transition(from: self.view!, to: self.view!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
            delay(0.5){
                self.view?.presentScene(gameScene)
            }
        }
    }
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
