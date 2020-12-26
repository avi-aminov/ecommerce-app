//
//  purchaseDoneVC.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 24/12/2020.
//

import UIKit

class purchaseDoneVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func okBtnClicked(_ sender: Any) {
        
        Cart.clearCart()
        
        let storyboard = UIStoryboard(name: Storyboard.MainStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryBoardId.HomeVC)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
}
