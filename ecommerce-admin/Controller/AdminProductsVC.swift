//
//  AdminProductsVC.swift
//  ecommerce-admin
//
//  Created by Avi Aminov on 07/12/2020.
//

import UIKit

class AdminProductsVC: ProductsVC {

    var selectedProduct : Product?
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editCategoryBtn = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        let newProductBtn = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(newProduct))
    
        navigationItem.setRightBarButtonItems([editCategoryBtn, newProductBtn], animated: false)
    }
    

    @objc func editCategory(){
        performSegue(withIdentifier: Sqgues.ToEditCategory, sender: self)
    }
    
    @objc func newProduct(){
        performSegue(withIdentifier: Sqgues.ToAddEditProduct, sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Edit product
        
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Sqgues.ToAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == Sqgues.ToAddEditProduct {
            if let destination = segue.destination as? AddEditProductVC {
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
            }
        }else if segue.identifier == Sqgues.ToEditCategory {
            if let destination = segue.destination as? AddEditCaregoryVC {
                destination.categoryToEdit = category
            }
        }
    }

}
