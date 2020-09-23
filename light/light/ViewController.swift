//
//  ViewController.swift
//  light
//
//  Created by Astinna on 2020/9/23.
//  Copyright © 2020 NJU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var i=0
    
     override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet var background: UIView!
    
        
    
    @IBAction func light(_ sender: Any) {
        
        if i%2==0
        {
            (sender as! UIButton).setTitle("OFF",for:[])
            background.backgroundColor=UIColor.white
            i=i+1;
        }
        else
        {
            (sender as! UIButton).setTitle("ON",for:[])
            background.backgroundColor=UIColor.black
            i=i+1;
        }
    }
}


