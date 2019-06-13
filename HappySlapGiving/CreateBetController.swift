//
//  CreateBetController.swift
//  tableview
//
//  Created by 彭睿诚 on 2019/6/3.
//  Copyright © 2019年 Ruicheng Peng. All rights reserved.
//

import UIKit
import Firebase


class CreateBetController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var username1: UITextField!
    @IBOutlet weak var username2: UITextField!
    @IBOutlet weak var incident: UITextView!
    
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    @IBOutlet weak var confirmbutton: UIButton!

    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username1.delegate = self
        username2.delegate = self
        
        incident.delegate = self
        
        setConfirmButton(enabled: false)
        
        //listener, monitor the change of textfield
        username1.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        username2.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
    }
    
    
    
    //MARK: UITextFieldDelegate
    @objc func textFieldChanged(_ textField:UITextField) {
        let user1 = username1.text
        let user2 = username2.text
        let formFilled = user1 != nil && user1 != "" && user2 != nil && user2 != ""
        setConfirmButton(enabled: formFilled)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
    
    //enable the "Confirm" button
    func setConfirmButton(enabled: Bool){
        if enabled {
            confirmbutton.alpha = 1.0
            confirmbutton.isEnabled = true
        } else {
            confirmbutton.alpha = 0.5
            confirmbutton.isEnabled = false
        }
    }
    
    
    
    @IBAction func confirm(_ sender: Any) {
        
        guard let userProfile = UserService.currentUserProfile else {return }
        
        let postRef = Database.database().reference().child("users/testingpost").childByAutoId()
        
        let postObject = [
            "postby": [
            "currentUid" : userProfile.uid,
            "photoURL" : userProfile.photoURL.absoluteString,
            "username" : userProfile.username],
            
            "BET":[
            "username1": username1.text!,
            "username2": username2.text!,
            "incident": incident.text,
            "timestamp": [".sv":"timestamp"]
    ]
            
        ] as [String:Any]
        
        
        postRef.setValue(postObject, withCompletionBlock: { error, ref in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Handle the error
            }
        })
        
navigationController?.popToRootViewController(animated: true)

    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        incident.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            super.dismiss(animated: flag, completion: completion)
        })
    }
    
    
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    
}
