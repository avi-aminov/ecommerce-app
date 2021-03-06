//
//  ProductsVC.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 29/11/2020.
//

import UIKit
import Firebase

class ProductsVC: UIViewController , ProductCellDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var products = [Product]()
    var category: Category!
    
    let db = Firestore.firestore()
    var listner: ListenerRegistration!
    var showFavorites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifires.ProductCell, bundle: nil), forCellReuseIdentifier: Identifires.ProductCell)

        //setupTableView()
        setupQuery()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if listner != nil {
            listner.remove()
            products.removeAll()
            tableView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Sqgues.ToCheckout {
            if let destination = segue.destination as? CheckoutVC {
                destination.category = category
            }
        }
    }
    
    
    func setupTableView(){
        tableView.backgroundColor = UIColor.clear
    }
    
    func setupQuery(){
       
        var ref: Query!
 
        if showFavorites {
            ref = db.collection("users").document(UserService.user.id).collection("favorites")
        }else{
            ref = db.products(category: category.id)
        }
        
        listner = ref.addSnapshotListener { (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
    
            snapshot?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let product = Product.init(data: data)
                
                switch change.type {
                    case .added:
                        self.onDocumentAdded(change: change, product: product)
                    case .modified:
                        self.onDocumentModified(change: change, product: product)
                    case .removed:
                        self.onDocumentRemoved(change: change)
                    @unknown default:
                        print("documentChanges default")
                }
            })
        }
    }
    
    func productFavorited(product: Product) {
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            UserService.favoriteSelected(product: product)
            guard let index = products.firstIndex(of: product) else {
                return
            }
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }else{
            presendLoginController()
        }
    }
    
    func productAddToCart(product: Product) {
        Cart.addItemToCart(item: product)
    }
    
    // go to login page
    fileprivate func presendLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryBoardId.LoginVC)
        //controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}


extension ProductsVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifires.ProductCell, for: indexPath) as? ProductCell {
            
            cell.configureCell(product: products[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailVC()
        let selectedProduct = products[indexPath.row]
        vc.product = selectedProduct
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func onDocumentAdded(change: DocumentChange, product: Product){
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
    }
    
    func onDocumentModified(change: DocumentChange, product: Product){
        if change.newIndex == change.oldIndex {
            // item chamged but remained in the same position
            let index = Int(change.newIndex)
            products[index] = product
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }else {
            // item chamged and change position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange){
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: .left)
    }
    
}



