//
//  ViewController.swift
//  TinyToyTank
//
//  Created by Astinna on 2021/1/25.
//  Copyright © 2021 NJU. All rights reserved.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ArView: ARView!
    var play = false
    var tankAnchor: TinyToyTank._TinyToyTank?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
        tankAnchor = try! TinyToyTank.load_TinyToTank()
        tankAnchor!.turret?.setParent(tankAnchor!.tank, preservingWorldTransform: true)
        tankAnchor?.actions.actionComplete.onAction = {_ in
            self.play = false
        }
        // Add the box anchor to the scene
        ArView.scene.anchors.append(tankAnchor)
    }
    
    @IBAction func TurretRight(_ sender: Any) {
        if self.play{
            return
        }
        else{
            self.play = true
        }
        tankAnchor!.notifications.turretRight.post()
    }
    
    @IBAction func CannonFire(_ sender: Any) {
        if self.play{
            return
        }
        else{
            self.play = true
        }
        tankAnchor!.notifications.cannonFire.post()
    }
    
    @IBAction func TurretLeft(_ sender: Any) {
        if self.play{
            return
        }
        else{
            self.play = true
        }
        tankAnchor!.notifications.turrentLeft.post()
    }
    @IBAction func TankRight(_ sender: Any) {
        if self.play{
            return
        }
        else{
            self.play = true
        }
        tankAnchor!.notifications.tankRight.post()
    }
    
    @IBAction func TankLeft(_ sender: Any) {
        if self.play{
            return
        }
        else{
            self.play = true
        }
        tankAnchor!.notifications.tankLeft.post()
    }
    
    @IBAction func TankForward(_ sender: Any) {
        if self.play{
            return
        }
        else{
            self.play = true
        }
        tankAnchor!.notifications.tankForward.post()
    }
}
