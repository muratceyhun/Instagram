//
//  UserProfileHeader.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 10.09.2022.
//

import Foundation
import UIKit
import FirebaseFirestore
import Firebase
import SDWebImage


protocol UserProfileHeaderDelegate {
    func gridViewIsOn()
    func listViewIsOn()
}



class UserProfileHeader : UICollectionViewCell {
    
    var delegate : UserProfileHeaderDelegate?
    var validatedUser : User? {
        didSet {
            setFollowButton()
            guard let url = URL(string: validatedUser?.profilePhotoURL ?? "") else {return}
            imgProfilePhoto.sd_setImage(with: url, completed: nil)
            lblUserName.text = validatedUser?.userName
            
        }
    }
    
    fileprivate func setFollowButton() {
        
        guard let logInID = Auth.auth().currentUser?.uid else { return }
        guard let guestID = validatedUser?.userID else { return }
        
        if logInID != guestID {
            
            Firestore.firestore().collection("FollowingList").document(logInID).getDocument { (snapshot, error) in
                if let error = error {
                    print("CANNOT OBTAIN FOLLOW DATA :", error.localizedDescription)
                    return
                }
                
                guard let followData = snapshot?.data() else { return }
                
                if let data = followData[guestID] {
                    let follow = data as! Int
                    print(follow)
                    
                    if follow == 1 {
                    self.btnEditProfile.setTitle("Unfollow", for: .normal)
                    }
                } else {
                    self.btnEditProfile.setTitle("Follow", for: .normal)
                    self.btnEditProfile.backgroundColor = UIColor.RGBConverter(red: 20, green: 155, blue: 240)
                    self.btnEditProfile.setTitleColor(.white, for: .normal)
                    self.btnEditProfile.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
                    self.btnEditProfile.layer.borderWidth = 1
                    
                }
                
            }
        
            
        } else {
            self.btnEditProfile.setTitle("Edit Profile", for: .normal)
            self.btnEditProfile.isEnabled = false

        }
        
    }

    let btnEditProfile : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(btnProfile_follow_set), for: .touchUpInside)
        return btn
    
        
    }()
    
    @objc fileprivate func btnProfile_follow_set() {

        guard let logInID = Auth.auth().currentUser?.uid else { return }
        guard let guestID = validatedUser?.userID else { return }
        
        if btnEditProfile.titleLabel?.text == "Unfollow" {
            Firestore.firestore().collection("FollowingList").document(logInID).updateData([guestID : FieldValue.delete()]) { (error) in
                if let error = error {
                    print("AN ERROR OCCURED WHEN UNFOLLOW: ", error.localizedDescription)
                    return
                }
                
                print("\(self.validatedUser?.userName ?? "") has been unfollowed.")
                self.btnEditProfile.backgroundColor = UIColor.RGBConverter(red: 20, green: 155, blue: 240)
                self.btnEditProfile.setTitleColor(.white, for: .normal)
                self.btnEditProfile.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
                self.btnEditProfile.layer.borderWidth = 1
                self.btnEditProfile.setTitle("Follow", for: .normal)
            }
            
            return
        }
        
        let additiveValue = [guestID : 1]
        
        Firestore.firestore().collection("FollowingList").document(logInID).getDocument {
            (snapshot, error) in
            if let error = error {
                print("CANNOT OBTAIN FOLLOW DATA : \(error.localizedDescription)")
                return
            }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("FollowingList").document(logInID).updateData(additiveValue) {
                    (error) in
                    if let error = error {
                        print("CANNOT UPDATE FOLLOWING LIST : \(error.localizedDescription)")
                        return
                    }
                    
                    print("\(self.validatedUser?.userName ?? "") has been followed by you.")
                    self.btnEditProfile.setTitle("Unfollow", for: .normal)
                    self.btnEditProfile.setTitleColor(.black, for: .normal)
                    self.btnEditProfile.backgroundColor = .white
                    self.btnEditProfile.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    self.btnEditProfile.layer.borderColor = UIColor.lightGray.cgColor
                    self.btnEditProfile.layer.borderWidth = 1
                    self.btnEditProfile.layer.cornerRadius = 5
                }
            } else {
                Firestore.firestore().collection("FollowingList").document(logInID).setData(additiveValue) {
                    (error) in
                    if let error = error {
                        print("AN ERROR HAS JUST OCCURED BECAUSE OF FOLLOWING LIST:  \(error.localizedDescription)")
                        return
                    }
                    print("\(self.validatedUser?.userName ?? "") has been followed by you.")
                }
            }
        }
        
        
    }
    
    let lblShares : UILabel = {
       
        let lbl = UILabel()
        let attrText = NSMutableAttributedString(string: "10\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
        attrText.append(NSAttributedString(string: "Shares", attributes: [
            .foregroundColor : UIColor.darkGray,
            .font : UIFont.systemFont(ofSize: 15)
        ]))
        
        lbl.attributedText = attrText
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let lblFollowers : UILabel = {
        
        let lbl = UILabel()
        let attrText = NSMutableAttributedString(string: "145\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
        attrText.append(NSAttributedString(string: "Followers", attributes: [.foregroundColor : UIColor.darkGray,.font : UIFont.systemFont(ofSize: 15)
        ]))
        
        lbl.attributedText = attrText
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let lblFollowing : UILabel = {
       let lbl = UILabel()

        let attrText = NSMutableAttributedString(string: "142\n", attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
        
        attrText.append(NSAttributedString(string: "Following",attributes: [.foregroundColor : UIColor.darkGray,.font : UIFont.systemFont(ofSize: 15)]))
        lbl.attributedText = attrText
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
        
        let lblUserName : UILabel = {
        let lbl = UILabel()
        lbl.text = "User Name"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    
    let btnGrid : UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(btnGridPressed), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName : "Grid"), for: .normal)
        return btn
    }()
    
    @objc fileprivate func btnGridPressed() {
        print("Grid View Mode is On")
        btnGrid.tintColor = .mainBlue()
        btnList.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.gridViewIsOn()
    }
    
    let btnList : UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        btn.addTarget(self, action: #selector(btnListPressed), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName : "List"), for: .normal)
        return btn
    }()
    
    @objc fileprivate func btnListPressed(){
        print("List View Mode is On")
        btnList.tintColor = .mainBlue()
        btnGrid.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.listViewIsOn()
        
    }
    
    let btnSavedIcon : UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        btn.setImage(#imageLiteral(resourceName : "Bookmark"), for: .normal)
        return btn
    }()
    
    
    
    
    
    let imgProfilePhoto : UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .yellow
        return img
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgProfilePhoto)
        let photoSize : CGFloat = 90
        imgProfilePhoto.anchor(top: topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: photoSize, height: photoSize)
        imgProfilePhoto.layer.cornerRadius = photoSize/2
        imgProfilePhoto.clipsToBounds = true
        toolbarForm()
        addSubview(lblUserName)
        userInformation()
        lblUserName.anchor(top: imgProfilePhoto.bottomAnchor, bottom: btnGrid.topAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 15, paddingRight: 15, width: 0, height: 0)
        
        addSubview(btnEditProfile)
        
        btnEditProfile.anchor(top:lblShares.bottomAnchor, bottom: nil, leading: lblShares.leadingAnchor, trailing: lblFollowing.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 35)
    }
    
    fileprivate func toolbarForm(){
        
        let upView = UIView()
        upView.backgroundColor = UIColor.lightGray
        
        let downView = UIView()
        downView.backgroundColor = UIColor.lightGray
        
        
        
        let stackView = UIStackView(arrangedSubviews: [btnGrid,btnList,btnSavedIcon])
        addSubview(stackView)
        
        addSubview(upView)
        addSubview(downView)
        upView.anchor(top: stackView.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        downView.anchor(top: stackView.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
    }
    
    
    fileprivate func userInformation() {
        let stackView = UIStackView(arrangedSubviews: [lblShares,lblFollowers,lblFollowing])
        addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.anchor(top: topAnchor, bottom: nil, leading: imgProfilePhoto.trailingAnchor, trailing: trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 15, paddingRight: -15, width: 0, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
