//
//  UserSharePhotoCell.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 20.09.2022.
//

import UIKit

class UserSharePhotoCell : UICollectionViewCell {
    var share : Share? {
        didSet {
            
            if let url = URL(string: share?.shareViewURL ?? "") {
            imgPhotoShare.sd_setImage(with: url, completed: nil)
            }
        }
    }
    let imgPhotoShare : UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .white
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgPhotoShare)
        
        imgPhotoShare.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
