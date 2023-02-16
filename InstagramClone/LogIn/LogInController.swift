//
//  LogInController.swift
//  InstagramClone
//
//  Created by Murat Ceyhun Korpeoglu on 11.09.2022.
//

import Foundation

import UIKit
import Firebase
import JGProgressHUD


class LogInController : UIViewController {
    
    let txtEmail : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Phone number, username or email"
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(changeOfData), for: .editingChanged)
        return txt
    }()
    
    
    let txtPassword : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Password"
        txt.isSecureTextEntry = true
        txt.backgroundColor = UIColor(white: 0, alpha: 0.05)
        txt.borderStyle = .roundedRect
        txt.font = UIFont.systemFont(ofSize: 16)
        txt.addTarget(self, action: #selector(changeOfData), for: .editingChanged)

        return txt
    }()
    
    let btnLogIn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Log In", for: .normal)
        btn.backgroundColor = UIColor.RGBConverter(red: 150, green: 205, blue: 245)
        btn.layer.cornerRadius = 6
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(btnLogInPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc fileprivate func btnLogInPressed() {
        
        guard let emailAddress = txtEmail.text , let password = txtPassword.text else {return}
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Loading..."
        hud.show(in: self.view)
        
        
        
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (result, error) in
            
            if let error = error {
                print("AN ERROR HAS JUST OCCURED BC OF LOGGING IN", error)
                hud.dismiss(animated: true)
                let errorHud = JGProgressHUD(style: .light)
                errorHud.textLabel.text = "AN ERROR OCCURED : \(error.localizedDescription)"
                errorHud.show(in: self.view)
                errorHud.dismiss(afterDelay: 2)
                return
            }
            
            print("USER HAS JUST LOGGED IN SUCCESSFULLY", result?.user.uid)
            
            let keyWindow = UIApplication.shared.connectedScenes
                .filter ({ $0.activationState == .foregroundActive})
                .map ({ $0 as?  UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        
            guard let mainTabBarController = keyWindow?.rootViewController as? MainTabBarController else {return}
            
            mainTabBarController.goesToUserProfile()
            self.dismiss(animated: true, completion: nil)
                
            
            
            hud.dismiss(animated: true)
            let successfullHud = JGProgressHUD(style: .light)
            successfullHud.textLabel.text = "SUCCESSFULL"
            successfullHud.show(in: self.view)
            successfullHud.dismiss(afterDelay: 2)
            return
        }
    }
    
    
    let logoView : UIView = {
       let view = UIView()
        let imgLogo = UIImageView(image: #imageLiteral(resourceName: "Logo_Instagram"))
        imgLogo.contentMode = .scaleAspectFill
        view.addSubview(imgLogo)
        imgLogo.anchor(top: nil, bottom: nil, leading: nil, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 50)
        imgLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imgLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.RGBConverter(red: 0, green: 120, blue: 175)
        return view
        
        
    }()
    
    @objc fileprivate func changeOfData() {
        let formValidate = (txtEmail.text?.count ?? 0) > 0 && (txtPassword.text?.count ?? 0) > 0
        
        if formValidate {
            btnLogIn.isEnabled = true
            btnLogIn.backgroundColor = UIColor.RGBConverter(red: 20, green: 155, blue: 235)
        } else {
            btnLogIn.isEnabled = false
            btnLogIn.backgroundColor = UIColor.RGBConverter(red: 150, green: 205, blue: 245)
        }
        
        
    }
    
        let btnSignUp : UIButton = {
        let btn = UIButton(type: .system)
        let attrTitle = NSMutableAttributedString(string: "Don't have an account?", attributes: [.foregroundColor : UIColor.init(white: 0, alpha: 0.4), .font : UIFont.systemFont(ofSize: 15)])
            attrTitle.append(NSAttributedString(string: " Sign Up.", attributes: [.foregroundColor : UIColor.RGBConverter(red: 20, green: 155, blue: 235), .font : UIFont.boldSystemFont(ofSize: 15)]))
            
        btn.setAttributedTitle(attrTitle, for: .normal)
            
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(btnSignUpPressed), for: .touchUpInside)
        btn.tintColor = UIColor.black
        return btn
        
    }()

    
    @objc fileprivate func btnSignUpPressed() {

        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)

    }
    
    
    let lineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.09)
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoView)
        view.addSubview(lineView)
        logoView.anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 150)
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        //view.addSubview(lblLabel)
        view.addSubview(btnSignUp)
        btnSignUp.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        
        lineView.anchor(top: btnSignUp.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)

        formLogInScene()
    }
    
    
    fileprivate func formLogInScene() {
        
        let stackView = UIStackView(arrangedSubviews: [txtEmail,txtPassword,btnLogIn])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        stackView.anchor(top: logoView.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 40, paddingRight: -40, width: 0, height: 185)
        
    }

}
