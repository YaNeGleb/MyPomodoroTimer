//
//  ForgotPasswordViewController.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 14.04.2023.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    private let headerView = AuthHeaderView(title: "Reset password", subTitle: "Enter Your email address")
    private let emailField = CustomTextField(fieldType: .email)
    private let resetPasswordButton = CustomButton(title: "Reset password", hasBackground: true, fontSize: .big)
    private let backToSignInButton = CustomButton(title: "Back to Sign In.", fontSize: .med)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()

        self.resetPasswordButton.addTarget(self, action: #selector(didTapResetButton), for: .touchUpInside)
        self.backToSignInButton.addTarget(self, action: #selector(didTapBackToSignIn), for: .touchUpInside)
    }
    

    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(headerView)
        self.view.addSubview(emailField)
        self.view.addSubview(resetPasswordButton)
        self.view.addSubview(backToSignInButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        backToSignInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
            self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.resetPasswordButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            self.resetPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.resetPasswordButton.heightAnchor.constraint(equalToConstant: 55),
            self.resetPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.backToSignInButton.topAnchor.constraint(equalTo: resetPasswordButton.bottomAnchor, constant: 6),
            self.backToSignInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.backToSignInButton.heightAnchor.constraint(equalToConstant: 44),
            self.backToSignInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
        ])
    }
    
    @objc private func didTapResetButton() {
        let email = emailField.text ?? ""
        // Email check
        if !Validator.isValidEmail(for: email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        } else {
            Auth.auth().sendPasswordReset(withEmail: email)
            AlertManager.showResetPasswordAlert(on: self)
        }
    }
    
    @objc private func didTapBackToSignIn() {
        NavigationManager.navigateToLogin()
    }

}
