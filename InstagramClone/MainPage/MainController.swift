//
//  MainController.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 22.09.2022.
//

import UIKit
import Firebase
import CoreMIDI


class MainController : UICollectionViewController {
    
    let cellID = "cellID"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshShares), name:SharePhotoController.updatingNotification, object: nil)
        collectionView.backgroundColor = .white
        collectionView.register(MainPageCell.self, forCellWithReuseIdentifier: cellID)
        arrangeButtons()
        fetchUser()
        fetchFollowingUserID()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshShares), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
    }
    
    
    @objc fileprivate func refreshShares() {
        print("Shares have been refreshing...")
        
        shares.removeAll()
        collectionView.reloadData()
        fetchFollowingUserID()
        fetchUser()
        
        
    }
    
    fileprivate func fetchFollowingUserID() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("FollowingList").document(userID).addSnapshotListener { (documentSnapshot,error)  in
            if let error = error {
                print("AN ERROR HAS JUST OCCURED BECAUSE OF FETCHING SHARES ;",error.localizedDescription)
                return
            }
            
            guard let shareDictionaryData = documentSnapshot?.data() else { return }
            
            
            shareDictionaryData.forEach { (key: String, value: Any) in
                Firestore.createUser(userID: key) { (user) in
                    self.fetchShares(user: user)
                }
            }
        }
    }
    
    
    
    var shares = [Share]()
    fileprivate func fetchShares(user : User){
        
        Firestore.firestore().collection("Shares").document(user.userID)
            .collection("Photo_Shares").order(by: "Date", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.collectionView.refreshControl?.endRefreshing()
                
                
                
                if let error = error {
                    print("An error has just happened when shares were fetched.", error.localizedDescription)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ (changes) in
                    if changes.type == .added {
                        let shareData = changes.document.data()
                        var share = Share(user : user ,dataDictionary: shareData)
                        share.id = changes.document.documentID
                        
                        
                        guard let validatedUserID = Auth.auth().currentUser?.uid else { return }
                        
                        guard let shareID = share.id else { return }
                        
                        Firestore.firestore().collection("Likes").document(shareID).getDocument { (snapshot,error) in
                            if let error = error {
                                print("CANNOT GET LIKE DATA :", error.localizedDescription)
                            }
                            
                            let likeData = snapshot?.data()
                            if let likeValue = likeData?[validatedUserID] as? Int, likeValue == 1 {
                                share.liked = true
                            } else {
                                share.liked = false
                            }
                            self.shares.append(share)
                            
                            self.shares.reverse()
                            
                            self.shares.sort { (p1, p2) -> Bool in
                                return p1.date.dateValue().compare(p2.date.dateValue()) == .orderedDescending
                            }
                            self.collectionView.reloadData()
                        }
                        
                    }
                })
        }
    }
    fileprivate func arrangeButtons(){
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "Logo_Instagram2").withRenderingMode(.alwaysOriginal))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "Camera").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(setCamera))
    }
    
    @objc fileprivate func setCamera(){

        let cameraController = CameraController()
        cameraController.modalPresentationStyle = .fullScreen
        present(cameraController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shares.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MainPageCell
        cell.share = shares[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    var validatedUser : User?
    
    fileprivate func fetchUser(userID : String = "") {
        guard let validateduserID = Auth.auth().currentUser?.uid else { return }
        let logInID = userID == "" ? validateduserID : userID
        
        Firestore.firestore().collection("Users").document(logInID).getDocument { (snapshot,error) in
            if let error = error {
                print("User's data cannot be fetched right now.", error)
                return
            }
            
            guard let userData = snapshot?.data() else { return }
            self.validatedUser = User(userData: userData)
            
            guard let user = self.validatedUser else {return}
            self.fetchShares(user: user)
        }
    }
 }
    
extension MainController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 55
        height = height + view.frame.width
        height = height + 50
        height = height + 60
        return CGSize(width: view.frame.width, height: height)
    }
}


extension MainController : MainPageCellDelegate {
    
    func pressedLike(cell: MainPageCell) {

        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        var share = self.shares[indexPath.row]

        guard let shareID = share.id else { return }
        guard let validatedUserID = Auth.auth().currentUser?.uid else { return }
        let additiveValue = [validatedUserID : share.liked == true ? 0 : 1 ]
        
        Firestore.firestore().collection("Likes").document(shareID).getDocument { (snapshot, error) in
            if let error = error {
                print("CANNOT GET LIKE DATA :", error.localizedDescription)
                return
            }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("Likes").document(shareID).updateData(additiveValue) {
                    (error) in
                    if let error = error {
                        print("LIKE UPDATE IS NOT SUCCESSFULL : ", error.localizedDescription)
                        return
                    }
                    
                    print("YOU HAVE JUST LIKED THE POST")
                    
                    share.liked = !share.liked
                    self.shares[indexPath.row] = share
                    self.collectionView.reloadItems(at: [indexPath])
                    
                    
                }
            } else {
                Firestore.firestore().collection("Likes").document(shareID).setData(additiveValue) {
                    (error) in
                    
                    if let error = error {
                        print("CANNOT GET LIKE DATA : ", error.localizedDescription)
                        return
                    }
                    
                    print("YOU HAVE JUST LIKED THE POST")
                    share.liked = !share.liked
                    self.shares[indexPath.row] = share
                    self.collectionView.reloadItems(at: [indexPath])
                }
            }
        }
        
    }
    func pressedComment(share : Share) {
        print(share.message)
        
        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.chosenShare = share
        navigationController?.pushViewController(commentController, animated: true)
    }
}
