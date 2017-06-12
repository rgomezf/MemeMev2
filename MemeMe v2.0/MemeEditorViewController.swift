//
//  MemeEditorViewController.swift
//  MemeMe v2.0
//
//  Created by Ramon Gomez on 4/21/17.
//  Copyright © 2017 Ramon's. All rights reserved.
//

import Foundation
import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var socialToolbar: UIToolbar!
    @IBOutlet weak var imageToolbar: UIToolbar!
    @IBOutlet weak var shareTool: UIBarButtonItem!
    
    //MARK: Properties
    
    let memeTextAttributes: [String : Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName: -3.6
    ]
    
    var memedImage: UIImage?
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        setTextAttributes(topTextField)
        setTextAttributes(bottomTextField)
        shareTool.isEnabled = false
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Disabling camera button when camera is not present
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Methods
    
    func setTextAttributes (_ textField: UITextField) {
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if bottomTextField.isFirstResponder {
            
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
        if imagePickerView.image == nil {
            shareTool.isEnabled = false
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Selecting the original image from the Dictionary
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = selectedImage
            shareTool.isEnabled = true
        }
        // Dismissing the picker
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: self.memedImage!)
        
        // Add it to the memes array on the Application Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
        // Dismiss the Meme Editor VC
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        hideShowToolbar(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show the toolbar and navbar
        hideShowToolbar(false)
        
        return memedImage
    }
    
    func hideShowToolbar(_ state: Bool) {
        
        imageToolbar.isHidden = state
        socialToolbar.isHidden = state
    }
    
    func startOver() {
        
        imagePickerView.image = nil
        shareTool.isEnabled = false
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    //MARK: Actions
    
    @IBAction func pickAnImageFrom(_ sender: UIBarButtonItem ) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = (sender.tag == 1) ? .camera : .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMemedImage(_ sender: UIBarButtonItem) {
        
        let memeGenerated = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memeGenerated], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {
            (activityType, completed, returnedItems, error) in
            if completed {
                self.memedImage = memeGenerated
                self.save()
                self.startOver()
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.startOver()
    }
}
