//
//  success_ride_done.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 25/08/23.
//

import UIKit
import SwiftGifOrigin
import Alamofire

class success_ride_done: UIViewController {

    var dict_all_value:NSDictionary!
    
    var str_final_price:String!
    var str_total_distance:String!
    
    var counter = 5
    var timer:Timer!
    
    var str_booking_id:String!
    
    @IBOutlet weak var lbl_price:UILabel!
    
    @IBOutlet weak var btn_home:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print(self.dict_all_value as Any)
        /*
         CustomerImage = "https://demo4.evirtualservices.net/pathmark/img/uploads/users/1718602215PLUDIN_1718602270014.png";
         CustomerName = lee;
         CustomerPhone = 9685231911;
         RequestDropAddress = "Dwarka Sector 10 Metro Station Sector 10 Dwarka, New Delhi, Delhi 110075, India";
         RequestDropLatLong = "28.5811442,77.0574403";
         RequestPickupAddress = "Sector 10 Dwarka, South West Delhi New Delhi, India - 110075";
         RequestPickupLatLong = "28.58722870047447,77.06072508342316";
         RideCode = 617615;
         aps =     {
             alert = "New ride request from purnima pandey";
             sound = default;
         };
         bookingDate = "12-31-1969";
         bookingId = 472;
         device = iOS;
         deviceToken = "fUS8AHfs-UBDuHgJvO_nqT:APA91bFlwZinGuSV8ft981ARGOLm_n5zeUtUl2KG7iJQxcx4BM3JufMDjec106NkxrNEB2HLs1yKVCcXFw8AagL3SdwByOMYjoEKpuFNm-_bG1Pnx81cBk6HxvJXwyUHbemLkwwjbEal";
         distance = "0.8";
         duration = "4 mins";
         estimateAmount = "17.8";
         "gcm.message_id" = 1718871004315750;
         "google.c.a.e" = 1;
         "google.c.fid" = "fUS8AHfs-UBDuHgJvO_nqT";
         "google.c.sender.id" = 750959835757;
         message = "New ride request from purnima pandey";
         type = request;
         */
        
        self.str_booking_id = "\(self.dict_all_value["bookingId"]!)"
        
        self.booking_history_details_WB(str_show_loader: "yes")
        
        
        
        
        
        self.btn_home.addTarget(self, action: #selector(home_button_click), for: .touchUpInside)
    }
    
    @objc func home_button_click() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "driver_dashboard_id") as! driver_dashboard
        self.navigationController?.pushViewController(push, animated: true)
        
    }

    @objc func booking_history_details_WB(str_show_loader:String) {
        
        if (str_show_loader == "yes") {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "অপেক্ষা করুন")
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
                    "action"        : "bookingdetail",
                    "bookingId"     : String(self.str_booking_id),
                    "userId"        : String(myString),
                    "language"      : String(lan),
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
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            print(dict as Any)
                            
                            let cancellationFees:Double!
                            
                            if let amount = self.convertToDouble("\(dict["FinalFare"]!)"),
                               let bookingFees = self.convertToDouble("\(dict["bookingFee"]!)") {
                                
                                if "\(dict["last_cancel_amount"]!)" == "" {
                                    cancellationFees = self.convertToDouble("0.0")
                                } else if "\(dict["last_cancel_amount"]!)" == "0" {
                                    cancellationFees = self.convertToDouble("0.0")
                                } else {
                                    cancellationFees = self.convertToDouble("\(dict["last_cancel_amount"]!)")
                                }
                                
                                let totalAmount = amount + bookingFees + cancellationFees!
                                
                                if "\(dict["promotional_discount"]!)" != "" {
                                    let pro_dis = self.convertToDouble("\(dict["promotional_discount"]!)")
                                    print(pro_dis as Any)
                                    let complete_cal = totalAmount - pro_dis!
                                    print("Complete cal: \(complete_cal)")
                                    
                                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                        print(language as Any)
                                        
                                        if (language == "en") {
                                            
                                            let doublePrice1 = Double("\(complete_cal)")
                                            let formattedNumber1 = String(format: "%.2f", doublePrice1!)
                                            self.lbl_price.text = "Waiting for customer to pay \(str_bangladesh_currency_symbol) \(formattedNumber1)"
                                            
                                            self.btn_home.setTitle("Home", for: .normal)
                                        } else {
                                            let doublePrice1 = Double("\(complete_cal)")
                                            let formattedNumber1 = String(format: "%.2f", doublePrice1!)
                                            self.lbl_price.text = "গ্রাহক অর্থ প্রদানের জন্য অপেক্ষা করছেন \(str_bangladesh_currency_symbol) \(formattedNumber1)"
                                            
                                            self.btn_home.setTitle("বাড়ি", for: .normal)
                                        }
                                        
                                        
                                    } else {
                                        print("=============================")
                                        print("LOGIN : Select language error")
                                        print("=============================")
                                        UserDefaults.standard.set("en", forKey: str_language_convert)
                                    }
                                    
                                } else {
                                    
                                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                        print(language as Any)
                                        
                                        if (language == "en") {
                                            
                                            let doublePrice1 = Double("\(totalAmount)")
                                            let formattedNumber1 = String(format: "%.2f", doublePrice1!)
                                            self.lbl_price.text = "Waiting for customer to pay \(str_bangladesh_currency_symbol) \(formattedNumber1)"
                                            
                                            self.btn_home.setTitle("Home", for: .normal)
                                        } else {
                                            
                                            let doublePrice1 = Double("\(totalAmount)")
                                            let formattedNumber1 = String(format: "%.2f", doublePrice1!)
                                            self.lbl_price.text = "গ্রাহক অর্থ প্রদানের জন্য অপেক্ষা করছেন \(str_bangladesh_currency_symbol) \(formattedNumber1)"
                                            
                                            self.btn_home.setTitle("বাড়ি", for: .normal)
                                        }
                                        
                                        
                                    } else {
                                        print("=============================")
                                        print("LOGIN : Select language error")
                                        print("=============================")
                                        UserDefaults.standard.set("en", forKey: str_language_convert)
                                    }
                                    // self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(totalAmount)"
                                }
                                
                            } else {
                                print("Invalid number format in one of the strings.")
                            }
                            
                            
                            
                            /*// self.dict_get_booking_details = JSON
                            self.str_starrating = "\(dict["bookingrating"]!)"
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()*/
                            
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
                            
                            self.booking_history_details_WB(str_show_loader: "no")
                            
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
