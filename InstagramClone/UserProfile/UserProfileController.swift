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
    
    
    let listViewCellID = "listViewCellID"
    var gridView = true
    var userID : String?
    let postCellID = "postCellID"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        callUser()
        
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        
        collectionView.register(UserSharePhotoCell.self, forCellWithReuseIdentifier: postCellID)
        
        collectionView.register(MainPageCell.self, forCellWithReuseIdentifier: listViewCellID)
        btnProfileSetting()
        
    }
    var shares = [Share]()
    fileprivate func fetchSharesFS() {
        
        //guard let validatedUserID = Auth.auth().currentUser?.uid else { return }
        
        guard let validatedUserID = self.validatedUser?.userID else { return }
        
        guard let validatedUser = validatedUser else { return }
        Firestore.firestore().collection("Shares").document(validatedUserID).collection("Photo_Shares").order(by: "Date", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("An error has just occured when shares fetched.", error)
                    return
                }
            
                querySnapshot?.documentChanges.forEach({ (changes) in
                    if changes.type == .added {
                        let dataShare = changes.document.data()
                        let share = Share(user: validatedUser, dataDictionary: dataShare)
                        self.shares.append(share)
                    }
                })
                
                // all shares transfer to the share array.
                
                self.shares.reverse()
                self.collectionView.reloadData()
                
            }
       
        
    }
    fileprivate func btnProfileSetting() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName:"Settings").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(logOutProfile))
    }
    
    
    @objc fileprivate func logOutProfile(){

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionLogOut = UIAlertAction(title: "Log Out", style: .destructive) { (_) in
            
            guard let _ = Auth.auth().currentUser?.uid else {return}
            do {
                try Auth.auth().signOut()
                let logInController = LogInController()
                let navController = UINavigationController(rootViewController: logInController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            } catch let logOutError {
                print("IT'S AN ERROR ABOUT LOGGING OUT ", logOutError)
            }

        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(actionLogOut)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if gridView {
            
            let width = (view.frame.width - 5 ) / 3
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: view.frame.width, height: view.frame.width + 210)
        }
       
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shares.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == self.shares.count - 1 {
            print("Fetchs new datas")
            pagingShares()
        }
        
        
        
        if gridView {
            let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellID, for: indexPath) as! UserSharePhotoCell
            postCell.share = shares[indexPath.row]
            return postCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listViewCellID, for: indexPath) as! MainPageCell
            cell.share = shares[indexPath.row]
            return cell
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader
        header.validatedUser = validatedUser
        header.delegate = self
        return header
    }
    var validatedUser : User?
    fileprivate func callUser() {
        
       // guard let validatedUserId = Auth.auth().currentUser?.uid else {return}
        
        let validatedUserId = userID ?? Auth.auth().currentUser?.uid ?? ""
        
        Firestore.firestore().collection("Users").document(validatedUserId).getDocument { (snapshot, error) in
            
            if let error = error {
                print("USER'S INFORMATION CAN'T BE REACHED AT THE MOMENT : ", error)
                return
            }
            
            
            guard let userData = snapshot?.data() else {return}
            //let userName = userData["UserName"] as? String
            self.validatedUser = User(userData: userData)
            //self.fetchSharesFS()
            self.pagingShares()
            self.navigationItem.title = self.validatedUser?.userName
            
        }
        
    }
    let pageNumber : Int = 2
    var fetchedLastShare : QueryDocumentSnapshot?
    fileprivate func pagingShares(){
        
        guard let validatedUser = self.validatedUser else { return }
        
        var demand = Firestore.firestore().collection("Shares").document(validatedUser.userID).collection("Photo_Shares").order(by: "Date", descending: true).limit(to: pageNumber)
        
        
        if let lastShare = fetchedLastShare {
            demand = demand.start(afterDocument: lastShare)
        }
        
        
        demand.addSnapshotListener { (snapshot,error) in
            if let error = error {
                print("AN ERROR HAS JUST OCCURED:", error.localizedDescription)
                return
            }
            
            guard (snapshot?.documents.last) != nil else {return}
            
            self.fetchedLastShare = snapshot?.documents.last
            print(self.fetchedLastShare?.data())
            
            snapshot?.documentChanges.forEach({ (documentChange) in
                let dataDictionary = documentChange.document.data()
                
                let share = Share(user: validatedUser, dataDictionary: dataDictionary)
                self.shares.append(share)
            })
            
            self.collectionView.reloadData()
            
        }
       
    }
}



extension UserProfileController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
   
}


extension UserProfileController : UserProfileHeaderDelegate {
    func gridViewIsOn() {
        gridView = true
        collectionView.reloadData()
    }
    
    func listViewIsOn() {
        gridView = false
        collectionView.reloadData()
    }
}
