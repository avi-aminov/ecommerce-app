//
//  LoginVC.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 23/11/2020.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    //IBOutlet
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
        fixed bud on ios 12 +
         */
        if #available(iOS 12.0, *) {
            emailTxt.textContentType = .oneTimeCode
            passwordTxt.textContentType = .oneTimeCode
        }
        
    }
    
    // forgot password
    @IBAction func forgotPassClicked(_ sender: UIButton) {
        let vc = forgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    // login
    @IBAction func loginClicked(_ sender: UIButton) {
        
        // return if email empty
        guard let email = emailTxt.text, email.isNotEmpty else {
            //showToast(message: "email must be entered")
            self.simpleAlert(title: "Error", msg: "Plese fill out all fields")
            return
        }
        
        // return if password empty
        guard let password = passwordTxt.text, password.isNotEmpty else {
            //showToast(message: "password must be entered")
            self.simpleAlert(title: "Error", msg: "Plese fill out all fields")
            return
        }
        
        // show loader indicator on screen
        activityIndicator.startAnimating()
        
        //login with email and pass by by firebase
        Auth.auth().signIn(withEmail: email, password: password) { ( user, error ) in
            
            // return if have error
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                
                // hide loader indicator from screen
                self.activityIndicator.stopAnimating()
                return
            }
            
            UserService.getCurrentUser()
            
            // show loader indicator on screen
            self.activityIndicator.startAnimating()
            
            // dismiss all view cntrollers in main storyboard
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // continue with guest user
    @IBAction func guestClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        //presendHomeController()
    }
    
    // go to home page
    fileprivate func presendHomeController() {
        let storyboard = UIStoryboard(name: Storyboard.MainStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryBoardId.HomeVC)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
}
