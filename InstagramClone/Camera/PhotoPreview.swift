//
//  PhotoPreview.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 2.10.2022.
//

import Foundation
import UIKit
import Photos


class PhotoPreview : UIView {
    
    let btnSave : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(imageLiteralResourceName: "Photo_Saved").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnSavePressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnSavePressed() {
        
        guard let savedPhoto = imgPhotoPreview.image else { return }
        
        let library = PHPhotoLibrary.shared()
        
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: savedPhoto)
            
        }) { (result, error)  in
            if let error = error {
                print("An error has just occured when the photo was saving :", error.localizedDescription)
                return
            }
            
            print("Photo saved successfully")
            
            DispatchQueue.main.async {
                let lblSaved = UILabel()
                lblSaved.text = "Saved"
                lblSaved.font = UIFont.boldSystemFont(ofSize: 16)
                lblSaved.textColor = .white
                lblSaved.numberOfLines = 0
                lblSaved.backgroundColor = UIColor(white: 0, alpha: 0.3)
                lblSaved.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
                lblSaved.textAlignment = .center
                lblSaved.center = self.center
                self.addSubview(lblSaved)
                lblSaved.layer.transform = CATransform3DMakeScale(0, 0, 0)
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {lblSaved.layer.transform = CATransform3DMakeScale(1, 1, 1)}) { (completed) in
                    
                    
                    
                    UIView.animate(withDuration: 0.6, delay: 0.75, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseOut, animations: {
                        lblSaved.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                    }) { (_) in
                        lblSaved.removeFromSuperview()
                    }

                }
            }
         }
    }
    
    let btnCancel : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(imageLiteralResourceName: "Photo_Cancel").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnCancelPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnCancelPressed() {
    
        self.removeFromSuperview()

    }
    
    
    let imgPhotoPreview : UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        
        setButtons()
    }
    
    fileprivate func setButtons() {
        addSubview(imgPhotoPreview)
        imgPhotoPreview.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(btnCancel)
        btnCancel.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 80, height: 80)
        
        addSubview(btnSave)
        btnSave.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, paddingTop: 0, paddingBottom: -25, paddingLeft: 25, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
