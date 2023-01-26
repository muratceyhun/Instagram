//
//  SharePhotoController.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 18.09.2022.
//

import UIKit
import JGProgressHUD
import Firebase



class SharePhotoController : UIViewController {
    
    var selectedPhoto : UIImage? {
        didSet {

            self.imgShare.image = selectedPhoto

        }
    }
    
    let txtMessage : UITextView = {
       let txt = UITextView()
        txt.font = UIFont.systemFont(ofSize: 15)
        return txt
    }()
    
    let imgShare : UIImageView = {
        
        let img = UIImageView()
        img.backgroundColor = .blue
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isStatusBarHidden = true

                
        
        view.backgroundColor = UIColor.RGBConverter(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(btnSharePressed))
        formTextAreaForShare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = true

    }
    
    
    fileprivate func formTextAreaForShare() {
        let shareView = UIView()
        shareView.backgroundColor = .white
        
        view.addSubview(shareView)
        shareView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 120)
        
        
        view.addSubview(imgShare)
        imgShare.anchor(top: shareView.topAnchor, bottom: shareView.bottomAnchor, leading: shareView.leadingAnchor, trailing: nil, paddingTop: 8, paddingBottom: -8, paddingLeft: 8, paddingRight: 0, width: 85, height: 0)
        
        view.addSubview(txtMessage)
        txtMessage.anchor(top: shareView.topAnchor, bottom: shareView.bottomAnchor, leading: imgShare.trailingAnchor, trailing: shareView.trailingAnchor, paddingTop: 12, paddingBottom: -8, paddingLeft: 8, paddingRight: -8, width: 0, height: 0)
    }
    
    @objc fileprivate func btnSharePressed() {

        navigationItem.rightBarButtonItem?.isEnabled = false
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Post is loading..."
        hud.show(in: self.view)
        
        let photoName = UUID().uuidString
        guard let sharedPhoto = selectedPhoto else { return }
        let photoData = selectedPhoto?.jpegData(compressionQuality: 0.8) ?? Data()
        
        let ref = Storage.storage().reference(withPath: "/Shares/\(photoName)")
        
        ref.putData(photoData, metadata: nil)  {(_, error) in
            if let error = error {
                print("Photo is not able to be uploaded. " , error)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                hud.textLabel.text = "Photo cannot be uploaded."
                hud.dismiss(afterDelay: 2)
                return
            }
            print("Photo has just uploaded.")
            ref.downloadURL { (url,error)  in
                hud.textLabel.text = "Photo has just uploaded."
                hud.dismiss(afterDelay: 2)
                if let error = error {
                    print("Photo's URL cant be obtained. ", error)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    return
                }
                
                print("Photo's URL address : \(url?.absoluteString)")
                
                if let url = url {
                    self.saveShareFS(viewURL: url.absoluteString)
                }
            }
        }
    }
    
    static let updatingNotification = Notification.Name("UpdateShares")

    
    fileprivate func saveShareFS(viewURL : String) {
        guard let sharedPhoto = selectedPhoto else { return }
        guard let comment = txtMessage.text,
              comment.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else { return }
        guard let validatedUserID = Auth.auth().currentUser?.uid else { return }
        let addingData = ["UserID" : validatedUserID,
                          "ShareViewURL" : viewURL,
                          "Comment" : comment,
                          "PhotoWidth" : sharedPhoto.size.width,
                          "PhotoHeight" : sharedPhoto.size.height,
                          "Date" : Timestamp(date: Date())
                         ] as [String : Any]
                             
        
        var ref : DocumentReference? = nil
        ref = Firestore.firestore().collection("Shares").document(validatedUserID).collection("Photo_Shares").addDocument(data: addingData, completion: { (error) in
            if let error = error {
                print("An error has just occured" , error)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            
            print("Post has been uploaded successfully. Post's ID : ", ref?.documentID)
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: SharePhotoController.updatingNotification, object: nil)

        })
        
    }
    
}








