//
//  pay.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 21/11/24.
//

import UIKit
import Alamofire

class pay: UIViewController, UITextFieldDelegate {
    
    var strAmount:String!
    var strUserSelectPaymentType:String! = "0"
    
    var maxAllowedNumber: Double!
    var convertedPrice: Double!
    
    @IBOutlet weak var btn_back:UIButton! {
        didSet {
            btn_back.tintColor = .white
        }
    }
    
    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "Send commission"
                } else {
                    view_navigation_title.text = "কমিশন পাঠান"
                }
                
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            view_navigation_title.textColor = .white
        }
    }
    @IBOutlet weak var lblAmount:UILabel!
    @IBOutlet weak var btnSubmit:UIButton! {
        didSet {
            btnSubmit.backgroundColor = .gray
            btnSubmit.layer.cornerRadius = 8
            btnSubmit.clipsToBounds = true
            btnSubmit.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var viewOne:UIView! {
        didSet {
            viewOne.layer.cornerRadius = 8
            viewOne.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var viewTwo:UIView! {
        didSet {
            viewTwo.layer.cornerRadius = 8
            viewTwo.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblMessage:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lblMessage.text = "Please select the payment option that you would like to pay. Choose your payment method"
                } else {
                    lblMessage.text = "অনুগ্রহ করে যে অর্থপ্রদানের বিকল্পটি আপনি অর্থপ্রদান করতে চান তা নির্বাচন করুন৷ আপনার অর্থপ্রদানের পদ্ধতি চয়ন করুন"
                }
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
        }
    }
    
    @IBOutlet weak var btnCommisionCash:UIButton!
    @IBOutlet weak var btnCommisionBkash:UIButton!
    
    @IBOutlet weak var txtPrice:UITextField! {
        didSet {
            txtPrice.backgroundColor = .white
            txtPrice.textAlignment = .center
            txtPrice.keyboardType = .numberPad
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtPrice.delegate = self
        
        self.lblAmount.text = str_bangladesh_currency_symbol+" "+String(self.strAmount)
        self.lblAmount.isHidden = true
        
        self.txtPrice.text = String(self.strAmount)
        // str_bangladesh_currency_symbol+" "+String(self.strAmount)
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.btnCommisionCash.addTarget(self, action: #selector(commisionCashClickMethod), for: .touchUpInside)
        self.btnCommisionBkash.addTarget(self, action: #selector(bkashClickMethod), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOutClick))
        view.addGestureRecognizer(tap)
      
    
        self.btnSubmit.addTarget(self, action: #selector(paymentWB), for: .touchUpInside)
    }
    
    @objc func dismissKeyboardOutClick() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    @objc func commisionCashClickMethod() {
        self.strUserSelectPaymentType = "1"
        self.btnCommisionCash.setImage(UIImage(named: "check"), for: .normal)
        self.btnCommisionBkash.setImage(UIImage(named: "un_check"), for: .normal)
        
        self.btnSubmit.backgroundColor = .systemGreen
        self.btnSubmit.isUserInteractionEnabled = true
    }
    
    @objc func bkashClickMethod() {
        self.strUserSelectPaymentType = "2"
        self.btnCommisionCash.setImage(UIImage(named: "un_check"), for: .normal)
        self.btnCommisionBkash.setImage(UIImage(named: "check"), for: .normal)
        
        self.btnSubmit.backgroundColor = .systemGreen
        self.btnSubmit.isUserInteractionEnabled = true
    }
    
    
    // payment api
    
    func generateRandomCashCode() -> String {
        let randomNumber = Int.random(in: 100_000_000...999_999_999) // Generate a 9-digit random number
        return "Cash_\(randomNumber)"
    }
    
    @objc func paymentWB() {
        
        let stringNumber = self.strAmount
        if let doubleValue = Double(stringNumber!) {
            // print("The double value is: \(doubleValue)")
            self.maxAllowedNumber = doubleValue
        } else {
            // print("Invalid number format")
        }
        
        // entered amount
        if let doubleValueE = Double(self.txtPrice.text!) {
            // print("The double value is: \(doubleValueE)")
            self.convertedPrice = doubleValueE
        } else {
            // print("Invalid number format")
        }
        // print("Converted value: \(self.txtPrice.text!)")
        if let text = self.txtPrice.text, let doubleValue = Double(text) {
            print("Converted value: \(doubleValue)")
        } else {
            print("Invalid input. Cannot convert to Double.")
        }
        
        // print(self.maxAllowedNumber as Any)
        // print(self.convertedPrice as Any)
        
        
        if (self.maxAllowedNumber == nil) {
            return
        }
        if (self.convertedPrice == nil) {
            return
        }
        
        if (self.maxAllowedNumber < self.convertedPrice) {
            
            let alert = UIAlertController(title: "Invalid Input", message: "Amount should be less than \(str_bangladesh_currency_symbol)\(String(self.strAmount))", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
            
            return
        }
       
        if (self.strUserSelectPaymentType == "2") {
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bKash_payment_gateway_id") as! bKash_payment_gateway
            
            push.doublePayment = String(self.txtPrice.text!)
            
            self.navigationController?.pushViewController(push, animated: true)
            
            return
        }
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            } else {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "অপেক্ষা করুন")
            }
        }
        
        
        self.view.endEditing(true)
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                var lan:String!
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        lan = "en"
                    } else {
                        lan = "bn"
                    }
                }
                
                
                /*
                 [action] => updateadminpayment
                 [userId] => 320
                 [amount] => 2.17
                 [PaymentMethod] => Cash
                 [transactionId] => Cash_1732179592477
                 [language] => en
                 */
                
                if (self.strUserSelectPaymentType == "1") {
                    parameters = [
                        "action"        : "updateadminpayment",
                        "userId"        : String(myString),
                        "amount"        : String(self.txtPrice.text!) ,
                        "PaymentMethod" : String("Cash"),
                        "transactionId" : generateRandomCashCode(),
                        "language"      : String(lan),
                        
                    ]
                } else {
                    parameters = [
                        "action"    : "updateadminpayment",
                        "userId"    : String(myString),
                        "userId"    : String(myString),
                        "userId"    : String(myString),
                        "userId"    : String(""),
                        "language"  : String(lan),
                        
                    ]
                }
                
                
                print(parameters as Any)
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON {
                    response in
                    // debugPrint(response.result)
                    
                    switch response.result {
                    case let .success(value):
                        
                        let JSON = value as! NSDictionary
                        print(JSON as Any)
                        
                        var strSuccess : String!
                        strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                        
                        var message : String!
                        message = (JSON["msg"] as? String)
                        
                        print(strSuccess as Any)
                        if strSuccess == String("success") {
                            print("yes")
                            
                            /*let str_token = (JSON["AuthToken"] as! String)
                             UserDefaults.standard.set("", forKey: str_save_last_api_token)
                             UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)*/
                            
                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb()
                            
                        } else {
                            
                            print("no")
                            ERProgressHud.sharedInstance.hide()
                            
                            var strSuccess2 : String!
                            strSuccess2 = JSON["msg"]as Any as? String
                            
                            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(strSuccess2), style: .alert)
                            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            
                        }
                        
                    case let .failure(error):
                        print(error)
                        ERProgressHud.sharedInstance.hide()
                        
                        self.please_check_your_internet_connection()
                        
                    }
                }
            }
        }
    }
    
    @objc func login_refresh_token_wb() {
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let get_login_details = UserDefaults.standard.value(forKey: str_save_email_password) as? [String:Any] {
            print(get_login_details as Any)
            
            if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                
                let x : Int = person["userId"] as! Int
                let myString = String(x)
                
                parameters = [
                    "action"    : "gettoken",
                    "userId"    : String(myString),
                    "email"     : (get_login_details["email"] as! String),
                    "role"      : (person["role"] as! String)
                ]
            }
            
            print("parameters-------\(String(describing: parameters))")
            
            AF.request(application_base_url, method: .post, parameters: parameters as? Parameters).responseJSON { [self]
                response in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.value {
                        
                        let JSON = data as! NSDictionary
                        print(JSON)
                        
                        var strSuccess : String!
                        strSuccess = JSON["status"] as? String
                        
                        if strSuccess.lowercased() == "success" {
                            
                            let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            
                            self.paymentWB()
                            
                        } else {
                            ERProgressHud.sharedInstance.hide()
                        }
                        
                    }
                    
                case .failure(_):
                    print("Error message:\(String(describing: response.error))")
                    ERProgressHud.sharedInstance.hide()
                    self.please_check_your_internet_connection()
                    
                    break
                }
            }
        }
        
    }
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            // Get the updated text after the new input
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // Check if the updated text can be converted to a Double
            if let enteredNumber = Double(updatedText) {
                if enteredNumber > self.maxAllowedNumber {
                    showAlert(message: "The number cannot exceed \(maxAllowedNumber!).")
                    return false // Prevent further input
                }
            } else if !updatedText.isEmpty {
                // Handle invalid input (non-numeric characters)
                // showAlert(message: "Please enter a valid number.")
                return false
            }

            return true // Allow valid input
        }
    
    // Function to show an alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }*/
    
}
