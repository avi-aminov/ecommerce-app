//
//  Product.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 29/11/2020.
//

import Foundation
import Firebase

struct Product {
    var name: String
    var productPrice: Double
    var id: String
    var category: String
    var productDescription: String
    var imageUrl: String
    var timeStemp: Timestamp
    var stock: Int
    var isActive: Bool = true

    init(data: [String: Any]){
        self.name = data["name"] as? String ?? ""
        self.productPrice = data["productPrice"] as? Double ?? 0.0
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.timeStemp = data["timeStemp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
        self.isActive = data["isActive"] as? Bool ?? true
    }
}


