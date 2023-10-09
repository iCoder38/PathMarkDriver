//
//  instant_booking_accept_decline.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 10/08/23.
//

import UIKit
import Alamofire

class instant_booking_accept_decline: UIViewController {

    var dict_get_all_data_from_notification:NSDictionary!
    
    @IBOutlet weak var view_big:UIView! {
        didSet {
            view_big.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btn_accept:UIButton! {
        didSet {
            btn_accept.setTitle("ACCEPT", for: .normal)
            btn_accept.setTitleColor(.white, for: .normal)
            btn_accept.layer.cornerRadius = 6
            btn_accept.clipsToBounds = true
            btn_accept.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
        }
    }
    @IBOutlet weak var btn_decline:UIButton! {
        didSet {
            btn_decline.setTitle("DECLINE", for: .normal)
            btn_decline.setTitleColor(.systemPink, for: .normal)
            btn_decline.layer.cornerRadius = 6
            btn_decline.clipsToBounds = true
            btn_decline.backgroundColor = .white
            btn_decline.layer.borderColor = UIColor.systemPink.cgColor
            btn_decline.layer.borderWidth = 2
        }
    }
    
    @IBOutlet weak var btn_distance:UIButton! {
        didSet {
            btn_distance.setTitleColor(.white, for: .normal)
            btn_distance.layer.cornerRadius = 14
            btn_distance.clipsToBounds = true
            btn_distance.backgroundColor = UIColor.init(red: 227.0/255.0, green: 230.0/255.0, blue: 244.0/255.0, alpha: 1)
        }
    }
    @IBOutlet weak var btn_est_earn:UIButton! {
        didSet {
            btn_est_earn.setTitleColor(.white, for: .normal)
            btn_est_earn.layer.cornerRadius = 14
            btn_est_earn.clipsToBounds = true
            btn_est_earn.backgroundColor = UIColor.init(red: 227.0/255.0, green: 230.0/255.0, blue: 244.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var lbl_from:UILabel!
    @IBOutlet weak var lbl_to:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        print(self.dict_get_all_data_from_notification as Any)
        
        self.parse_all_data_and_show_UI()
        
        self.btn_accept.addTarget(self, action: #selector(validation_before_accept_booking), for: .touchUpInside)
    }
    
    @objc func parse_all_data_and_show_UI() {
        
        self.lbl_from.text = (self.dict_get_all_data_from_notification["RequestPickupAddress"] as! String)
        self.lbl_to.text = (self.dict_get_all_data_from_notification["RequestDropAddress"] as! String)
    }

    @objc func validation_before_accept_booking() {

         self.accept_booking_WB(str_show_loader: "yes")
    }
    
    @objc func accept_booking_WB(str_show_loader:String) {
        
        if (str_show_loader == "yes") {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
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
                    "action"        : "driverconfirm",
                    "driverId"      : String(myString),
                    "bookingId"     : "\(self.dict_get_all_data_from_notification["bookingId"]!)"
                ]
                
                print(parameters as Any)
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON { [self]
                    response in
                    // debugPrint(response.result)
                    
                    switch response.result {
                    case let .success(value):
                        
                        let JSON = value as! NSDictionary
                        print(JSON as Any)
                        
                        /*
                         AuthToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2OTI5Nzk1MDYsImlzcyI6ImV2aXJ0dWFsc2VydmljZXMuY29tIiwibmJmIjoxNjkyOTc5NTA2LCJleHAiOjE2OTI5ODA1MDZ9.EBgepSazmmX13i2PNyUjZynh0fCyefwgpGKw_sNz9aRyLy-dCo1-bpPjxiLj6xjRNunNrjWDvAx__XlUDsTlng";
                         RequestDropAddress = "MOD Apartment MOD Apartment";
                         RequestDropLatLong = "28.597894,77.318949";
                         RequestPickupAddress = "Sector 10 Dwarka South West Delhi New Delhi,New Delhi,India";
                         RequestPickupLatLong = "28.5823,77.05";
                         UserContactNumber = 8786878586;
                         UserName = dishu1;
                         msg = "Confirmed successfully.";
                         status = success;
                         userImage = "";
                         */
                        var strSuccess : String!
                        strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                        
                        var message : String!
                        message = (JSON["msg"] as? String)
                        
                        print(strSuccess as Any)
                        if strSuccess == String("success") {
                            print("yes")
                            
                            if (JSON["AuthToken"] == nil) {
                                print("TOKEN NOT RETURN IN THIS ACTION = driverconfirm")
                            } else {
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            }
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "after_accept_request_id") as! after_accept_request
                            push.get_booking_data_for_pickup = dict_get_all_data_from_notification
                            self.navigationController?.pushViewController(push, animated: true)
                            
                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
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
                            
                            self.accept_booking_WB(str_show_loader: "no")
                            
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
