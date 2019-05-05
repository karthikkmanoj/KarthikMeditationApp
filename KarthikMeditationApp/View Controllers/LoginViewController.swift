//
//  ViewController.swift
//  KarthikMeditationApp
//
//  Created by Karthik K Manoj on 02/05/19.
//  Copyright © 2019 Karthik K Manoj. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD

class LoginViewController: UIViewController {

    let imageView : UIImageView = {
       
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "logo")
        
        imageView.contentMode = .scaleAspectFill
        
        return imageView
        
    }()
    let buttonContainerView : UIView = {
       
        let view = UIView()
        
        view.backgroundColor = .white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let googleLoginButton : UIButton = {
        
        let button = UIButton()
        
        button.layer.cornerRadius = 5
        
        button.layer.masksToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Log In With Google", for: .normal)
    
        button.setImage(UIImage(named: "googleIcon"), for: .normal)
        
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: -20, bottom: 10, right: 10)
        
        button.setTitleColor(UIColor(red: 105, green: 105, blue: 105), for: .normal)
        
        button.layer.borderColor = UIColor(red: 169, green: 169, blue: 169).cgColor
        
        button.layer.borderWidth = 0.5
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.backgroundColor = UIColor.white
        
        button.addTarget(self, action: #selector(LoginViewController.handleGoogleLogin), for: .touchUpInside)
    
        return button
        
    }()
    
    let anonymousLoginButton : UIButton = {
        
        let button = UIButton()
        
        button.layer.cornerRadius = 5
        
        button.layer.masksToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Log in Anonymously", for: .normal)
    
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.backgroundColor = UIColor.darkGray
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(LoginViewController.handleAnonymousLogin), for: .touchUpInside)
        
        return button
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupViews()
        
        setupFirebase()
        
    }


}

extension LoginViewController {
   
    @objc func handleAnonymousLogin() {
        
        SVProgressHUD.show()
        
        Auth.auth().signInAnonymously { (authResult, error) in
            
            if let error = error {
                
                print("Failed to log in", error)
                
                SVProgressHUD.dismiss()
                
                Service.showAlert(on: self, title: "Log in Error", message: error.localizedDescription, style: .alert)
                
                return
                
            } else {
                
                guard let user = authResult?.user else { return }
                
                print("LOGGED IN", user.uid, user.isAnonymous)
                
                SVProgressHUD.dismiss()
                
                let mainViewController = MainViewController()
                
                let navigationController = UINavigationController(rootViewController: mainViewController)
                
                self.present(navigationController, animated: true, completion: nil)
                
            }
            
        }
    }
    
    @objc func handleGoogleLogin() {
        
        SVProgressHUD.show()
        
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func setupFirebase() {
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    func setupViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(buttonContainerView)
        
        view.addSubview(imageView)
        
        buttonContainerView.addSubview(googleLoginButton)
        
        buttonContainerView.addSubview(anonymousLoginButton)
        
        buttonContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        buttonContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        buttonContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        buttonContainerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        anonymousLoginButton.topAnchor.constraint(equalTo: buttonContainerView.topAnchor).isActive = true
        
        anonymousLoginButton.leftAnchor.constraint(equalTo: buttonContainerView.leftAnchor).isActive = true
        
        anonymousLoginButton.widthAnchor.constraint(equalTo: buttonContainerView.widthAnchor).isActive = true
        
        anonymousLoginButton.heightAnchor.constraint(equalTo: buttonContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        googleLoginButton.topAnchor.constraint(equalTo: anonymousLoginButton.bottomAnchor, constant : 15).isActive = true
        
        googleLoginButton.leftAnchor.constraint(equalTo: buttonContainerView.leftAnchor).isActive = true
        
        googleLoginButton.widthAnchor.constraint(equalTo: buttonContainerView.widthAnchor).isActive = true
        
        googleLoginButton.heightAnchor.constraint(equalTo: buttonContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        imageView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        
        imageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
   
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true

    }
    
}

extension LoginViewController : GIDSignInUIDelegate {
  
  
}
