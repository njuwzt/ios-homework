//
//  StartScene.swift
//  FinalProject
//
//  Created by Astinna on 2020/12/20.
//  Copyright © 2020 NJU. All rights reserved.
//

import Foundation
import SpriteKit

class StartScene: SKScene{
    var StartLogo: SKSpriteNode!
    var playText: SKLabelNode!
    
    // Present start scene
    override func sceneDidLoad() {
        //Set value for paddle
        SetPaddleValues(frame)
        
        //Set background color
        backgroundColor = UIColor(red: 24/255, green: 20/255, blue: 37/255, alpha: 1)
        
        //Init start logo
        StartLogo = SKSpriteNode(texture: SKTexture(imageNamed: "Logo"), size: CGSize(width: frame.size.width, height: frame.size.width / 2))
        StartLogo.position.y = frame.size.height / 4
        addChild(StartLogo)
        
        //Present start logo
        playText = SKLabelNode(fontNamed: "Montserrat-Black")
        playText.text = "TOUCH ANYWHERE TO PLAY"
        playText.fontColor = UIColor(red: 90/255, green: 105/255, blue: 136/255, alpha: 1)
        playText.fontSize = PADDLE_HEIGHT * 1
        playText.position.y = -(frame.size.height / 4)
        addChild(playText!)
        // Debug
        //print("how1")
    }
    
    // Touch to start game
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let FadeTransition = SKTransition.fade(withDuration: 1)
        let gameScene = GameScene(size: frame.size)
        gameScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameScene.scaleMode = .aspectFill
        self.view?.presentScene(gameScene, transition: FadeTransition)
    }
}
