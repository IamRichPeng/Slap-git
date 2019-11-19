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
    
    @IBOutlet weak var winner: UITextField!
    
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var winnerlabel: UILabel!
    
    @IBOutlet weak var confirmbutton: UIButton!

    var done = true
    
    // use to check if there is username2
    var valid = false
    
    // use to send another uid except currentuser's 
     var uid2: String?
    
    @IBAction func isUnfinishedBet(_ sender: UIBarButtonItem) {
        print("isUnfinishedBet")
        done = false
        winnerlabel.isHidden = true
        winner.isHidden = true
    }
    @IBAction func isFinishedBet(_ sender: UIBarButtonItem) {
        print("isFinishedBet")
        done = true
        winnerlabel.isHidden = false
        winner.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username1.delegate = self
        username2.delegate = self
        
        incident.delegate = self
        
        winnerlabel.isHidden = false
        winner.isHidden = false
        
        setConfirmButton(enabled: false)
        
        //listener, monitor the change of textfield
        username1.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        username2.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
       winner.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    
    
    //MARK: UITextFieldDelegate
    @objc func textFieldChanged(_ textField:UITextField) {
        let user1 = username1.text
        let user2 = username2.text
     //   let winner1 = winner.text
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
        
        
        // ***********try to upload to two users(fetching uid2) ********
        //using "completion" to execute retriveUser2 func first
        
        retriveUser2 { (userid) in
           self.addtoCache()
        }
        
    }
    
    
    func retriveUser2(completion:@escaping (_ userid: String)->() ){
        
        let ref = Database.database().reference()
        ref.child("users").queryOrdered(byChild: "username").queryEqual(toValue: self.username2.text).observeSingleEvent(of: .value, with: { (snapshot) in
            
            //           print(snapshot)
            self.valid = snapshot.exists()
            print(self.valid)
            
            for snap in snapshot.children.allObjects as! [DataSnapshot]{
                //            print(snap)
                guard let dictionary = snap.value as? [String : AnyObject] else {return}
                self.uid2 = dictionary["uid"] as? String
                print(self.uid2!)
            }
            
            // call the closure function upon completion
            if self.valid{
            completion(self.uid2!)
            }
         
        // Alert!!!!! if there is no user name username2.text
            else{
                guard let nmsl  = self.username2.text  else{return}
                let alert = UIAlertController(title: "Warning", message: "There is no such a user called \" \(nmsl) \"", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                
            }
            
        }, withCancel: nil)
        
        
        // alarm for invalid winner input and username1 input
        
        if( username1.text != UserService.currentUserProfile?.username){
            let alert = UIAlertController(title: "Warning", message: "Can you type your name correctly?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        if (done == true && winner.text != username1.text && winner.text != username2.text){
            let alert = UIAlertController(title: "Warning", message: "Please enter the correct winner username ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    
    func addtoCache(){
        guard let userProfile = UserService.currentUserProfile else {return }
        
        let postCache = Database.database().reference().child("cache/\(uid2!)")
        
        let postObject = [
            
            
            "postby": [
                "currentUid" : userProfile.uid,
                "photoURL" : userProfile.photoURL.absoluteString,
                "username" : userProfile.username],
            
            "BET":[
                "username1": username1.text!,
                "username2": username2.text!,
                "incident": incident.text,
                "winner": winner.text!,
                
                "timestamp": [".sv":"timestamp"]
            ]
            
            ] as [String:Any]
        
        postCache.setValue(postObject, withCompletionBlock: { error, ref in
            if error == nil {
                self.dismiss(animated: true, completion: nil)
            }
        })
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    
    func addtoUsers(){
        
        guard let userProfile = UserService.currentUserProfile else {return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
            var postRef = Database.database().reference().child("users/\(uid)/testingpost222").childByAutoId()
            var  postRef2 = Database.database().reference().child("users/\(uid2!)/testingpost222").childByAutoId()
            
            if (done == true){
                postRef = Database.database().reference().child("users/\(uid)/testingpost").childByAutoId()
                 postRef2 = Database.database().reference().child("users/\(uid2!)/testingpost").childByAutoId()
            }
            else{
                postRef = Database.database().reference().child("users/\(uid)/testingpost222").childByAutoId()
                  postRef2 = Database.database().reference().child("users/\(uid2!)/testingpost222").childByAutoId()
            }
            
            let postObject = [
                "postby": [
                    "currentUid" : userProfile.uid,
                    "photoURL" : userProfile.photoURL.absoluteString,
                    "username" : userProfile.username],
                
                "BET":[
                    "username1": username1.text!,
                    "username2": username2.text!,
                    "incident": incident.text,
                    "winner": winner.text!,
                    
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
            
            postRef2.setValue(postObject, withCompletionBlock: { error, ref in
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
