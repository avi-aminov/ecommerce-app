//
//  Purchase.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 24/12/2020.
//

import Foundation
import Firebase

struct Purchase {
    var id: String
    var tokenizedPayPalAccount: String
    var userID: String
    var price: String
    var type: String
    var timeStemp: Timestamp
    
    init(
        id: String,
        tokenizedPayPalAccount: String,
        userID: String,
        price: String,
        type: String,
        timeStemp: Timestamp
    ){
        self.id = id
        self.tokenizedPayPalAccount = tokenizedPayPalAccount
        self.userID = userID
        self.price = price
        self.type = type
        self.timeStemp = timeStemp
    }
    
    init(data: [String: Any]){
        id = data["id"] as? String ?? ""
        tokenizedPayPalAccount = data["tokenizedPayPalAccount"] as? String ?? ""
        userID = data["userID"] as? String ?? ""
        price = data["price"] as? String ?? ""
        type = data["type"] as? String ?? ""
        timeStemp = data["timeStemp"] as? Timestamp ?? Timestamp()
    }
    
    static func modelToData(purchase: Purchase) -> [String: Any] {
        let data : [String: Any] = [
            "id" : purchase.id,
            "tokenizedPayPalAccount" : purchase.tokenizedPayPalAccount,
            "userID" : purchase.userID,
            "price" : purchase.price,
            "type" : purchase.type,
            "timeStemp" : purchase.timeStemp
        ]
        return data
    }
}
