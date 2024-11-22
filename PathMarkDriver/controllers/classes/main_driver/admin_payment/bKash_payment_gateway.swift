//
//  bKash_payment_gateway.swift
//  PathMark
//
//  Created by Dishant Rajput on 30/04/24.
//

import UIKit
import Foundation
import Alamofire
import WebKit

class bKash_payment_gateway: UIViewController, WKNavigationDelegate,WKUIDelegate {
    
    var doublePayment:String!

    var strLoadWebView:String! = "0"
    var strAccessToken:String!
    var strPaymentId:String!
    
    var str_booking_id:String!
    
    var dict_full:NSDictionary!
    var trxId:String!
    
    var getDiscountAmount:String!
    var getCouponCode:String!
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.isHidden = true
        }
    }

    @IBOutlet weak var view_please_wait:UIView! {
        didSet {
            view_please_wait.isHidden = false
        }
    }
    @IBOutlet weak var view_success_or_error:UIView! {
        didSet {
            view_success_or_error.isHidden = true
        }
    }
    @IBOutlet weak var lbl_message:UILabel! {
        didSet {
            lbl_message.isHidden = true
        }
    }
    
    @IBOutlet weak var btn_home:UIButton! {
        didSet {
            btn_home.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        self.navigationController?.isNavigationBarHidden = true
        // self.btn_pay.addTarget(self, action: #selector(bKash_payment), for: .touchUpInside)
        
        self.bKash_payment()
    }
    
    @objc func bKash_payment() {
        self.getAccessToken2020()
    }
   
    func getAccessToken2020() {
        
        let tokenURLString = bkash_generate_token
        
        let parameters: [String: Any] = [
            "app_key": bkash_app_key,
            "app_secret": bkash_app_secret_key,
        ]
        
        guard let url = URL(string: tokenURLString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(bkash_user_name, forHTTPHeaderField: "username")
        request.setValue(bkash_password, forHTTPHeaderField: "password")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic " + "\(bkash_app_key):\(bkash_app_secret_key)".data(using: .utf8)!.base64EncodedString(), forHTTPHeaderField: "Authorization")
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = requestData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    // Parse response JSON to extract access token
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        // print(json)
                        // id_token
                        if let accessToken = json!["id_token"] as? String {
                            print("Access Token: \(accessToken)")
                            self.strAccessToken = "\(accessToken)"
                            
                            self.create_payment_after_token(token: "\(accessToken)")
                            
                        } else {
                            print("Access token not found in response")
                        }
                    } catch {
                        print("Error parsing JSON response: \(error.localizedDescription)")
                    }
                } else if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }.resume()
        } catch {
            print("Error serializing request data: \(error.localizedDescription)")
        }
    }
    
    func generateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
    
    func create_payment_after_token(token:String) {
        
        // Define your API endpoint for creating a payment
        let paymentURL = URL(string: bkash_create_payment)!
        
        // Create payment request
        var paymentRequest = URLRequest(url: paymentURL)
        paymentRequest.httpMethod = "POST"
        
        // Set headers
        paymentRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        paymentRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        paymentRequest.setValue(bkash_app_key, forHTTPHeaderField: "x-app-key")
        
        // Set your payment details
        let paymentDetails: [String: Any] = [
            "amount": "\(doublePayment!)", // Amount in your currency
            "currency": "BDT", // Currency code
            "intent": "sale", // Payment intent
            "callbackURL":bkash_call_back_URL,
            "mode":"0011",
            "merchantInvoiceNumber":"invoice_\(generateRandomDigits(10))",
            "payerReference":"ref_\(generateRandomDigits(6))"
            // Other payment details as required by bKash API
        ]
        
        // Convert payment details to Data
        guard let paymentData = try? JSONSerialization.data(withJSONObject: paymentDetails) else {
            print("Error creating payment data")
            return
        }
        
        // Attach payment data to the request
        paymentRequest.httpBody = paymentData
        
        // Create a URLSessionDataTask to send the payment request
        let paymentTask = URLSession.shared.dataTask(with: paymentRequest) { [self] (data, response, error) in
            // Handle response
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if httpResponse.statusCode == 200 {
                // Parse and handle successful response
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Payment Response JSON: \(json)")
                        print(type(of: json))
                        // Process your payment response here
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = json as! Dictionary<AnyHashable, Any>
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            if (dict["paymentID"]) != nil {
                                self.strPaymentId = (dict["paymentID"] as? String)
                                self.webView.isHidden = false
                                let myURLString = (dict["bkashURL"] as! String)
                                // print(myURLString as Any)
                                
                                let url = URL(string: myURLString)
                                let request = URLRequest(url: url!)
                                self.webView.navigationDelegate = self
                                self.webView.load(request)
                            }
                            
                        }
                        
                        // self.executeBKashPayment(token:token,payment_id: dict["paymentID"] as! String)
                        
                    } catch {
                        print("Error parsing payment response: \(error)")
                    }
                } else {
                    print("Empty payment response data")
                }
            } else {
                print("HTTP status code: \(httpResponse.statusCode)")
                // Handle other status codes
            }
        }
        
        // Execute the payment task
        paymentTask.resume()
    }
    
    // MARK: - WKNavigationDelegate Methods

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Called when the webpage finishes loading
        print("Webpage loaded successfully.")
        
        if (self.strLoadWebView == "0") {
            self.strLoadWebView = "1"
            print("me called ?")
        } else {
            self.webView.isHidden = true
            print(self.strAccessToken as Any)
            print(self.strPaymentId as Any)
            // self.executeBKashPayment(token: self.strAccessToken, payment_id: self.strPaymentId)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            print(url as Any)
            
            // Check for specific success URLs or custom schemes
            if url.absoluteString.contains("success") {
                print("Success URL detected!")
                
                print(self.strAccessToken as Any)
                print(self.strPaymentId as Any)
                self.executeBKashPayment(token: self.strAccessToken, payment_id: self.strPaymentId)
                
            } else if url.absoluteString.contains("cancel") {
                self.navigationController?.popViewController(animated: true)
            }
               
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started provisional navigation")
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Committed navigation")
    }

    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // Called when there's an error during webpage loading
        print("Failed to load webpage: \(error.localizedDescription)")
        
    }
    
    func executeBKashPayment(token:String,payment_id:String) {
        
        print(payment_id as Any)
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            } else {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "ড্রাইভার খোঁজা হচ্ছে")
            }
            
        }
        
        // Define your API endpoint for creating a payment
        let paymentURL = URL(string: bkash_execute_payment)!
        
        // Create payment request
        var paymentRequest = URLRequest(url: paymentURL)
        paymentRequest.httpMethod = "POST"
        
        // Set headers
        paymentRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.setValue("Basic " + "\(apiKey):\(apiSecret)".data(using: .utf8)!.base64EncodedString(), forHTTPHeaderField: "Authorization")
        paymentRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        paymentRequest.setValue(bkash_app_key, forHTTPHeaderField: "x-app-key")
        
        // Set your payment details
        let paymentDetails: [String: Any] = [
            "paymentID": String(payment_id),
        ]
        
        // Convert payment details to Data
        guard let paymentData = try? JSONSerialization.data(withJSONObject: paymentDetails) else {
            print("Error creating payment data")
            return
        }
        
        // Attach payment data to the request
        paymentRequest.httpBody = paymentData
        
        // Create a URLSessionDataTask to send the payment request
        let paymentTask = URLSession.shared.dataTask(with: paymentRequest) { (data, response, error) in
            // Handle response
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if httpResponse.statusCode == 200 {
                // Parse and handle successful response
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Payment Response JSON: \(json)")
                        /*
                         amount = 100;
                         currency = BDT;
                         customerMsisdn = 01929918378;
                         intent = sale;
                         merchantInvoiceNumber = "invoice_7080826709";
                         payerReference = "ref_708801";
                         paymentExecuteTime = "2024-05-01T17:13:18:385 GMT+0600";
                         paymentID = TR00118rze9Ef1714561515013;
                         statusCode = 0000;
                         statusMessage = Successful;
                         transactionStatus = Completed;
                         trxID = BE120IINOY;
                         */
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = json as! Dictionary<AnyHashable, Any>
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                            
                            self.view_success_or_error.isHidden = false
                            self.view_please_wait.isHidden = true
                            self.lbl_message.isHidden = false
                            
                            
                            self.btn_home.isHidden = true
                            if (dict["transactionStatus"] != nil) {
                                print("SUCCESS")
                                self.lbl_message.text = "Payment: Success"
                                self.lbl_message.textColor = .green
                                
                                self.trxId = (dict["trxID"] as! String)
                                self.update_payment()
                                
                            } else {
                                print("SOMETHING WENT WRONG")
                                ERProgressHud.sharedInstance.hide()
                                self.lbl_message.text = "Payment failed."
                                self.btn_home.isHidden = false
                                self.btn_home.setTitleColor(.black, for: .normal)
                                self.btn_home.addTarget(self, action: #selector(home_click_method), for: .touchUpInside)
                                
                                let alert = NewYorkAlertController(title: String("Payment failed.").uppercased(), message: String("Please try again after sometime."), style: .alert)
                                let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                                alert.addButtons([cancel])
                                self.present(alert, animated: true)
                                
                            }
                        }
                        
                    } catch {
                        print("Error parsing payment response: \(error)")
                    }
                } else {
                    print("Empty payment response data")
                }
            } else {
                print("HTTP status code: \(httpResponse.statusCode)")
                // Handle other status codes
            }
        }
        
        // Execute the payment task
        paymentTask.resume()
    }
    
    @objc func update_payment() {
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! payment_table_cell
       
        self.view.endEditing(true)
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var ar : NSArray!
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            let arr_mut_order_history:NSMutableArray! = []
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
                /*
                 "action"        : "updatepayment",
                 "userId"        : String(myString),
                 "bookingId"     : String(self.str_booking_id2),
                 "transactionId"  : String("cash_dummy_transaction_id"),
                 "totalAmount"   : String(self.str_final_amount),
                 "TIP"           : String("0"),
                 "discountAmount"    : String(self.discounted_amount),
                 "couponCode"    : String(self.store_coupon_code),
                 "paymentMethod" : String("Cash"),
                 */
                
                var lan:String!
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        lan = "en"
                    } else {
                        lan = "bn"
                    }
                }
                
                parameters = [
                    "action"        : "updateadminpayment",
                    "userId"        : String(myString),
                    "amount"        : "\(self.doublePayment!)",
                    "PaymentMethod" : String("BKash"),
                    "transactionId" : String(self.trxId),
                    "language"      : String(lan),
                ]
                
                print(parameters as Any)
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON { [self]
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
                            
                            if let navigationController = self.navigationController {
                                navigationController.popToRootViewController(animated: true)
                            }

                            
                            /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "success_payment_id") as? success_payment
                            push!.get_booking_details = self.dict_full
                            self.navigationController?.pushViewController(push!, animated: true)*/
                            
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
                    "role"      : "Driver"
                ]
            }
            
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
                            
                            self.update_payment( )
                            
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
    
    @objc func home_click_method() {
        ERProgressHud.sharedInstance.hide()
        self.navigationController?.popViewController(animated: true)
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
        self.navigationController?.pushViewController(push!, animated: true)*/
    }
    
}
