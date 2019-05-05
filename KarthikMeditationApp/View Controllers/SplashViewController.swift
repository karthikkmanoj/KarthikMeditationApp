//
//  SplashViewController.swift
//  KarthikMeditationApp
//
//  Created by Karthik K Manoj on 04/05/19.
//  Copyright © 2019 Karthik K Manoj. All rights reserved.
//

import UIKit
import Lottie
import Firebase

class SplashViewController: UIViewController {
    
    let lottieView : AnimationView = {
       
        let view = AnimationView(name: "data")
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.animationSpeed = 1.0
        
        view.contentMode = .scaleAspectFill
        
        return view
        
    }()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupLottieView()
        
    }
    

}

extension SplashViewController {
    
    
    func setupLottieView() {
        
        view.backgroundColor = .white
        
        view.addSubview(lottieView)
        
        lottieView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        lottieView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        lottieView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        lottieView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        lottieView.play { (finish) in
            
            if finish {
                
                self.checkIfUserIsLoggedIn()
                
                
            }
        }
    }
    
    func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser?.uid == nil {
            
            self.perform(#selector(SplashViewController.handleLogOut))
            
        } else {
            
            let mainViewController = MainViewController()
            
            let navigationController = UINavigationController(rootViewController: mainViewController)
            
            self.present(navigationController, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func handleLogOut() {
        
        do {
            
            try Auth.auth().signOut()
            
        } catch let logoutError {
            
            print(logoutError)
            
        }
        
        let loginViewController = LoginViewController()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = loginViewController
        
        appDelegate.window?.makeKeyAndVisible()
        
        present(loginViewController, animated: true, completion: nil)
        
        
    }
    
    
}
