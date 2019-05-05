//
//  Model.swift
//  KarthikMeditationApp
//
//  Created by Karthik K Manoj on 04/05/19.
//  Copyright © 2019 Karthik K Manoj. All rights reserved.
//

import Foundation


struct Meditation {
    
    var noOfCurrentUser : String
    
    var name : String
    
    var session : Session
    
    var image : String
    
}


struct Session {
    
    var imageLink : String
    
    var link : String
}





