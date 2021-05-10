//
//  ViewController.swift
//  DropMessage
//
//  Created by Mostafa Zidan on 5/3/21.
//  Copyright © 2021 Mostafa Zidan. All rights reserved.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {

    //MARK: - IBoutlets
    //labels
    @IBOutlet weak var loginRegisterTitle: UILabel!
    @IBOutlet weak var emailLabelOutlet: UILabel!
    @IBOutlet weak var passwordLabelOutlet: UILabel!
    @IBOutlet weak var repeatPasswordLabelOutlet: UILabel!
    @IBOutlet weak var signupLabelOutlet: UILabel!
    
    //textFields
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    //Buttons
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signupButtonOutlet: UIButton!
    @IBOutlet weak var resendEmailButtonOutlet: UIButton!
    
    //Views
    @IBOutlet weak var repeatPasswordLineView: UIView!
    
    //vars
    var isLogin = true
    
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUIFor(login: true)
        setupTextFieldDelegates()
        setupBackgroundGesture()
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
        if isDataInputedForType(type: isLogin ? "login": "register") {
            print("user insert data!!!")
            isLogin ? loginUser(): registerUser()
        } else {
            ProgressHUD.showError("All fields are required.")
        }
    }
    
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if isDataInputedForType(type: "password") {
            //reset password
            resetPassword()
        } else {
            ProgressHUD.showError("Email is required.")
        }
    }
    
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        if isDataInputedForType(type: "password") {
            //Resend Verification email
            resendVerificationEmail()
        } else {
            ProgressHUD.showError("Email is required")
        }
    }

    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    
    //MARK: - Setup
    private func setupTextFieldDelegates() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updatePlaceholderLabel(textField: textField)
    }
    
    
    private func setupBackgroundGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        view.endEditing(false)
    }
    
    
    //MARK: - Animation
    private func updateUIFor(login: Bool) {
        loginButtonOutlet.layer.cornerRadius = loginButtonOutlet.frame.size.width / 12
        loginButtonOutlet.setTitle(login ? "Login": "Register", for: .normal)
        signupButtonOutlet.setTitle(login ? "SignUp": "Login", for: .normal)
        signupLabelOutlet.text = login ? "Don't have an account?": "Have an account?"
        loginRegisterTitle.text = login ? "Login": "Register"
        
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLabelOutlet.isHidden = login
            self.repeatPasswordLineView.isHidden = login
        }
    }
    private func updatePlaceholderLabel(textField: UITextField) {
        switch textField {
        case emailTextField:
            emailLabelOutlet.text = emailTextField.hasText ? "Email": ""
        case passwordTextField:
            passwordLabelOutlet.text = passwordTextField.hasText ? "Password": ""
        default:
            repeatPasswordLabelOutlet.text = repeatPasswordTextField.hasText ? "Repeat Password": ""
        }
    }
    
    
    //MARK: - Helpers
    private func isDataInputedForType(type: String) -> Bool {
        switch type {
        case "login":
            return emailTextField.text != "" && passwordTextField.text != ""
        case "register":
            return emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
        default:
            return emailTextField.text != ""
        }
    }
    
    
    private func registerUser() {
        if passwordTextField.text! == repeatPasswordTextField.text! {
            FirebaseUserLestiner.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                if error == nil {
                    ProgressHUD.showSuccess("Verification Email Sent!!!")
                    self.resendEmailButtonOutlet.isHidden = false
                } else {
                    ProgressHUD.showError("Error registering user: \(error!.localizedDescription)")
                }
            }
        } else {
            ProgressHUD.showError("Passwords don't match")
        }
    }
    
    private func loginUser() {
        FirebaseUserLestiner.shared.loginUserWithEmail(email: emailTextField!.text!, password: passwordTextField!.text!) { (error, isEmailVerified) in
            if error == nil {
                switch isEmailVerified {
                case true:
                    self.goToApp()
                    ProgressHUD.showSuccess("You Logged in Successfully")
                case false:
                    ProgressHUD.showError("Please verify your email")
                    self.resendEmailButtonOutlet.isHidden = false
                }
            } else {
                ProgressHUD.showError(error!.localizedDescription)
            }
        }
    }
    
    
    //Reset Password
    private func resetPassword() {
        FirebaseUserLestiner.shared.resetPasswordFor(email: emailTextField.text!) { (error) in
            if error == nil {
                ProgressHUD.showSuccess("Reset link was sent to Email Successfully")
            } else {
                ProgressHUD.showError(error?.localizedDescription)
            }
        }
    }
    
    
    //Resend Verification email
    private func resendVerificationEmail() {
        FirebaseUserLestiner.shared.resendVerificationEmail(email: emailTextField.text!) { (error) in
            if error == nil {
                ProgressHUD.showSuccess("Verification email was sent Successfully")
            } else {
                ProgressHUD.showError(error?.localizedDescription)
            }
        }
    }
    //MARK: - Navigation
    func goToApp() {
        
    }
}

