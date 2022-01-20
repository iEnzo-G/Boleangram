//
//  RegistrationViewController.swift
//  Boleangram
//
//  Created by Enzo Gammino on 11/01/2022.
//
import SafariServices
import UIKit

class RegistrationViewController: UIViewController {

    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    private let usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Pseudonyme"
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field .leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Adresse email"
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
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Créer un nouveau compte", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemGreen
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
        button.setTitle("Politique de confidentialité", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.addTarget(self,
                                 action: #selector(didTapRegister),
                                 for: .touchUpInside)
        usernameField.delegate = self
        passwordField.delegate = self
        emailField.delegate = self
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        view.addSubview(privacyButton)
        view.addSubview(termsButton)
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        termsButton.addTarget(self,
                              action: #selector(didTapTermsButton),
                              for: .touchUpInside)
        
        privacyButton.addTarget(self,
                                action: #selector(didTapPrivacyButton),
                                for: .touchUpInside)
        
        
        usernameField.frame = CGRect(x: 20,
                                     y: view.safeAreaInsets.top + 100,
                                     width: view.width - 40,
                                     height: 52)
        
        emailField.frame = CGRect(x: 20,
                                  y: usernameField.bottom + 10,
                                  width: view.width - 40,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 20,
                                     y: emailField.bottom + 10,
                                     width: view.width - 40,
                                     height: 52)
        
        registerButton.frame = CGRect(x: 20,
                                      y: passwordField.bottom + 40,
                                      width: view.width - 40,
                                      height: 52)
        
//        Terms and Privacy button
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
       
       
    }
    
    @objc private func didTapRegister() {
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8,
              let username = usernameField.text, !username.isEmpty else {
                  return
              }
        
        AuthManager.shared.registerNewUser(username: username, email: email, password: password) { registered in
            DispatchQueue.main.async {
                if registered {
    //                Succeed
                }
                else {
    //                Failed
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

}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else {
            didTapRegister()
        }
        return true
    }
}
