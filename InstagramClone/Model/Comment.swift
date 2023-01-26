//
//  Comment.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 6.10.2022.
//

import Foundation


struct Comment {
    
    var user : User
    let commentMessage : String
    let userID : String
    
    
    init(user : User, dataDictionary : [String : Any]) {
        self.user = user
        self.commentMessage = dataDictionary["commentMessage"] as? String ?? ""
        self.userID = dataDictionary["userID"] as? String ?? ""
    }
}
