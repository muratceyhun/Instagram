//
//  User.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 10.09.2022.
//

import Foundation



struct User {
    
    let userName : String
    let userID : String
    let profilePhotoURL : String
    
    init(userData : [String : Any]) {
        
        
        self.userName = userData["UserName"] as? String ?? ""
        self.userID = userData["UserID"] as? String ?? ""
        self.profilePhotoURL = userData["ProfilePhotoURL"] as? String ?? ""
    }
    
}
