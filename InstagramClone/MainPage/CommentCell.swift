//
//  CommentCell.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 6.10.2022.
//

import UIKit

class CommentCell : UICollectionViewCell {
    var comment : Comment? {
        didSet {
            guard let comment = comment else { return }
            imgUserProfile.sd_setImage(with: URL(string: comment.user.profilePhotoURL), completed:nil)
            let attrText = NSMutableAttributedString(string: comment.user.userName, attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
            lblComment.attributedText = attrText
            attrText.append(NSAttributedString(string: " " + (comment.commentMessage), attributes: [.font : UIFont.systemFont(ofSize: 15)]))
            lblComment.attributedText = attrText
            
        }
    }
    

    let imgUserProfile : UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 50/2
        return img
    }()
    
    let lblComment : UITextView = {
        let lbl = UITextView()
        lbl.isEditable = false
        lbl.isScrollEnabled = false
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        addSubview(imgUserProfile)
        imgUserProfile.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 10, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 50, height: 50)
        addSubview(lblComment)
        lblComment.anchor(top: topAnchor, bottom: bottomAnchor, leading: imgUserProfile.trailingAnchor, trailing: trailingAnchor, paddingTop: 5, paddingBottom: -5, paddingLeft: 5, paddingRight: -5, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
