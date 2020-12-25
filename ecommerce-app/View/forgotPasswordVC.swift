//
//  forgotPasswordVC.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 26/11/2020.
//

import UIKit
import Firebase

class forgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        
        guard let email = emailTxt.text, email.isNotEmpty else {
            self.simpleAlert(title: "Error", msg: "Plese enter email.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
