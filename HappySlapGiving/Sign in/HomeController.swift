//
//  HomeController.swift
//  FirebaseLogin
//
//  Created by 彭睿诚 on 2019/5/31.
//  Copyright © 2019年 Ruicheng Peng. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    var user: User?
    
    var welcomeLabel: UIButton = {
        let label = UIButton.init(type: .system)
        label.tintColor = .white
        label.titleLabel?.font = UIFont.systemFont(ofSize: 28)
        label.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    @objc func buttonClicked(_ : UIButton){
        print("fuck")
        let sb = UIStoryboard(name: "MainSlap", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "homeslap") as! HomeSlapController
        self.present(vc,animated: true,completion: nil)
    }
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureView()
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Selectors
    
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func loadUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
                UserService.observeUserProfile(uid){ UserProfile in UserService.currentUserProfile = UserProfile}
        Database.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value) { (snapshot) in
            guard let username = snapshot.value as? String else { return }
            self.welcomeLabel.setTitle("Welcome, \(username)", for: .normal)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.welcomeLabel.alpha = 1
            })
        }
    }
    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginController())
                self.present(navController, animated: true, completion: nil)
            }
        } else {
            configureViewComponents()
            loadUserData()
            
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let navController = UINavigationController(rootViewController: LoginController())
            navController.navigationBar.barStyle = .black
            
            UserService.currentUserProfile = nil
            
            self.present(navController, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: ", signOutError)
        }
    }
    
    // MARK: - Helper Functions
        
    func configureViewComponents() {
        view.backgroundColor = UIColor.mainBlue()
        navigationController?.navigationBar.barTintColor = UIColor.mainBlue()
        
        navigationItem.title = "Firebase Login"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_white_24dp"), style: .plain, target: self, action: #selector(handleSignOut))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        view.addSubview(welcomeLabel)
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
