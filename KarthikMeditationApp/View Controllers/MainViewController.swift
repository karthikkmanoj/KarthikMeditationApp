//
//  MainViewController.swift
//  KarthikMeditationApp
//
//  Created by Karthik K Manoj on 03/05/19.
//  Copyright © 2019 Karthik K Manoj. All rights reserved.
//

import FirebaseFirestore
import Firebase
import UIKit
import SVProgressHUD
import Kingfisher

class MainViewController: UIViewController {

    let cellID = "cellID"

    var meditation = [Meditation]() {
        
        didSet {
            
            DispatchQueue.main.async {
             
                self.collectionView.reloadData()
                
            }
           
        }
        
    }
    
    lazy var collectionView : UICollectionView = {
    
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.dataSource = self
        
        collectionView.delegate = self
        
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    
        layout.itemSize = CGSize(width: (self.view.bounds.width - 26), height: 150)
        
        collectionView.backgroundColor = UIColor(red: 245, green: 245, blue: 245)
        
        return collectionView
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNavigationBar()
        
        setupCollectionView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        checkIfUserIsLoggedIn()

    }
    

}

extension MainViewController {
    
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
    
    fileprivate func readFromFireBase() {
        
        meditation = []
        
        SVProgressHUD.show()
        
        let database = Firestore.firestore()
        
        database.collection("meditation").getDocuments { (docsnapShot, error) in
            
            if let error = error {
                
                print("No Meditation Documents", error.localizedDescription)
                
                return
                
            }
            
            for document in docsnapShot!.documents {
                
                self.getSession(document: document, completion: { (dictionary) in
                    
                    print(Thread.isMainThread)
                    
                    let session = Session(imageLink: dictionary["imageLink"] as? String ?? "", link: dictionary["link"] as? String ?? "")
                    
                    let meditation = Meditation(noOfCurrentUser: dictionary["doing_right_now"] as? String ?? "", name: dictionary["name"] as? String ?? "", session: session, image : dictionary["image"] as? String ?? "")
                    
                    self.meditation.append(meditation)
            
                    print(self.meditation)
                    
                    SVProgressHUD.dismiss()
                    
                })
                
            }
            
        }
    }
    
    func getSession(document : DocumentSnapshot, completion : @escaping ([String : Any]) -> Void) {
        
        document.reference.collection("session").getDocuments(completion: { (docSnapShot, error) in
            
            if let error = error {
                
                print("No Session Documents", error.localizedDescription)
                
                return
                
            }
            
            var dictionary = [String : Any]()
            
            dictionary = document.data()!
            
            for document in docSnapShot!.documents {
                
                for (key, value) in document.data() {
                    
                    dictionary[key] = value
                    
                }
                
                completion(dictionary)
                
            }
            
        })

        
    }
    func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser?.uid == nil {
        
            self.perform(#selector(MainViewController.handleLogOut))
            
        } else {
            
            if meditation.count == 0 {
                
                readFromFireBase()
                
            }
         
            
        }
        
    }
    
    func setupNavigationBar() {
        
        navigationController?.navigationBar.tintColor = UIColor(red: 178, green: 34, blue: 34)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(MainViewController.handleLogOut))
        
    }
    
    func setupCollectionView() {
        
        view.addSubview(collectionView)
        
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
    }
    
    
}


extension MainViewController : UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return meditation.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MainCollectionViewCell
        
        cell.meditation = meditation[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let meditation = self.meditation[indexPath.row]
        
        let meditationViewController = MeditationViewController()
        
        meditationViewController.meditaion = meditation
        
        let navigationController = UINavigationController(rootViewController: meditationViewController)
        
        present(navigationController, animated: true, completion: nil)
        
    }
    
}
