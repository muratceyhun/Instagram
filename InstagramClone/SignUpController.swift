//
//  SignInController.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 7.09.2022.
//

import UIKit
import Firebase
import JGProgressHUD
import FirebaseFirestore

class SignUpController: UIViewController {
  
    
    let btnAddPhoto : UIButton = {
       
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "Choose_Photo").withRenderingMode(.alwaysOriginal), for: .normal)
        
        btn.addTarget(self, action: #selector(btnAddPhotoPressed), for: .touchUpInside)
        return btn
        
    }()
    
    @objc fileprivate func btnAddPhotoPressed() {

        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        
        present(imgPickerController, animated: true, completion: nil)

    }
    let txtEmail : UITextField = {
        
       let txt = UITextField()
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.placeholder = "Email account"
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(changeOfData), for: .editingChanged)
        return txt
    }()
    
    @objc fileprivate func changeOfData() {
        
        let formValidate = (txtEmail.text?.count ?? 0) > 0 &&
        (txtUserName.text?.count ?? 0) > 0 &&
        (txtPassword.text?.count ?? 0) > 0
        
        if formValidate {
            btnRegister.isEnabled = true
            btnRegister.backgroundColor = UIColor.mainBlue()
        } else {
            btnRegister.isEnabled = false
            btnRegister.backgroundColor = UIColor.RGBConverter(red: 150, green: 205, blue: 245)
            
        }
        
    }
    
    
    let txtUserName : UITextField = {
        
       let txt = UITextField()
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.placeholder = "User name"
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(changeOfData), for: .editingChanged)
        return txt
        
        
        
    }()
    
    
    
    let txtPassword : UITextField = {
        
       let txt = UITextField()
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.placeholder = "Password"
        txt.isSecureTextEntry = true
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(changeOfData), for: .editingChanged)
        return txt
        
        
        
    }()
    
    
    let btnRegister : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = UIColor.RGBConverter(red: 150, green: 205, blue: 245)
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(btnRegisterPressed), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    
    @objc fileprivate func btnRegisterPressed() {

        guard let emailAddress = txtEmail.text else {return}
        guard let userName = txtUserName.text else {return}
        guard let password = txtPassword.text else {return}

        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Registerating...."
        hud.show(in: self.view)
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, error) in
            if let error = error {
                print("AN ERROR HAS JUST OCCURED WHEN THE USER TRYING TO REGISTER : ", error)
                hud.dismiss(animated: true)
                return
            }
            
            
            guard let registeredUserID = result?.user.uid else {return}
            let viewName = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/Profile'sPhotos/\(viewName)")
            let viewData = self.btnAddPhoto.imageView?.image?.jpegData(compressionQuality: 0.8) ?? Data()
            
            ref.putData(viewData, metadata: nil) { (_, error) in
            
            
                if let error = error {
                    print("PHOTO IS NOT ABLE TO BE UPLOADED : ",error)
                    return
                }
                
                print("Photo has just been uploaded successfully")
                ref.downloadURL { (url, error) in
                    if let error = error {
                        print("VIEW'S URL CANNOT BE DERIVED : ", error)
                        return
                    }
                    print("UPLOADED PHOTO'S URL ADDRESS : \(url?.absoluteString ?? "NO LINK")")
                    
                    
                    let addedData = ["UserName" : userName,
                                     "UserID" : registeredUserID,
                                     "ProfilePhotoURL" : url?.absoluteString ?? ""]
                    
                    
                    Firestore.firestore().collection("Users").document(registeredUserID).setData(addedData) {
                        (error) in
                        if let error = error {
                            print("USER'S DATA IS NOT ABLE TO BE SAVED : " , error)
                            return
                        }
                        
                        print("USER DATA HAS JUST SAVED SUCCESSFULLY")
                        hud.dismiss(animated: true)
                        self.makeItEasy()
                        let keyWindow = UIApplication.shared.connectedScenes
                            .filter ({ $0.activationState == .foregroundActive})
                            .map ({ $0 as?  UIWindowScene})
                            .compactMap({$0})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first
                    
                        guard let mainTabBarController = keyWindow?.rootViewController as? MainTabBarController else {return}
                        
                        mainTabBarController.goesToUserProfile()
                        self.dismiss(animated: true, completion: nil)
                    }
                   
                }
            }
            print("Registration is completed.",result?.user.uid)
            
        }
    }
    
    fileprivate func makeItEasy() {
        self.btnAddPhoto.setImage(#imageLiteral(resourceName : "Choose_Photo"), for: .normal)
        self.btnAddPhoto.layer.borderColor = UIColor.clear.cgColor
        self.btnAddPhoto.layer.borderWidth = 0
        self.txtEmail.text = ""
        self.txtUserName.text = ""
        self.txtPassword.text = ""
        let successfulHud = JGProgressHUD(style: .light)
        successfulHud.textLabel.text = "Registeration completed."
        successfulHud.show(in: self.view)
        successfulHud.dismiss(afterDelay: 2)
    }

    let btnHaveAccount : UIButton = {
        let btn = UIButton(type: .system)
        let attrTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [.foregroundColor : UIColor.init(white: 0, alpha: 0.4), .font : UIFont.systemFont(ofSize: 15)])
        attrTitle.append(NSAttributedString(string: "Sign In.", attributes: [.foregroundColor : UIColor.RGBConverter(red: 20, green: 155, blue: 235), .font : UIFont.boldSystemFont(ofSize: 15)]))
        btn.setAttributedTitle(attrTitle, for: .normal)
        btn.addTarget(self, action: #selector(btnSignInPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnSignInPressed() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    let lineView : UIView = {
       let view = UIView()
        view.backgroundColor = .init(white: 0, alpha: 0.09)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(btnHaveAccount)
        btnHaveAccount.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(btnAddPhoto)
        view.addSubview(lineView)
        lineView.anchor(top: btnHaveAccount.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
        
        btnAddPhoto.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: nil, paddingTop: 40, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 150, height: 150)
        
        
        btnAddPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        formRegistration()
        
    }
    
    
    fileprivate func formRegistration() {
        
        let stackView = UIStackView(arrangedSubviews: [txtEmail,txtUserName,txtPassword,btnRegister])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
     
        stackView.anchor(top: btnAddPhoto.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 45, paddingRight: -45, width: 0, height: 230)
       
    }


}


extension UIView {
    func anchor(top : NSLayoutYAxisAnchor?,
                bottom : NSLayoutYAxisAnchor?,
                leading : NSLayoutXAxisAnchor?,
                trailing : NSLayoutXAxisAnchor?,
                paddingTop : CGFloat,
                paddingBottom : CGFloat,
                paddingLeft : CGFloat,
                paddingRight : CGFloat,
                width : CGFloat,
                height : CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false



        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeft).isActive = true
        }
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }



    }
}



extension SignUpController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imgChosen = info[.originalImage] as? UIImage
        self.btnAddPhoto.setImage(imgChosen?.withRenderingMode(.alwaysOriginal), for: .normal)
        btnAddPhoto.layer.cornerRadius = btnAddPhoto.frame.width/2
        btnAddPhoto.layer.masksToBounds = true
        btnAddPhoto.layer.borderColor = UIColor.red.cgColor
        btnAddPhoto.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
    }
    
    
    
}




