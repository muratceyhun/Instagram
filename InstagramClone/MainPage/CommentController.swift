//
//  CommentController.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 5.10.2022.
//

import UIKit
import Firebase

class CommentController : UICollectionViewController {
    
    var chosenShare : Share?
    let commentCellID = "commentCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -80, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -80, right: 0)
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: commentCellID)
        
        fetchComment()
    }
    
    var comments = [Comment]()
    
    fileprivate func fetchComment() {
        
        guard let shareID = self.chosenShare?.id else { return }
        
        Firestore.firestore().collection("Comments").document(shareID).collection("Inserted_Comments").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("AN ERROR HAS JUST OCCURED BECAUSE OF COMMENTS : ", error.localizedDescription)
                return
            }
            

            snapshot?.documentChanges.forEach({ (documentChange) in
                let dictionaryData = documentChange.document.data()
                
                guard let userID = dictionaryData["userID"] as? String else { return }
                
                Firestore.createUser(userID: userID) { (user) in
                    var comment = Comment(user: user, dataDictionary: dictionaryData)
                    self.comments.append(comment)
                    self.collectionView.reloadData()
                }
            })


        }
        
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellID, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    
    lazy var containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        
        
        let btnLeaveComment = UIButton(type: .system)
        btnLeaveComment.setTitle("Send", for: .normal)
        btnLeaveComment.setTitleColor(.black, for: .normal)
        btnLeaveComment.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btnLeaveComment.addTarget(self, action: #selector(btnLeaveCommentPressed), for: .touchUpInside)
        
        
        
        containerView.addSubview(btnLeaveComment)
        
        btnLeaveComment.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: containerView.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 80, height: 0)
        
        
        
        containerView.addSubview(txtComment)
        txtComment.anchor(top: containerView.safeAreaLayoutGuide.topAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, leading: containerView.safeAreaLayoutGuide.leadingAnchor, trailing: btnLeaveComment.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.RGBConverter(red: 230, green: 230, blue: 230)
        containerView.addSubview(bottomLine)
        
        
        bottomLine.anchor(top: containerView.topAnchor, bottom: nil, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.9)
        
        return containerView
    }()
    
    let txtComment : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Leave a comment..."
        return txt
    }()
    
    
    @objc fileprivate func btnLeaveCommentPressed() {
        
        
        if let comment = txtComment.text, comment.isEmpty {
            return
        }

        guard let validatedUserID = Auth.auth().currentUser?.uid else { return }
        
        
        
        let shareID = self.chosenShare?.id ?? ""
        let additiveValue = ["commentMessage" : txtComment.text ?? "", "dateOfShare" : Date().timeIntervalSince1970, "userID" : validatedUserID] as [String : Any]
        
        Firestore.firestore().collection("Comments").document(shareID).collection("Inserted_Comments").document().setData(additiveValue) { (error) in
            if let error = error {
                print("AN ERROR HAS JUST OCCURED BECAUSE OF COMMENT :", error.localizedDescription)
            }
            
            print("Comment left successfully.")
            self.txtComment.text = ""
        }
        
        
    }
    
    
    
    override var inputAccessoryView: UIView? {
        get {
            
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
}

extension CommentController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let temproraryCell = CommentCell(frame: frame)
        
        temproraryCell.comment = comments[indexPath.row]
        
        temproraryCell.layoutIfNeeded()
        
        
        let targetSize = CGSize(width: view.frame.width, height: 9999)
        
        let estimatedSize = temproraryCell.systemLayoutSizeFitting(targetSize)
        
        
        let height = max(60, estimatedSize.height)
        
        
        
        return CGSize(width: view.frame.width, height: height)
    }
}
