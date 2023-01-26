//
//  Share.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 20.09.2022.
//

import Firebase


struct Share {
    var id : String?
    let user : User
    let shareViewURL : String?
    let viewWidth : Double?
    let viewHeight : Double?
    let userID : String?
    let message : String?
    let date : Timestamp
    var liked : Bool = false
    
    
    init(user : User, dataDictionary : [String : Any]) {
        self.user = user
        self.shareViewURL = dataDictionary["ShareViewURL"] as? String
        self.viewWidth = dataDictionary["PhotoWidth"] as? Double
        self.viewHeight = dataDictionary["PhotoHeight"] as? Double
        self.userID = dataDictionary["UserID"] as? String
        self.message = dataDictionary["Comment"] as? String
        self.date = dataDictionary["Date"] as? Timestamp ?? Timestamp(date : Date())
    }
    
    
    
    
    
    
}
