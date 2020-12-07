//
//  AddEditCaregoryVC.swift
//  ecommerce-admin
//
//  Created by Avi Aminov on 07/12/2020.
//

import UIKit
import  FirebaseStorage


class AddEditCaregoryVC: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImg.isUserInteractionEnabled = true
        categoryImg.addGestureRecognizer(tap)
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
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "Error", msg: "Unable to upload image")
                self.activityIndicator.stopAnimating()
                return
            }
            
            // once the image is uploaded retrieve the download URL
            imageRef.downloadURL(completion: { (url, error) in
                
                if let error = error {
                    debugPrint(error.localizedDescription)
                    self.simpleAlert(title: "Error", msg: "Unable to upload image")
                    self.activityIndicator.stopAnimating()
                    return
                }
                
                guard let url = url else { return }
                
                
                print(url)
                // upload new category document to the firestore categories collection
                
                
            })
            
            
        }
        
    }
    
    func uploadDocument() {
        
        
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
