//
//  Cart.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 14/12/2020.
//

import Foundation

let Cart = _Cart()

final class _Cart {
    var cartItem = [Product]()
    private let stripeCreditCardCut = 0.029
    private let flatFreeCents = 30
    var shippingFees = 0
    
    var subtotal: Int {
        var amount = 0
        for item in cartItem {
            let pricePennies = Int(item.productPrice * 100)
            amount += pricePennies
        }
        return amount
    }
    
    var processingFees: Int {
        if subtotal == 0 {
            return 0
        }
        
        let sub = Double(subtotal)
        let feesAndSub = Int(sub * stripeCreditCardCut) + flatFreeCents
        return feesAndSub
    }
    
    var total: Int {
        return subtotal + processingFees + shippingFees
    }
    
    func addItemToCart(item: Product){
        cartItem.append(item)
    }
    
    func removeItemToCart(item: Product){
        if let index = cartItem.firstIndex(of: item){
            cartItem.remove(at: index)
        }
    }
    
    func clearCart(){
        cartItem.removeAll()
    }
}
