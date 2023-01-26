//
//  ChoosingPhotoController.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 16.09.2022.
//

import Foundation
import UIKit
import Photos

class ChoosingPhotoController : UICollectionViewController {
        
    let cellID = "cellID"
    let headerID = "headerID"
    
    
     override func viewDidLoad() {
        super.viewDidLoad()
         
         UIApplication.shared.isStatusBarHidden = true
         
        
         collectionView.backgroundColor = .white
         formButtons()
         collectionView.register(ChoosingPhotoCell.self, forCellWithReuseIdentifier: cellID)
         collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
         fetchPhotos()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedPhoto = photos[indexPath.row]
        collectionView.reloadData()
        let indexTop = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexTop, at: .bottom, animated: true)
        
        
        
        
    }
    var assets = [PHAsset]()
    var selectedPhoto : UIImage?
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = true

    }

    
    var photos = [UIImage]()
    
    fileprivate func formPhotoFetchSettings() -> PHFetchOptions {
        let fetchingOptions = PHFetchOptions()
        fetchingOptions.fetchLimit = .max
        let orderSetting = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchingOptions.sortDescriptors = [orderSetting]
        return fetchingOptions
    }
    
    fileprivate func fetchPhotos() {
 
        let photos = PHAsset.fetchAssets(with: .image, options: formPhotoFetchSettings())
        
        DispatchQueue.global(qos: .background).async {
            photos.enumerateObjects { (asset,number,endPoint) in
                
                
                print("\(number). Photo fetched.")
                
                // asset includes all informations about the photos
                // number means which photo calling
                // endPoint occupies endPoint when photos are called.
                
                
                let imageManager = PHImageManager.default()
                let imageSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: options) { (photoView, photoViewData) in
                    
                    
                    if let photo = photoView {
                        self.assets.append(asset)
                        self.photos.append(photo)
                        
                        if self.selectedPhoto == nil {
                            self.selectedPhoto = photoView
                        }
                    }
                    
                    if number == photos.count - 1 {
                        
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()

                        }
                    }
                }
                
            }

        }
        
        
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    var header : PhotoSelectorHeader?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! PhotoSelectorHeader
            
        
        self.header = header
        
        header.imgHeader.image = selectedPhoto
        
        
        if let selectedPhoto = selectedPhoto {
            if let index = self.photos.firstIndex(of: selectedPhoto) {
                let selectedAsset = self.assets[index]
                
                let photoManager = PHImageManager.default()
                let size = CGSize(width: 600, height: 600)
                photoManager.requestImage(for: selectedAsset, targetSize: size, contentMode: .default, options: nil) {(photo,data) in
                    header.imgHeader.image = photo
                }
            }
        }
            
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChoosingPhotoCell
        cell.imgPhoto.image = photos[indexPath.row]
        return cell
    }
    

    
    fileprivate func formButtons() {
        
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(btnCancelPressed))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(btnNextPressed))
        
            
    }
    
    @objc func btnNextPressed() {

        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedPhoto = header?.imgHeader.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
        
        
    }
    

                                                           
    @objc func btnCancelPressed() {
            
            dismiss(animated: true, completion: nil)
            
        }
}






extension ChoosingPhotoController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        
        return CGSize(width: width, height: width)
    }
}
