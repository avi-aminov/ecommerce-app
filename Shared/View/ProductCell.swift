//
//  ProductCell.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 29/11/2020.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {

    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product: Product){
        productTitle.text = product.name
        //productPrice.text = "$\(String(product.productPrice))"
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        if let price = formatter.string(from: product.productPrice as NSNumber) {
            productPrice.text = price
        }
        
        
        if let url = URL(string: product.imageUrl){
            let placeholder = UIImage(named: "placeholder")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            productImg.kf.indicatorType = .activity
            productImg.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
        
        
    }

    @IBAction func addToCartClicked(_ sender: Any) {
        
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        
    }
    
}
