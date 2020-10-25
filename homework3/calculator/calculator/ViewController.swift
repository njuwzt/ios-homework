//
//  ViewController.swift
//  calculator
//
//  Created by Astinna on 2020/10/25.
//  Copyright © 2020 NJU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var DisplayLabel: UILabel!
    
    
    @IBAction func NumberButton(_ sender: UIButton) {
        let num = sender.titleLabel?.text
        
    }
    
    @IBAction func CalculatorButton(_ sender: UIButton) {
        let cal = sender.titleLabel?.text
        
    }
    
}

