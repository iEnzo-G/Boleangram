//
//  LoginViewController.swift
//  Boleangram
//
//  Created by Enzo Gammino on 11/01/2022.
//

import SafariServices
import UIKit

class LoginViewController: UIViewController {

    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    private let usernameEmailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Pseudonyme / Email"
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "Mot de passe"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field

    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Se connecter", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    private let termsButton: UIButton = {
        let button = UIButton ()
        button.setTitle("Conditions d'utilisations", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton ()
        button.setTitle("Politique de confidentialit??", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Cr??er un compte", for: .normal)
        return button
    }()

    private let headerView: UIView = {
        let header = UIView()
        header.clipsToBounds = true
        let backgroundImageView = UIImageView(image: UIImage(named: "gradient"))
        header.addSubview(backgroundImageView)
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addTarget(self,
                              action: #selector(didTapLoginButton),
                              for: .touchUpInside)
        
        createAccountButton.addTarget(self,
                                      action: #selector(didTapCreateAccountButton),
                                      for: .touchUpInside)
        
        termsButton.addTarget(self,
                              action: #selector(didTapTermsButton),
                              for: .touchUpInside)
        
        privacyButton.addTarget(self,
                                action: #selector(didTapPrivacyButton),
                                for: .touchUpInside)
        
        usernameEmailField.delegate = self
        passwordField.delegate = self
                                
        addSubviews()
                                
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
//    Assign frames
        
        headerView.frame = CGRect(
            x: 0,
            y: 0.0,
            width: view.width,
            height: view.height/3.0
        )
        
        usernameEmailField.frame = CGRect(
            x: 25,
            y: headerView.bottom + 50,
            width: view.width - 50,
            height: 52.0
        )
        
        passwordField.frame = CGRect(
            x: 25,
            y: usernameEmailField.bottom + 10,
            width: view.width - 50,
            height: 52.0
        )
        
        loginButton.frame = CGRect(
            x: 25,
            y: passwordField.bottom + 20,
            width: view.width - 50,
            height: 52.0
        )
        
        createAccountButton.frame = CGRect(
            x: 25,
            y: loginButton.bottom,
            width: view.width - 50,
            height: 52.0
        )
        
        termsButton.frame = CGRect(
            x: 10,
            y: view.height - additionalSafeAreaInsets.bottom - 120,
            width: view.width - 20,
            height: 50.0
        )
        privacyButton.frame = CGRect(
            x: 10,
            y: view.height - additionalSafeAreaInsets.bottom - 80,
            width: view.width - 20,
            height: 50.0
        )
       
       
        
        configureHeaderView()
        
            }
    
    private func configureHeaderView() {
        guard headerView.subviews.count == 1 else {
            return
        }
        
        guard let backgroundView = headerView.subviews.first else{
            return
    }
        backgroundView.frame = headerView.bounds
        
//        Add logo text
        let imageView = UIImageView(image: UIImage(named:"text"))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(
            x: headerView.width/5.5,
            y: view.safeAreaInsets.top,
            width: headerView.width/1.5,
            height: headerView.height - view.safeAreaInsets.top
        )

}
    private func addSubviews(){
        view.addSubview(usernameEmailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(privacyButton)
        view.addSubview(termsButton)
        view.addSubview(headerView)
        view.addSubview(createAccountButton)

}
    @objc private func didTapLoginButton () {
        usernameEmailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let usernameEmail = usernameEmailField.text, !usernameEmail.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8 else {
                  return
              }
            
        var username: String?
        var email: String?
        
        if usernameEmail.contains("@"), usernameEmail.contains("."){
//            User use his email to log in
            email = usernameEmail
        }
            else {
//                User use his username to log in
                username = usernameEmail
            }
        
        AuthManager.shared.longinUser(username: username, email: email, password: password) { succes in
            DispatchQueue.main.async {
                if succes {
    //                user logged in
                    self.dismiss(animated: true, completion:  nil)
                }
                else {
    //                error occured
                    let alert = UIAlertController(title: "Impossible de se connecter",
                                                  message:"Veuillez v??rifier vos identifiants de connexion",
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Fermer",
                                                  style: .cancel,
                                                  handler: nil))
                    self.present(alert, animated: true)
            }

                
            }
        }
        
    }
    
    @objc private func didTapTermsButton () {
        guard let url = URL(string: "https://help.instagram.com/581066165581870") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapPrivacyButton () {
        guard let url = URL(string: "https://help.instagram.com/519522125107875") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapCreateAccountButton () {
        let vc = RegistrationViewController()
        vc.title = "Nouveau compte"
        present (UINavigationController(rootViewController: vc), animated: true)
                 
                 }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            didTapLoginButton() 
        }
        return true
    }
}
