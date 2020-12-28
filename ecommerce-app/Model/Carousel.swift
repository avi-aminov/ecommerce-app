//
//  Carousel.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 27/12/2020.
//

import Foundation

struct Carousel {

    var id: String
    var name: String
    var img: String
    var action: Int
    
    init(
        id: String,
        name: String,
        img: String,
        action: Int
    ){
        self.id = id
        self.name = name
        self.img = img
        self.action = action
    }
    
    init(data: [String: Any]){
        id = data["id"] as? String ?? ""
        name = data["name"] as? String ?? ""
        img = data["img"] as? String ?? ""
        action = data["action"] as? Int ?? 0
    }
}
