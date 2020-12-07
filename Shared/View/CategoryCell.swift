//
//  CategoryCell.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 29/11/2020.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {

    
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryImg.layer.cornerRadius = 5
    }
    
    func configureCell(category: Category){
        categoryLabel.text = category.name
        if let url = URL(string: category.imgUrl){
            let placeholder = UIImage(named: "placeholder")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            categoryImg.kf.indicatorType = .activity
            categoryImg.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
    }

}
