//
//  CheckoutVC.swift
//  ecommerce-app
//
//  Created by Avi Aminov on 10/12/2020.
//

import UIKit
//import BraintreeDropIn
import Braintree

import Firebase
import FirebaseStorage
import FirebaseFirestore


class CheckoutVC: UIViewController , CartItemDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var shippingMethodBtn: UIButton!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var processingFeeLbl: UILabel!
    @IBOutlet weak var shippingCostLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var braintreeClient: BTAPIClient!
    
    
    //var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        braintreeClient = BTAPIClient(authorization: "sandbox_q78y2n24_sqy9p4k266b7mgkf")!
        
        setupTableView()
        setupPaymentInfo()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifires.CartItemCell, bundle: nil), forCellReuseIdentifier: Identifires.CartItemCell)
    }
    
    func setupPaymentInfo(){
        subtotalLbl.text = Cart.subtotal.penniesToFormattedCurrency()
        processingFeeLbl.text = Cart.processingFees.penniesToFormattedCurrency()
        shippingCostLbl.text = Cart.shippingFees.penniesToFormattedCurrency()
        totalLbl.text = Cart.total.penniesToFormattedCurrency()
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
    
    @IBAction func placeOrderClicked(_ sender: Any) {
        
        if let user = Auth.auth().currentUser, !user.isAnonymous {

            if Cart.cartItem.count > 0 {
                createPurchase()
            }else{
                self.simpleAlert(title: "Info", msg: "Cart empty")
            }
            
        }else{
            presendLoginController(isFoolScreen: false)
        }
        
    }
    
    // print debug and
    // show error message to user if any stem filed
    func handelError(error: Error, msg: String){
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
    }
    
    func createPurchase(){
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        
        // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalRequest(amount: self.totalLbl.text!.replacingOccurrences(of: "$", with: ""))
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options

        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("----------- Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                /*
                // Access additional information
                let email = tokenizedPayPalAccount.email
                let firstName = tokenizedPayPalAccount.firstName
                let lastName = tokenizedPayPalAccount.lastName
                let phone = tokenizedPayPalAccount.phone

                // See BTPostalAddress.h for details
                let billingAddress = tokenizedPayPalAccount.billingAddress
                let shippingAddress = tokenizedPayPalAccount.shippingAddress
                
                
                print("email \(email)")
                print("firstName \(firstName)")
                print("lastName \(lastName)")
                print("phone \(phone)")
                print("billingAddress \(billingAddress)")
                print("shippingAddress \(shippingAddress)")
                */
                
                var purchase = Purchase.init(
                    id: "",
                    tokenizedPayPalAccount: tokenizedPayPalAccount.nonce,
                    userID: UserService.getUsetID().id,
                    price: self.totalLbl.text!,
                    type: "PayPal",
                    timeStemp: Timestamp()
                )
                
                var docRef: DocumentReference!
                
                docRef = Firestore.firestore().collection("purchases").document()
                purchase.id = docRef.documentID

            
                let data = Purchase.modelToData(purchase: purchase)
                docRef.setData(data, merge: true) { (error) in
                    if let error = error {
                        self.handelError(error: error, msg: "Unable to upload new purchases to Firestore")
                        return
                    }
                    
                    self.purchaseDone()
                }
                
            } else if let error = error {
                // Handle error here...
                print("----------- Handle error here...", error)
            } else {
                // Buyer canceled payment approval
                print("-----------  Buyer canceled payment approval")
            }
        }
    }
    
    func purchaseDone(){
        let vc = purchaseDoneVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func paymentMethodClicked(_ sender: Any) {
        
    }
    
    @IBAction func shippingMethodClicked(_ sender: Any) {
        
    }
    
    func removeItem(product: Product) {
        Cart.removeItemToCart(item: product)
        tableView.reloadData()
        setupPaymentInfo()
    }

}


extension CheckoutVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.cartItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifires.CartItemCell, for: indexPath) as? CartItemCell {
            let product = Cart.cartItem[indexPath.row]
            cell.configureCell(product: product, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


extension CheckoutVC: BTViewControllerPresentingDelegate, BTAppSwitchDelegate{
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        print("----------- a")
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        print("----------- b")
    }
    
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        print("----------- c")
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        print("----------- d")
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        print("----------- e")
    }
}

