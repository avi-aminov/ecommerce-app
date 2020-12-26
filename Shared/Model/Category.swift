//
//  Category.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 27/11/2020.
//

import Foundation
import Firebase

/**
 Category struct work with firebase
 */
struct Category {
    var name: String
    var id: String
    var imgUrl: String
    var isActive: Bool = true
    var timeStemp: Timestamp

    init(
        name: String,
        id: String,
        imgUrl: String,
        isActive: Bool = true,
        timeStemp: Timestamp
    ){
        self.name = name
        self.id = id
        self.imgUrl = imgUrl
        self.isActive = isActive
        self.timeStemp = timeStemp
    }
    
    init(data: [String: Any]){
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imgUrl = data["imgUrl"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.timeStemp = data["timeStemp"] as? Timestamp ?? Timestamp()
    }
    
    static func modelToData(category: Category) -> [String: Any] {
        let data : [String: Any] = [
            "name" : category.name,
            "id" : category.id,
            "imgUrl" : category.imgUrl,
            "isActive" : category.isActive,
            "timeStemp" : category.timeStemp
        ]
        return data
    }
}
