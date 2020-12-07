//
//  Category.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 27/11/2020.
//

import Foundation
import Firebase

struct Category {
    var name: String
    var id: String
    var imgUrl: String
    var isActive: Bool = true
    var timeStemp: Timestamp

    init(data: [String: Any]){
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imgUrl = data["imgUrl"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.timeStemp = data["timeStemp"] as? Timestamp ?? Timestamp()
    }
}
