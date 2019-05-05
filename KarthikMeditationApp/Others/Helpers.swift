//
//  Extension.swift
//  KarthikMeditationApp
//
//  Created by Karthik K Manoj on 03/05/19.
//  Copyright © 2019 Karthik K Manoj. All rights reserved.
//
import UIKit
import Foundation

extension UIBarButtonItem {
    
    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.alpha = 0.5
        
        let menuBarItem = UIBarButtonItem(customView: button)
        
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 15).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 23).isActive = true
        
        return menuBarItem
    }
}

extension UIColor {
    
    convenience init(red : CGFloat, green: CGFloat, blue : CGFloat) {
        
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        
    }
    
}

extension UIView {
    
    func updateViewLayer() {
        
        layer.backgroundColor = UIColor.white.cgColor
        
        layer.cornerRadius = 0
        
        layer.masksToBounds = false
        
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        layer.shadowOffset = CGSize(width: 0 , height: 0)
        
        layer.shadowRadius = 2.00 // previous 1.75
        
        layer.shadowOpacity = 0.8
        
    }
    
    
    
}

struct Service {
    
    static func showAlert(on : UIViewController, title : String?, message : String?,  style : UIAlertController.Style, actions : [UIAlertAction] =  [UIAlertAction(title: "Ok", style: .default, handler: nil)]
        , completion : (() -> Void)? = nil ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for action in actions {
            
            alert.addAction(action)
        }
        
        on.present(alert, animated: true, completion: nil)
        
    }
    
}
