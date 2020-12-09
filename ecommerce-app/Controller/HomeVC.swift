//
//  ViewController.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 23/11/2020.
//

import UIKit
import Firebase

class HomeVC: UIViewController {

    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var categories = [Category]()
    var selectedCategory : Category!
    let db = Firestore.firestore()
    var listner: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupInitialAnonymousUser()
        //setupNavigationBar()
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifires.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifires.CategoryCell)
    }
    
    func setupInitialAnonymousUser(){
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint(error)
                }
            }
        }
    }
    
    func setupNavigationBar(){
        guard let font = UIFont(name: "futura", size: 26) else {
            return
        }
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font
        ]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listner.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setCatogoryListener()
        //fetchDocument()
        //fetchCollection()
        
        // change login title to logout if user logged
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginOutBtn.title = "Logout"
            if UserService.userListener == nil {
                UserService.getCurrentUser()
            }
        }else{
            loginOutBtn.title = "Login"
        }
    }
    
    func setCatogoryListener(){
        
        //.whereField("isActive", isEqualTo: true)
        
        listner = db.categories.addSnapshotListener { (snapshot, error) in
             
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snapshot?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let category = Category.init(data: data)
                
                switch change.type {
                    case .added:
                        self.onDocumentAdded(change: change, category: category)
                    case .modified:
                        self.onDocumentModified(change: change, category: category)
                    case .removed:
                        self.onDocumentRemoved(change: change)
                    @unknown default:
                        print("documentChanges default")
                }
            })
        }
    }
    
    fileprivate func presendLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryBoardId.LoginVC)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func favoritesClicked(_ sender: Any) {
        performSegue(withIdentifier: Sqgues.ToFavorites, sender: self)
    }
    
    
    @IBAction func loginOutClicked(_ sender: Any) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        if user.isAnonymous {
            presendLoginController()
        }else {
            do {
                try Auth.auth().signOut()
                UserService.logoutUser()
                Auth.auth().signInAnonymously { (result, error)  in
                    if let error = error {
                        debugPrint(error)
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                    }
                    self.presendLoginController()
                }
            } catch {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
            }
        }
    }
}

extension HomeVC : UICollectionViewDelegate,
                   UICollectionViewDataSource,
                   UICollectionViewDelegateFlowLayout {

    func onDocumentAdded(change: DocumentChange, category: Category){
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    func onDocumentModified(change: DocumentChange, category: Category){
        if change.newIndex == change.oldIndex {
            // item chamged but remained in the same position
            let index = Int(change.newIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }else {
            // item chamged and change position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange){
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: Identifires.CategoryCell, for: indexPath) as? CategoryCell {
            
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let cellWidth = ( width - 60 ) / 2
        let cellHieght = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHieght)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Sqgues.ToProducts, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Sqgues.ToProducts {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
            }
        }else if segue.identifier == Sqgues.ToFavorites {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
                destination.showFavorites = true
            }
        }
    }
}
