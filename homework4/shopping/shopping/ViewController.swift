//
//  ViewController.swift
//  shopping
//
//  Created by Astinna on 2020/11/11.
//  Copyright © 2020 NJU. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    //MASK:Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var goodsNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        nameTextField.delegate = self
    }
    //MASK:UITextFieldDelegate
    func textFieldShouldReturn(_ textField:UITextField)->Bool{
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField){
        goodsNameLabel.text=textField.text
    }
    //MASK:Action
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        goodsNameLabel.text = "Default Text"
    }



}

