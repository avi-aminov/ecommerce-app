//
//  CartItemCell.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 10/12/2020.
//

import UIKit

protocol CartItemDelegate: class {
    func removeItem(product: Product)
}

class CartItemCell: UITableViewCell {

    
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitleLbl: NSLayoutConstraint!
    @IBOutlet weak var removeItemBtn: UIButton!
    
    // TODO: delete
    @IBOutlet weak var productTitleLbl_2: UILabel!
    
    
    // Vars
    private var item: Product!
    weak var delegte: CartItemDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */
    
    func configureCell(product: Product, delegate: CartItemDelegate){
        
        self.delegte = delegate
        self.item = product
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        if let price = formatter.string(from: product.productPrice as NSNumber){
            productTitleLbl_2.text = "\(product.name) \(price)"
        }
        
        if let url = URL(string: product.imageUrl){
            productImg.kf.setImage(with: url)
        }
 
    }
    
    
    @IBAction func removeItemcClicked(_ sender: Any) {
        delegte?.removeItem(product: item)
    }
}
