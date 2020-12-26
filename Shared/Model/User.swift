//
//  User.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 09/12/2020.
//

import Foundation

/**
 User struct work with firebase
 */
struct User {
    var id: String
    var email: String
    var username: String
    var stripeId: String
    
    init(
        id: String = "",
        email: String = "",
        username: String = "",
        stripeId: String = ""
    ){
        self.id = id
        self.email = email
        self.username = username
        self.stripeId = stripeId
    }
    
    init(data: [String: Any]){
        id = data["id"] as? String ?? ""
        email = data["email"] as? String ?? ""
        username = data["username"] as? String ?? ""
        stripeId = data["stripeId"] as? String ?? ""
    }
    
    static func modelToData(uset: User) -> [String: Any] {
        let data : [String: Any] = [
            "id" : uset.id,
            "email" : uset.email,
            "username" : uset.username,
            "stripeId" : uset.stripeId
        ]
        return data
    }
}
