//
//  ProductDetailVC.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 05/12/2020.
//

import UIKit

class ProductDetailVC: UIViewController {

    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productTitle.text = product.name
        productDescription.text = product.productDescription
        
        if let url = URL(string: product.imageUrl){
            productImg.kf.setImage(with: url)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        if let price = formatter.string(from: product.productPrice as NSNumber) {
            productPrice.text = price
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct(_:)))
        tap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(tap)
    }
    
    @objc func dismissproduct(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCartClicked(_ sender: Any) {
        // add prduct to cart
        Cart.addItemToCart(item: product)
        print(Cart.cartItem)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func dismissProduct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
