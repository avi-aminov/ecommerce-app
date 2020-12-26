//
//  AddEditCaregoryVC.swift
//  ecommerce-admin
//
//  Created by Avi Aminov on 07/12/2020.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCaregoryVC: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: UIButton!
        
    var categoryToEdit : Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImg.isUserInteractionEnabled = true
        categoryImg.addGestureRecognizer(tap)
        
        // if we are editing, categoryToEdit will != nil
        if let category = categoryToEdit {
            nameTxt.text = category.name
            addBtn.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: category.imgUrl){
                categoryImg.contentMode = .scaleAspectFill
                categoryImg.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imgTapped(_ tap: UITapGestureRecognizer){
        lanchImgPicker()
    }
    
    @IBAction func addCategoryClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        uploadImageThenDocument()
    
    }
    
    func uploadImageThenDocument(){
        guard let image = categoryImg.image,
              let categoryName = nameTxt.text, categoryName.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Must add category image and name")
            self.activityIndicator.stopAnimating()
            return
        }
        
        // Turn the image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            return
        }
        
        // Create an storage image reference
        let imageRef = Storage.storage().reference().child("/category_images/\(categoryName).jpg")
        
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
        var category = Category.init(
            name: nameTxt.text!,
            id: "",
            imgUrl: url,
            timeStemp: Timestamp()
        )
        
        if let categoryToEdit = categoryToEdit {
            // edit category
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        }else {
            // new cotegory
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }
        
        let data = Category.modelToData(category: category)
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


extension AddEditCaregoryVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func lanchImgPicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
