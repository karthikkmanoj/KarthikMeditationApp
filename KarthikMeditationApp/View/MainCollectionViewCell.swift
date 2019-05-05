//
//  MainCollectionViewCell.swift
//  KarthikMeditationApp
//
//  Created by Karthik K Manoj on 03/05/19.
//  Copyright © 2019 Karthik K Manoj. All rights reserved.
//

import UIKit
import Kingfisher

class MainCollectionViewCell: UICollectionViewCell {
    
    var meditation : Meditation! {
        
        didSet {
            
            guard let url = URL(string: meditation.image) else { return }
            
            imageView.kf.setImage(with: url)
            
            label.text = meditation.name
            
        }
        
    }
    

    let label : UILabel = {
       
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 20.0)
        
        return label
        
    }()
    
    let imageView : UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupCell()
        
    }
    
 
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainCollectionViewCell {
    
    func setupCell() {
        
        contentView.updateViewLayer()
        
        addSubview(imageView)
        
        addSubview(label)
        
        imageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        imageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 50).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 50).isActive = true
        
        
    }
    
    
}
