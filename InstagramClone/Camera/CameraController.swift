//
//  CameraController.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 2.10.2022.
//

import UIKit
import AVFoundation
import JGProgressHUD


class CameraController : UIViewController, UIViewControllerTransitioningDelegate {
    
    
    let btnSettingsPhoto : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(imageLiteralResourceName: "Settings").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnSettingsPhotoPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnSettingsPhotoPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    let btnCancelPhoto : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(imageLiteralResourceName: "Photo_Cancel").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnCancelPhotoPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnCancelPhotoPressed() {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    let btnTakeAPhoto : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(imageLiteralResourceName: "Photo_Press").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(btnTakePhotoPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnTakePhotoPressed() {
        print("Took Photo !!!")
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    override func viewDidLoad() {
        UIApplication.shared.isStatusBarHidden = true

        super.viewDidLoad()
        view.backgroundColor = .yellow
        takePhoto()
        setCameraButtons()
        transitioningDelegate = self
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false

    }
    
    fileprivate func setCameraButtons() {
        view.addSubview(btnTakeAPhoto)
        view.addSubview(btnCancelPhoto)
        view.addSubview(btnSettingsPhoto)
        btnTakeAPhoto.anchor(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: -50, paddingLeft: 0, paddingRight: 0, width: 80, height: 80)
        btnTakeAPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        btnCancelPhoto.anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: nil, paddingTop: 50, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 50, height: 50)
        
        btnSettingsPhoto.anchor(top: view.topAnchor, bottom: nil, leading: nil, trailing: view.trailingAnchor, paddingTop: 50, paddingBottom: 0, paddingLeft: 0, paddingRight: -10, width: 50, height: 50)
    }
    
    
    let output = AVCapturePhotoOutput()

    fileprivate func takePhoto() {
        let captureSession = AVCaptureSession()
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        do {
            let action = try AVCaptureDeviceInput(device: device)
            
            if captureSession.canAddInput(action) {
                captureSession.addInput(action)
            }
            
            
        } catch let error {
            print("CANNOT REACH TO THE CAMERA:", error.localizedDescription)
        }
        
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        
        let preView = AVCaptureVideoPreviewLayer(session: captureSession)
        preView.frame = view.frame
        view.layer.addSublayer(preView)
        captureSession.startRunning()
        
    }
    
    
    
    let animation = Animation()
    
    let animationDismiss = AnimationDismiss()
    
    
    
    
    
    //When scene opens, it is triggered
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationDismiss
    }
}



extension CameraController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("The Photo you took has been enrolled to the gallery")
        
        
        guard let photoData = photo.fileDataRepresentation() else { return }
        
        let preView = UIImage(data : photoData)
        
        let photoPreview = PhotoPreview()
        
        photoPreview.imgPhotoPreview.image = preView
        
        view.addSubview(photoPreview)
        
        photoPreview.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Photo is taking..."
        hud.show(in: self.view)
        
        hud.dismiss(afterDelay: 1)
    }
}

