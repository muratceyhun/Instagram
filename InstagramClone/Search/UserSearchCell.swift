//
//  UserSearchCell.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 25.09.2022.
//

import UIKit


class UserSearchCell : UICollectionViewCell {
    
    
    var user : User? {
        didSet {
            lblUserName.text = user?.userName
            if let url = URL(string: user?.profilePhotoURL ?? "") {
                imgUserProfile.sd_setImage(with: url, completed: nil)
            }
                
        }
    }
    
    
    
    let lblUserName : UILabel = {
       let lbl = UILabel()
        lbl.text = "User Name"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    
    
    let imgUserProfile : UIImageView = {
       let img = UIImageView()
        img.backgroundColor = .orange
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(imgUserProfile)
        imgUserProfile.layer.cornerRadius = 55/2
        imgUserProfile.anchor(top: nil, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 55, height: 55)
        imgUserProfile.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(lblUserName)
        lblUserName.anchor(top: topAnchor, bottom: bottomAnchor, leading: imgUserProfile.trailingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 0, height: 0)
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(white: 0, alpha: 0.45)
        addSubview(lineView)
        lineView.anchor(top: nil, bottom: bottomAnchor, leading: lblUserName.leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.25)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
