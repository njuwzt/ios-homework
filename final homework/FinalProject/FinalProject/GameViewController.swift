//
//  ViewController.swift
//  FinalProject
//
//  Created by Astinna on 2020/12/16.
//  Copyright © 2020 NJU. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    // Init scene
    var scene: StartScene!
    
    // Start game
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Create the view
        let spriteKitView = view as? SKView
        // Configure the view
        spriteKitView?.isMultipleTouchEnabled = false
        // Create the scene
        // Debug
        //print("why")
        scene = StartScene(size: spriteKitView!.bounds.size)
        // Configure the scene
        // Debug
        //print("how")
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .aspectFill
        
        // Present scene to the view
        spriteKitView?.presentScene(scene)
    }
    
    // Disable auto rotation
    override var shouldAutorotate: Bool {
        return false
    }
    
    // Only support portrait mode
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // Hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


