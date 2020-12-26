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
        setLoginBtnText()
        //setupInitialAnonymousUser()
        //setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listner.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setCatogoryListener()
        setLoginBtnText()
    }
    
    // config collection view
    // set delegate on self
    // register caegory cell .xib
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifires.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifires.CategoryCell)
    }
    
    /*
    func setupInitialAnonymousUser(){
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    debugPrint(error)
                }
            }
        }else {
            UserService.getCurrentUser()
        }
    }
    */
    
    func setupNavigationBar(){
        guard let font = UIFont(name: "futura", size: 26) else {
            return
        }
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font
        ]
    }
    
    func  setLoginBtnText(){
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
    
    // go to login page
    fileprivate func presendLoginController(isFoolScreen: Bool) {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryBoardId.LoginVC)
        if isFoolScreen {
            controller.modalPresentationStyle = .fullScreen
        }
        present(controller, animated: true, completion: nil)
    }
    
    // if user login show favorite prouct
    // else go to login page
    @IBAction func favoritesClicked(_ sender: Any) {
        
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            performSegue(withIdentifier: Sqgues.ToFavorites, sender: self)
        }else{
            presendLoginController(isFoolScreen: false)
        }
        
    }
    
    // login or logOut btn clicked
    @IBAction func loginOutClicked(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                UserService.logoutUser()
                self.presendLoginController(isFoolScreen: true)
            } catch {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
            }
        }else {
            self.presendLoginController(isFoolScreen: true)
        }
        
        /*
        if user.isAnonymous {
            presendLoginController(isFoolScreen: true)
        }else {
            do {
                try Auth.auth().signOut()
                UserService.logoutUser()
                Auth.auth().signInAnonymously { (result, error)  in
                    if let error = error {
                        debugPrint(error)
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                    }
                    self.presendLoginController(isFoolScreen: true)
                }
            } catch {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
            }
        }
        */
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
        let cellWidth = ( width - 70 ) / 2
        let cellHieght = cellWidth * 2
        
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
