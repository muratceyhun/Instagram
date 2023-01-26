//
//  MainPageCell.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 22.09.2022.
//

import UIKit

protocol MainPageCellDelegate {
    func pressedComment(share : Share)
    func pressedLike(cell : MainPageCell)
}



class MainPageCell : UICollectionViewCell {
    var delegate : MainPageCellDelegate?
    var share : Share? {
        didSet {
                
            guard let url = share?.shareViewURL,
                  let viewURL = URL(string: url) else { return }
            imgSharePhoto.sd_setImage(with: viewURL, completed: nil)
        
            lblUserName.text = share?.user.userName
            
            guard let pURL = share?.user.profilePhotoURL,
                  let profileViewURL = URL(string: pURL) else { return }
            imgUserProfilePhoto.sd_setImage(with: profileViewURL, completed: nil)
            
            formAttrShareComment()
            
            if share?.liked == true {
                btnLike.setImage(#imageLiteral(resourceName: "Like_Selected").withRenderingMode(.alwaysOriginal), for: .normal)
            } else {
                btnLike.setImage(#imageLiteral(resourceName: "Like_Unselected").withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    fileprivate func formAttrShareComment() {
        guard let share = self.share else { return }
        let attrText = NSMutableAttributedString(string: share.user.userName, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attrText.append(NSAttributedString(string:" \(share.message ?? "")", attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        attrText.append(NSAttributedString(string: "\n\n", attributes: [.font : UIFont.systemFont(ofSize: 4)]))
        let shareDate = share.date.dateValue()
        attrText.append(NSAttributedString(string: shareDate.dateExpression(), attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.gray]))
        lblShareComent.attributedText = attrText
        
    }
    
    let lblShareComent : UILabel = {
       let lbl = UILabel()
        
        
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let btnBookmark : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "Bookmark").withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let btnLike : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName : "Like_Unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnLikePressed), for: .touchUpInside)
        return btn
    }()
    
    
    @objc fileprivate func btnLikePressed(){
        print("Like Btn Pressed.")
        delegate?.pressedLike(cell: self)
    }
    
    let btnComment : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName : "Comment").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnCommentPressed), for: .touchUpInside)
        return btn
    }()
    
    
    @objc fileprivate func btnCommentPressed() {
        
        
        print("COMMENTTTT")
        guard let share = self.share  else { return }
        delegate?.pressedComment(share : share)
        
    }
    
    let btnMessage : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName : "Send").withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let btnOptions : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("•••", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    
    let lblUserName : UILabel = {
        let lbl = UILabel()
        lbl.text = "User Name"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    
    let imgUserProfilePhoto : UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .blue
        return img
    }()
    
    
    let imgSharePhoto : UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgUserProfilePhoto)
        addSubview(imgSharePhoto)
        addSubview(lblUserName)
        addSubview(btnOptions)
        addSubview(btnBookmark)
        
        imgUserProfilePhoto.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        
        imgUserProfilePhoto.layer.cornerRadius = 40/2
        
        imgSharePhoto.anchor(top: imgUserProfilePhoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        lblUserName.anchor(top: topAnchor, bottom: imgSharePhoto.topAnchor, leading: imgUserProfilePhoto.trailingAnchor, trailing: btnOptions.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        
        btnOptions.anchor(top: topAnchor, bottom: imgSharePhoto.topAnchor, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 45, height: 0)
        
        _ = imgSharePhoto.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        formButtons()
        
        btnBookmark.anchor(top: imgSharePhoto.bottomAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 40, height: 50)
        
        
    }
    
    fileprivate func formButtons() {
        let stackView = UIStackView(arrangedSubviews: [btnLike,btnComment,btnMessage])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        addSubview(lblShareComent)
        stackView.anchor(top: imgSharePhoto.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 120, height: 50)
        lblShareComent.anchor(top: btnLike.bottomAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: -8, width: 0, height: 0)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
      
}
