//
//  ProductCell.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 29/11/2020.
//

import UIKit
import Kingfisher


protocol ProductCellDelegate: class {
    func productFavorited(product: Product)
}

class ProductCell: UITableViewCell {

    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    weak var delegate: ProductCellDelegate?
    private var product: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product: Product, delegate: ProductCellDelegate){
        
        self.product = product
        self.delegate = delegate
        
        productTitle.text = product.name
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        if let price = formatter.string(from: product.productPrice as NSNumber) {
            productPrice.text = price
        }
        
        if let url = URL(string: product.imageUrl){
            let placeholder = UIImage(named: AppImgaes.placeholder)
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            productImg.kf.indicatorType = .activity
            productImg.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
        
        if UserService.favorites.contains(product){
            favoriteBtn.setImage(UIImage(named: AppImgaes.filledStar), for: .normal)
        }else{
            favoriteBtn.setImage(UIImage(named: AppImgaes.emptyStar), for: .normal)
        }
    }

    @IBAction func addToCartClicked(_ sender: Any) {
        
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        delegate?.productFavorited(product: product)
    }
    
}
