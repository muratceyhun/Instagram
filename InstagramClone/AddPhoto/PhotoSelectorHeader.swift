//
//  PhotoSelectorHeader.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 18.09.2022.
//

import UIKit



class PhotoSelectorHeader : UICollectionViewCell {
    
    let imgHeader : UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .white
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imgHeader)
        imgHeader.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
