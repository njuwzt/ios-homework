//
//  ViewController.swift
//  light
//
//  Created by Astinna on 2020/9/23.
//  Copyright © 2020 NJU. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var on = false
    let device=AVCaptureDevice.default(for: AVMediaType.video);
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet var background: UIView!
    
        
    
    @IBAction func light(_ sender: Any) {
        try?device?.lockForConfiguration()
        if on == false
        {
            (sender as! UIButton).setTitle("OFF",for:[])
            background.backgroundColor=UIColor.white
            device?.torchMode = .on
            on = true
        }
        else
        {
            (sender as! UIButton).setTitle("ON",for:[])
            background.backgroundColor=UIColor.black
            device?.torchMode = .off
            on = false
        }
        device?.unlockForConfiguration()
    }
}


