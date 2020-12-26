//
//  AddEditProductVC.swift
//  ecommerce-admin
//
//  Created by Avi Aminov on 07/12/2020.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductVC: UIViewController {

    // Outlet
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var productDescriptionTxt: UITextView!
    @IBOutlet weak var productImgView: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: RoundedButton!
    
    
    // vars
    var selectedCategory : Category!
    var productToEdit : Product!
    
    var name = ""
    var price = 0.0
    var productDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        productImgView.isUserInteractionEnabled = true
        productImgView.addGestureRecognizer(tap)
        
        if let product = productToEdit {
            productNameTxt.text = product.name
            productDescriptionTxt.text = product.productDescription
            productPriceTxt.text = String(product.productPrice)
            addBtn.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: product.imageUrl){
                productImgView.contentMode = .scaleAspectFill
                productImgView.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imgTapped(_ tap: UITapGestureRecognizer){
        lanchImgPicker()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument(){
        guard let image = productImgView.image,
              let name = productNameTxt.text, name.isNotEmpty,
              let description = productDescriptionTxt.text, description.isNotEmpty,
              let priceString = productPriceTxt.text,
              let price = Double(priceString)  else {
            simpleAlert(title: "Error", msg: "Please fill out all reqired fields.")
            self.activityIndicator.stopAnimating()
            return
        }
        
        self.name = name
        self.price = price
        self.productDescription = description
        
        
        // Turn the image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            return
        }
        
        // Create an storage image reference
        let imageRef = Storage.storage().reference().child("/product_images/\(name).jpg")
        
        //set the meta date
        let metaDate = StorageMetadata()
        metaDate.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metaDate) { (metaDate, error) in
            
            if let error = error {
                self.handelError(error: error, msg: "Unable to upload image")
                return
            }
            
            // once the image is uploaded retrieve the download URL
            imageRef.downloadURL(completion: { (url, error) in
                
                if let error = error {
                    self.handelError(error: error, msg: "Unable to retrieve image url")
                    return
                }
                
                guard let url = url else { return }
                
                // upload new category document to the firestore categories collection
                self.uploadDocument(url: url.absoluteString)
                
            })
        }
    }
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        
        var product = Product.init(
            name: name,
            productPrice: price,
            id: "",
            category: selectedCategory.id,
            productDescription: productDescription,
            imageUrl: url,
            timeStemp: Timestamp(),
            stock: 1
        )
        
        if let productToEdit = productToEdit {
            // edit category
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        }else {
            // new cotegory
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        
        let data = Product.modelToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handelError(error: error, msg: "Unable to upload new category to Firestore")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // print debug and
    // show error message to user if any stem filed
    func handelError(error: Error, msg: String){
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
    }
}

extension AddEditProductVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func lanchImgPicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        productImgView.contentMode = .scaleAspectFill
        productImgView.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
