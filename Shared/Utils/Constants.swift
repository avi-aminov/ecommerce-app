//
//  Constants.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 24/11/2020.
//

import Foundation
import UIKit

struct Config {
    static let Debugg = true
}

struct Authorization{
    static let sandbox = "sandbox_q78y2n24_sqy9p4k266b7mgkf"
    static let live = ""
}

// Storyboard constans
struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
    static let MainStoryboard = "Main"
}

// Storyboard ids constans
struct StoryBoardId {
    static let LoginVC = "loginVC"
    static let HomeVC = "homeVC"
}

// name of images from assets constans
struct AppImgaes {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
    static let filledStar = "filled_star"
    static let emptyStar = "empty_star"
    static let placeholder = "placeholder"
    
}

// colors constans
struct AppColors {
    static let Blue = #colorLiteral(red: 0.2914361954, green: 0.3395442367, blue: 0.4364506006, alpha: 1)
    static let Red = #colorLiteral(red: 0.8739202619, green: 0.4776076674, blue: 0.385545969, alpha: 1)
    static let OffWhite = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
}


struct Identifires {
    static let CategoryCell = "CategoryCell"
    static let ProductCell = "ProductCell"
    static let CartItemCell = "CartItemCell"
}


struct Sqgues {
    static let ToProducts = "toProductsVC"
    static let ToAddEditCategory = "toAddEditCategory"
    static let ToEditCategory = "toEditCategory"
    static let ToAddEditProduct = "toAddEditProduct"
    static let ToFavorites = "toFavorites"
    static let ToCheckout =  "toCheckout"
}
