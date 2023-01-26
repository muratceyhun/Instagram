//
//  FireStoreExtension.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 2.10.2022.
//

import Firebase



extension Firestore {
    
    static func createUser(userID : String = "", completion : @escaping (User) -> ()) {
        
        
        var logInID = ""
        
        if userID == "" {
            guard let validatedUserID = Auth.auth().currentUser?.uid else { return }
            
            logInID = validatedUserID
        } else {
            logInID = userID
        }
        
        
        Firestore.firestore().collection("Users").document(logInID).getDocument { (snapshot, error) in
            if let error = error {
                print("CANNOT GET USER'S DATA :", error.localizedDescription)
                return
            }
            
            guard let userData = snapshot?.data() else { return }
            
            let user = User(userData: userData)
            completion(user)
        }
         
    }
    
    
    
}
