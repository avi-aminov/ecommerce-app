//
//  UserService.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 09/12/2020.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


let UserService = _UserService()

final class _UserService {
    
    var user = User()
    var favorites = [Product]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener: ListenerRegistration? = nil
    var favsListener: ListenerRegistration? = nil
    
    var isGuset: Bool {
        guard let authUser = auth.currentUser else {
            return true
        }
        if authUser.isAnonymous {
            return true
        }else {
            return false
        }
    }
    
    func getUsetID() -> User {
        return user;
    }
    
    func isLoggdin() -> Bool{
        guard auth.currentUser != nil else {
            return true
        }
        return false
    }
    
    func getCurrentUser() {
        guard let authUser = auth.currentUser else {
            return
        }
        
        let userRef = db.collection("users").document(authUser.uid)
        userListener = userRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else { return }
            self.user = User.init(data: data)
        })
        
        let favsRef = userRef.collection("favorites")
        favsListener = favsRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let favorites = Product.init(data: document.data())
                self.favorites.append(favorites)
            })
        })
    }
    
    func favoriteSelected(product: Product){
        let favsRef = Firestore.firestore().collection("users").document(user.id).collection("favorites")
    
        if favorites.contains(product){
            favorites.removeAll{ $0 == product }
            favsRef.document(product.id).delete()
        }else{
            favorites.append(product)
            let data = Product.modelToData(product: product)
            favsRef.document(product.id).setData(data)
        }
    }
    
    func logoutUser(){
        userListener?.remove()
        userListener = nil
        favsListener?.remove()
        favsListener = nil
        user = User()
        favorites.removeAll()
    }
}
