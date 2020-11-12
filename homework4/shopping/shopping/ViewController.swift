//
//  ViewController.swift
//  shopping
//
//  Created by Astinna on 2020/11/11.
//  Copyright © 2020 NJU. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //MASK:Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var goodsNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
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
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        //imagePickerController.sourceType = .photoLibrary
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        goodsNameLabel.text = "Default Text"
    }



}

