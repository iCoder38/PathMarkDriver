//
//  cashout.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 06/11/23.
//

import UIKit
import Alamofire

class cashout: UIViewController, UITextFieldDelegate {

    
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
                   view_navigation_title.text = "Cashout"
               } else {
                   view_navigation_title.text = "উত্তোলন"
               }
               
            
           }
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var txt_enter_price:UITextField! {
        didSet {
            txt_enter_price.delegate = self
            txt_enter_price.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_enter_price.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txt_enter_price.layer.shadowOpacity = 1.0
            txt_enter_price.layer.shadowRadius = 15.0
            txt_enter_price.layer.masksToBounds = false
            txt_enter_price.layer.cornerRadius = 14
            txt_enter_price.backgroundColor = .white
            txt_enter_price.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var btn_submit_request:UIButton! {
        didSet {
            btn_submit_request.layer.cornerRadius = 12
            btn_submit_request.clipsToBounds = true
            btn_submit_request.backgroundColor = .systemOrange
            btn_submit_request.setTitle("Submit Request", for: .normal)
            btn_submit_request.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var btn_cashout_history:UIButton! {
        didSet {
            btn_cashout_history.layer.cornerRadius = 12
            btn_cashout_history.clipsToBounds = true
            btn_cashout_history.backgroundColor = navigation_color
            btn_cashout_history.setTitle("Cashout history", for: .normal)
            btn_cashout_history.setTitleColor(.white, for: .normal)
        }
    }
    
    var str_save_wallet_balance:String!
    @IBOutlet weak var lbl_wallet_balance:UILabel! {
        didSet {
            lbl_wallet_balance.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_total_earning_text_one:UILabel!
    @IBOutlet weak var lbl_total_earning_text_two:UILabel!
    @IBOutlet weak var lbl_enter_amount:UILabel!
    @IBOutlet weak var lbl_max_limit:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideBarMenuClick()
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
           print(language as Any)
           
           if (language == "en") {
               lbl_total_earning_text_one.text = "Total Earning"
               lbl_total_earning_text_two.text = "Total Earning"
               lbl_enter_amount.text = "Enter amount to withdraw wallet balance."
               lbl_max_limit.text = "(Max limit : $5,000 per withdrawal)"
               btn_submit_request.setTitle("Submit Request", for: .normal)
               btn_cashout_history.setTitle("Cashout history", for: .normal)
               
           } else {
               lbl_total_earning_text_one.text = "উপার্জন"
               lbl_total_earning_text_two.text = "উপার্জন"
               lbl_enter_amount.text = "ওয়ালেট ব্যালেন্স উত্তোলনের জন্য পরিমাণ লিখুন।"
               lbl_max_limit.text = "(সর্বোচ্চ সীমা: প্রতি তোলার জন্য $5,000)"
               btn_submit_request.setTitle("অনুরোধ জমা দিন", for: .normal)
               btn_cashout_history.setTitle("ক্যাশআউট ইতিহাস", for: .normal)
               
           }
           
        
       }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btn_submit_request.addTarget(self, action: #selector(check_validation_before_submit), for: .touchUpInside)
        self.btn_cashout_history.addTarget(self, action: #selector(cashout_histry_click_method), for: .touchUpInside)
        
        self.get_login_user_full_data()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func cashout_histry_click_method() {
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "cashout_history_id") as! cashout_history
         self.navigationController?.pushViewController(push, animated: true)
    }
    
    @objc func sideBarMenuClick() {
        
        if revealViewController() != nil {
            
            self.btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @objc func get_login_user_full_data() {
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            } else {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
            }
            
            
        }
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            var lan:String!
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lan = "en"
                } else {
                    lan = "bn"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            let params = payload_profile_one(action: "profile",
                                         userId: String(myString),
                                         language: String(lan))
            
            print(params as Any)
            
            AF.request(application_base_url,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                // debugPrint(response.result)
                
                switch response.result {
                case let .success(value):
                    
                    let JSON = value as! NSDictionary
                    print(JSON as Any)
                    
                    var strSuccess : String!
                    strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                    
                    print(strSuccess as Any)
                    if strSuccess == String("success") {
                        print("yes")
                        ERProgressHud.sharedInstance.hide()
                        
                        let get_data = (JSON["data"] as! NSDictionary)
                        
                        self.lbl_wallet_balance.text = String(str_bangladesh_currency_symbol)+"\(get_data["wallet"]!)"
                        self.str_save_wallet_balance = "\(get_data["wallet"]!)"
                        
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
    
    @objc func check_validation_before_submit() {
        // convert string to double
        let double_enter_price = Double(self.txt_enter_price.text!) ?? 0
        let double_wallet_balance = Double(self.str_save_wallet_balance) ?? 0
        
        print(double_enter_price as Any)
        print(double_wallet_balance as Any)
        
        if (self.txt_enter_price.text) == "" {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter some amount"), style: .alert)
                    let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                } else {
                    let alert = NewYorkAlertController(title: String("সতর্কতা").uppercased(), message: String("কিছু পরিমাণ লিখুন"), style: .alert)
                    let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                }
                
                
            }
        } else if (self.txt_enter_price.text) == "0" {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Price must be greater than 1"), style: .alert)
                    let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                } else {
                    let alert = NewYorkAlertController(title: String("সতর্কতা").uppercased(), message: String("মূল্য 1 এর বেশি হতে হবে"), style: .alert)
                    let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                }
                
                
            }
        }  else if (double_enter_price > double_wallet_balance) {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Not enought balance"), style: .alert)
                    let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                } else {
                    let alert = NewYorkAlertController(title: String("সতর্কতা").uppercased(), message: String("পর্যাপ্ত ভারসাম্য নয়"), style: .alert)
                    let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                }
                
                
            }
            
            
            
        } else {
            print("submit")
            self.submit_request_WB(str_show_loader: "yes")
        }
    }
    // submit request
    @objc func submit_request_WB(str_show_loader:String) {
        
        if (str_show_loader == "yes") {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
                }
                
                
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
                
                parameters = [
                    "action"    : "cashoutrequest",
                    "userId"    : String(myString),
                    "requestAmount"    : String(self.txt_enter_price.text!)
                ]
                
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
                            
                            let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            
                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                           
                            self.txt_enter_price.text = ""
                            
                            let alert = NewYorkAlertController(title: String("Success").uppercased(), message: String(message), style: .alert)
                            let cancel = NewYorkButton(title: "Ok", style: .default) {_ in
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "cashout_history_id") as! cashout_history
                                self.navigationController?.pushViewController(push, animated: true)
                            }
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            
                            
                            
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
            
            parameters = [
                "action"    : "login",
                "email"     : (get_login_details["email"] as! String),
                "password"  : (get_login_details["password"] as! String),
            ]
            
            print("parameters-------\(String(describing: parameters))")
            
            AF.request(application_base_url, method: .post, parameters: parameters as? Parameters).responseJSON {
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
                            
                            self.submit_request_WB(str_show_loader: "no")
                            
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
}
