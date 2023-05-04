//
//  LoginViewController.swift
//  Instagram
//
//  Created by Mina on 26/04/2023.
//
import SafariServices
import UIKit

class LoginViewController: UIViewController {
    
    struct Constatnts {
        static let cornerRadius: CGFloat = 8.0
    }
    
    private let usernameEmailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username or Email..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.layer.cornerRadius = Constatnts.cornerRadius
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "Password..."
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = Constatnts.cornerRadius
        return field
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Service", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("New User? Create an Account", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constatnts.cornerRadius
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
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
        usernameEmailField.delegate = self
        passwordField.delegate = self
        addSubViews()
        view.backgroundColor = .systemBackground
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: 0.0, width: view.width, height: view.hieght/3.0)
        usernameEmailField.frame = CGRect(x: 25, y: headerView.bottom + 40, width: view.width - 50 , height: 52.0)
        passwordField.frame = CGRect(x: 25, y: usernameEmailField.bottom + 10 , width: view.width - 50, height: 52.0)
        loginButton.frame = CGRect(x: 25, y: passwordField.bottom + 10 , width: view.width - 50, height: 52.0)
        createAccountButton.frame = CGRect(x: 25, y: loginButton.bottom + 10 , width: view.width - 50, height: 52.0)
        termsButton.frame = CGRect(x: 10, y: view.hieght-view.safeAreaInsets.bottom-100 , width: view.width - 20, height: 50)
        privacyButton.frame = CGRect(x: 10, y: view.hieght-view.safeAreaInsets.bottom-50 , width: view.width - 20, height: 50)
        
        
        configureHeaderView()
    }
    
    private func configureHeaderView(){
        guard headerView.subviews.count == 1 else {
            return
        }
        guard let backgroundView = headerView.subviews.first  else {
            return
        }
        backgroundView.frame = headerView.bounds
        
        let imageView = UIImageView(image: UIImage(named: "logo"))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: headerView.width/4.0, y: view.safeAreaInsets.top, width: headerView.width/2.0, height: headerView.hieght - view.safeAreaInsets.top)
    }
    
    private func addSubViews(){
        view.addSubview(headerView)
        view.addSubview(loginButton)
        view.addSubview(privacyButton)
        view.addSubview(termsButton)
        view.addSubview(passwordField)
        view.addSubview(usernameEmailField)
        view.addSubview(createAccountButton)
    }
    
    @objc private func didTapLoginButton(){
        passwordField.resignFirstResponder()
        usernameEmailField.resignFirstResponder()
        
        guard let usernameEmail = usernameEmailField.text , !usernameEmail.isEmpty,
              let password = passwordField.text , !password.isEmpty,password.count >= 8 else{
                  return
              }
        var username: String?
        var email: String?
        
        if usernameEmail.contains("@"),usernameEmail.contains("."){
            email = usernameEmail
        }
        else {
            username = usernameEmail
        }
        
        AuthManager.shared.loginUser(username: username , email: email, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true)
                }
                else {
                    let alert = UIAlertController(title: "Log in Error", message: "we were unable to log in.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func didTapTermsButton(){
        
        guard let url = URL(string: "https://help.instagram.com/581066165581870") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapPrivacyButton(){
        guard let url = URL(string: "https://help.instagram.com/155833707900388") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapCreateAccountButton(){
        let vc = RegistrationViewController()
        vc.title = "Creat Account"
        present(UINavigationController(rootViewController: vc), animated: true)
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
