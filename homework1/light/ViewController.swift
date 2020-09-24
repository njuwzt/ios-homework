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

    var i=0
    let device=AVCaptureDevice.default(for: AVMediaType.video);
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet var background: UIView!
    
        
    
    @IBAction func light(_ sender: Any) {
        try?device?.lockForConfiguration()
        if i%2==0
        {
            (sender as! UIButton).setTitle("OFF",for:[])
            background.backgroundColor=UIColor.white
            device?.torchMode = .on
            i=i+1;
        }
        else
        {
            (sender as! UIButton).setTitle("ON",for:[])
            background.backgroundColor=UIColor.black
            device?.torchMode = .off
            i=i+1;
        }
        device?.unlockForConfiguration()
    }
}


