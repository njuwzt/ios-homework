//
//  ViewController.swift
//  shopping
//
//  Created by Astinna on 2020/11/11.
//  Copyright © 2020 NJU. All rights reserved.
//

import UIKit
import os.log
class ViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var good: Good?
    //MASK:Properties
    let defaultReason="REASON"
    let defaultName="GOODS NAME"
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var goodsNameLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateSaveButtonState()
        nameTextField.delegate = self
        reasonTextField.delegate = self
        
        if let good = good {
            navigationItem.title = good.name
            nameTextField.text = good.name
            photoImageView.image = good.photo
            reasonTextField.text = good.reason
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    //MASK:UITextFieldDelegate
    func textFieldShouldReturn(_ textField:UITextField)->Bool{
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField){
        updateSaveButtonState()
        
        if !nameTextField.text!.isEmpty{
            goodsNameLabel.text=nameTextField.text
            navigationItem.title = nameTextField.text
        }
        else{
            goodsNameLabel.text=defaultName
            navigationItem.title = defaultName
        }
        if !reasonTextField.text!.isEmpty{
            reasonLabel.text=reasonTextField.text
        }
        else{
            reasonLabel.text=defaultReason
        }
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField){
        saveButton.isEnabled=false
    }
    
    //MASK:UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }*/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the edit.
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MASK:Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button == saveButton else{
            os_log("The save button was not pressed, canceling",log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let reason = reasonTextField.text ?? ""
        
        good = Good(name: name, photo: photo, reason: reason)
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddGoodMode = presentingViewController is UINavigationController
        
        if isPresentingInAddGoodMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    //MASK:Action


    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
         
            nameTextField.resignFirstResponder()
            let imagePickerController = UIImagePickerController()
            //imagePickerController.sourceType = .photoLibrary
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
                goodsNameLabel.text = "Default Text"
    }
    
    //MASK: Private Methods
    private func updateSaveButtonState(){
        let text=nameTextField.text!+reasonTextField.text!
        saveButton.isEnabled = !text.isEmpty
    }
    
    
}

