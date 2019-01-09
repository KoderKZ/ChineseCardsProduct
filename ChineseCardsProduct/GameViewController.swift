//
//  GameViewController.swift
//  ChineseCardsProduct
//
//  Created by Kevin Zhou on 8/16/17.
//  Copyright © 2017 Kevin Zhou. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        
        let scene = TitleScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFit
        
        skView.presentScene(scene)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
