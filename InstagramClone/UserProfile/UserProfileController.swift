//
//  UserProfileController.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 10.09.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class UserProfileController : UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        callUser()
        
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath)
        header.backgroundColor = .green
        return header
    }
    
    fileprivate func callUser() {
        
        guard let validatedUserId = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("Users").document(validatedUserId).getDocument { (snapshot, error) in
            
            if let error = error {
                print("USER'S INFORMATION CAN'T BE REACHED AT THE MOMENT")
                return
            }
            
            
            guard let userData = snapshot?.data() else {return}
            let userName = userData["UserName"] as? String
            self.navigationItem.title = userName
            print ("User ID : ", validatedUserId)
            print("User Name : ", userName ?? "")
        }
        
    }
}



extension UserProfileController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
   
}
