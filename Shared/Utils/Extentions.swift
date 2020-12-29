//
//  Extentions.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 23/11/2020.
//

import Foundation
import UIKit
import Firebase

// Firestore extension for querys
// categories and products Query
extension Firestore {
    var categories: Query {
        return collection("categories").order(by: "timeStemp", descending: true)
    }
    
    func products(category: String) -> Query {
        return collection("products").whereField("category", isEqualTo: category).order(by: "timeStemp", descending: true)
    }
    
    var carousel: Query {
        return collection("carousel")
    }
}

// convetr pennies to formatted currency
extension Int {
    func penniesToFormattedCurrency() -> String {
        let dollars = Double(self) / 100
        let formetter = NumberFormatter()
        formetter.numberStyle = .currency
        formetter.currencySymbol = "$"
        if let dollarString = formetter.string(from: dollars as NSNumber){
            return dollarString
        }
        return "$0.00"
    }
}


// String helper
extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func validPass(pass: String) ->Bool {
        return !isEmpty && pass.count > 5
    }
}


// show Toast message
extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 190, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = .systemFont(ofSize: 13.0)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.3, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}


//error message popup
extension UIViewController {
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
