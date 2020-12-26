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
        fixed bug on ios 12 +
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
            //showToast(message: "Username must be entered")
            self.simpleAlert(title: "Error", msg: "Plese fill out all fields")
            return
        }
        
        guard let email = emailTxt.text, email.isNotEmpty  else {
            //showToast(message: "Email must be entered")
            self.simpleAlert(title: "Error", msg: "Plese fill out all fields")
            return
        }
        
        guard let password = passwordTxt.text, password.validPass(pass: password)  else {
            //showToast(message: "Email must be entered")
            self.simpleAlert(title: "Error", msg: "Password neeed be minimum 6 character")
            return
        }

        guard let confirmPass = confirmPassTxt.text, confirmPass == password else {
            //showToast(message: "Password Toast Message")
            self.simpleAlert(title: "Error", msg: "Password do not match")
            return
        }
    
        activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                debugPrint(error._code)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            
            guard let firUser = result?.user else { return }
            let artUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
            // Upload to firestore

            self.createFirestoreUser(user: artUser)
        }
        
        
        guard let authUser =  Auth.auth().currentUser else {
            return
        }
       
        /*
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
    
        
        authUser.link(with: credential) { (result, error) in
            if let error = error {
                debugPrint(error._code)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
  
            guard let firUser = result?.user else { return }
            let artUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
            
            // Upload to firestore
            self.createFirestoreUser(user: artUser)
        }
         */
        
        
    }
    
    func createFirestoreUser(user: User){
        // create document reference
        let newUserRef = Firestore.firestore().collection("users").document(user.id)
        
        // create model data
        let data = User.modelToData(uset: user)
        
        // upload to Firestore
        newUserRef.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error.localizedDescription)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
    }
}
