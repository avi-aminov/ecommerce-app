//
//  RegisterVC.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 23/11/2020.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    // Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passCheck: UIImageView!
    @IBOutlet weak var confirmPassChack: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        /**
        fixed bud on ios 12 +
         */
        if #available(iOS 12.0, *) {
            usernameTxt.textContentType = .oneTimeCode
            emailTxt.textContentType = .oneTimeCode
            passwordTxt.textContentType = .oneTimeCode
            confirmPassTxt.textContentType = .oneTimeCode
        }
        
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        confirmPassTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        passCheck.isHidden = true;
        confirmPassChack.isHidden = true;
        
        if textField == passwordTxt {
            if(passwordTxt.text!.count > 6){
                passCheck.image = UIImage(named: AppImgaes.GreenCheck)
                confirmPassChack.image = UIImage(named: AppImgaes.GreenCheck)
                passCheck.isHidden = false;
            }else {
                passCheck.image = UIImage(named: AppImgaes.RedCheck)
                confirmPassChack.image = UIImage(named: AppImgaes.RedCheck)
                passCheck.isHidden = false;
            }
        }
        
        if textField == confirmPassTxt {
            if passwordTxt.text == confirmPassTxt.text{
                passCheck.image = UIImage(named: AppImgaes.GreenCheck)
                confirmPassChack.image = UIImage(named: AppImgaes.GreenCheck)
                confirmPassChack.isHidden = false;
                passCheck.isHidden = false;
            }else{
                passCheck.image = UIImage(named: AppImgaes.RedCheck)
                confirmPassChack.image = UIImage(named: AppImgaes.RedCheck)
                confirmPassChack.isHidden = false;
            }
        }
    
    }
    
    @IBAction func registrationClicked(_ sender: UIButton) {

        guard let username = usernameTxt.text, username.isNotEmpty else {
            showToast(message: "Username must be entered")
            return
        }
        
        guard let email = emailTxt.text, email.isNotEmpty  else {
            showToast(message: "Email must be entered")
            return
        }
        
        guard let password = passwordTxt.text, password.isNotEmpty,
              let confirmPass = confirmPassTxt.text, confirmPass == password else {
            showToast(message: "Password Toast Message")
            return
        }
        
        
        activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                debugPrint(error)
                return
            }
            
            
            self.activityIndicator.stopAnimating()
            print("registration")
            
            /*
            guard let user = authResult?.user else {
                return
            }
            */
            
        }
        
    }
}
