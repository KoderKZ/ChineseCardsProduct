//
//  CardNode.swift
//  ChineseCardsProduct
//
//  Created by Kevin Zhou on 8/17/17.
//  Copyright © 2017 Kevin Zhou. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation
import UIKit
class CardNode: SKNode {
    var imageFileName:String!
    var audioDuration:Double!
    var audioStartTime:Double!
    var audioFileName:String!
    var english:String!
    var pinYin:String!
    var chinese:String!
    
    var cardShape:SKShapeNode!
    var englishLabel:SKLabelNode!
    var chineseLabel:SKLabelNode!
    var pinYinLabel:SKLabelNode!
    var imageSprite:SKSpriteNode!
    var speakerSprite:SKSpriteNode!
    
    var englishSide:Bool!
    var size:CGSize!
    
    var audioPlayer: AVAudioPlayer?
    var timer:Timer!
    
    var inFlip:Bool!
    
    var rotating:Bool!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
    }
    
    func setupNodes(){
        inFlip = false
        rotating = false
        englishSide = false
        
        cardShape = SKShapeNode(rect: CGRect(x: -size.width/2, y: -size.height/2, width: size.width, height: size.height))
        cardShape.fillColor = .white
        addChild(cardShape)
        
        englishLabel = SKLabelNode(text: english)
        englishLabel.fontSize = 30
        englishLabel.fontColor = .black
        englishLabel.horizontalAlignmentMode = .center
        englishLabel.verticalAlignmentMode = .center
        englishLabel.position = CGPoint(x: 0, y: size.height/5)
        englishLabel.alpha = 0
        cardShape.addChild(englishLabel)
        
        pinYinLabel = SKLabelNode(text: pinYin)
        pinYinLabel.fontSize = 30
        pinYinLabel.fontColor = .black
        pinYinLabel.horizontalAlignmentMode = .center
        pinYinLabel.verticalAlignmentMode = .center
        pinYinLabel.position = CGPoint(x: 0, y: -size.height/5)
        pinYinLabel.alpha = 0
        cardShape.addChild(pinYinLabel)
        
        chineseLabel = SKLabelNode(text: chinese)
        chineseLabel.fontSize = 30
        chineseLabel.fontColor = .black
        chineseLabel.horizontalAlignmentMode = .center
        chineseLabel.verticalAlignmentMode = .center
        chineseLabel.position = CGPoint(x: 0, y: -size.height/5)
        cardShape.addChild(chineseLabel)
        
        imageSprite = SKSpriteNode(imageNamed: "\(imageFileName!).png")
        imageSprite.position = CGPoint(x: 0, y: size.height/5)
        
        var scale:CGFloat = 0
        if imageSprite.size.height > imageSprite.size.width{
            scale = size.height/2/imageSprite.frame.size.height
        }else{
            scale = size.width/5*4/imageSprite.frame.size.width
        }
        imageSprite.size = CGSize(width: imageSprite.frame.size.width*scale, height: imageSprite.frame.size.height*scale)
        cardShape.addChild(imageSprite)
        
        speakerSprite = SKSpriteNode(imageNamed: "speaker.png")
        if size.height > size.width{
            speakerSprite.size = CGSize(width: size.width/7, height: size.width/7)
        }else{
            speakerSprite.size = CGSize(width: size.height/7, height: size.height/7)
        }
        speakerSprite.position = CGPoint(x: size.width/2-(speakerSprite.size.width/3*2), y: size.height/2-(speakerSprite.size.height/3*2))
        cardShape.addChild(speakerSprite)
    }
    
    func playAudio() {
        let pathString = Bundle.main.path(forResource: audioFileName!, ofType: "wav")
        let path = URL(fileURLWithPath: pathString!)
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: path)
            audioPlayer?.currentTime = audioStartTime
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(checkSeconds), userInfo: nil, repeats: true)
        }catch{}
    }
    
    @objc func checkSeconds() {
        if (audioPlayer?.currentTime)! >= audioStartTime+audioDuration{
            audioPlayer?.stop()
            timer.invalidate()
        }
    }
    
    func setCardToNode(card:FlashCard,courseName:String){
        imageFileName = card.imageFileName
        audioDuration = card.audioDuration
        audioStartTime = card.audioStartTime
        english = card.english
        pinYin = card.pinyin
        chinese = card.chinese
        audioFileName = "\(courseName)"
        size = CGSize(width: (self.parent?.frame.size.width)!/3*2, height: (self.parent?.frame.size.height)!/3*2)
    }
    
    func rotateCard(up:Bool,left:Bool){
        if !rotating && !inFlip{
            rotating = true
            var degrees:Double
            if up{
                degrees = Double.pi/4
            }else{
                degrees = -Double.pi/4
            }
            if left{
                degrees -= degrees*2
            }
            cardShape.run(SKAction.rotate(toAngle: CGFloat(degrees), duration: 0.3))
            delay(0.3){
                self.rotating = false
            }
        }
    }
    
    func resetCard(){
        setupNodes()
        cardShape.zRotation = 0
        cardShape.position = CGPoint(x: 0, y: 0)
    }
    
    func moveCardOut(left:Bool,up:Bool) {
        let leftMult = left ? -1:1
        let upMult = up ? 1:-1
        let x = CGFloat(leftMult)*(size.width*2)
        let y = CGFloat(upMult)*(size.height/2)
        cardShape.run(SKAction.move(to: CGPoint(x: x, y: y), duration: 0.3))
        
        delay(0.4){
            
        }
    }
    
    func flipCard(){
        if !inFlip && !rotating{
            inFlip = true
            let action0 = SKAction.scaleX(to: 1.0, duration: 0.25)
            let action1 = SKAction.scaleX(to: 0.0, duration: 0.25)
            
            var node1:SKNode!
            var node2:SKNode!
            var node3:SKNode!
            var node4:SKNode!
            if !englishSide{
                node1 = chineseLabel
                node2 = imageSprite
                node3 = englishLabel
                node4 = pinYinLabel
            }else{
                node1 = englishLabel
                node2 = pinYinLabel
                node3 = chineseLabel
                node4 = imageSprite
            }
            let cardAction = SKAction.sequence([action1, action0])
            cardShape.run(cardAction)
            
            node1.run(SKAction.sequence([action1]))
            node2.run(SKAction.sequence([action1]))
            

            node3.run(SKAction.sequence([action1,action0]))
            node4.run(SKAction.sequence([action1,action0]))
            
            speakerSprite.run(SKAction.sequence([action1,action0]))
            
            let originalXPos = speakerSprite.position.x
            speakerSprite.run(SKAction.moveTo(x: 0, duration: 0.25))
            delay(0.25){
                self.speakerSprite.run(SKAction.moveTo(x: originalXPos, duration: 0.25))
            }
            
            delay(0.25){
                node1.alpha = 0
                node2.alpha = 0
                
    //            node3.xScale = 0
    //            node4.xScale = 0
                node3.alpha = 1
                node4.alpha = 1
            }

            englishSide = !englishSide
            delay(0.5){
                self.inFlip = false
            }
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
}
