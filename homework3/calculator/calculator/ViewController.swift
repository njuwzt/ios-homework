//
//  ViewController.swift
//  calculator
//
//  Created by Astinna on 2020/10/25.
//  Copyright © 2020 NJU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var myCalculator=calculator()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var DisplayLabel: UILabel!
    
    
    @IBAction func NumberButton(_ sender: UIButton) {
        let num = sender.titleLabel?.text
        DisplayLabel.text=myCalculator.inputNum(num: num!)
    }
    
    @IBAction func CalculatorButton(_ sender: UIButton) {
        let cal = sender.titleLabel?.text
        DisplayLabel.text=myCalculator.inputCal(calcu: cal!)
    }
    
}

