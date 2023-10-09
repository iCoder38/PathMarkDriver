//
//  start_ride_now.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 10/08/23.
//

import UIKit
import Alamofire

class start_ride_now: UIViewController {

    var get_booking_data_for_start_ride:NSDictionary!
    
    @IBOutlet weak var view_big:UIView! {
        didSet {
            view_big.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btn_start_ride_now:UIButton! {
        didSet {
            btn_start_ride_now.setTitle("START RIDE NOW", for: .normal)
            btn_start_ride_now.setTitleColor(.white, for: .normal)
            btn_start_ride_now.layer.cornerRadius = 6
            btn_start_ride_now.clipsToBounds = true
            btn_start_ride_now.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
            
            // shadow
            btn_start_ride_now.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_start_ride_now.layer.shadowOffset = CGSize(width: 0, height: 3)
            btn_start_ride_now.layer.shadowOpacity = 1.0
            btn_start_ride_now.layer.shadowRadius = 10.0
            btn_start_ride_now.layer.masksToBounds = false
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
    
    @IBOutlet weak var btn_call:UIButton! {
        didSet {
            btn_call.layer.cornerRadius = 20
            btn_call.clipsToBounds = true
            btn_call.backgroundColor = UIColor.init(red: 210.0/255.0, green: 214.0/255.0, blue: 240.0/255.0, alpha: 1)
        }
    }
    @IBOutlet weak var btn_message:UIButton! {
        didSet {
            btn_message.layer.cornerRadius = 20
            btn_message.clipsToBounds = true
            btn_message.backgroundColor = UIColor.init(red: 210.0/255.0, green: 214.0/255.0, blue: 240.0/255.0, alpha: 1)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.get_and_parse_UI()
        
        self.btn_start_ride_now.addTarget(self, action: #selector(validation_before_accept_booking), for: .touchUpInside)
        
    }
    
    @objc func get_and_parse_UI() {
        self.lbl_from.text = (self.get_booking_data_for_start_ride["RequestPickupAddress"] as! String)
        self.lbl_to.text = (self.get_booking_data_for_start_ride["RequestDropAddress"] as! String)
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
/*
 action:ridestart
 bookingId:
 driverId:
 Actual_PickupAddress:
 Actual_Pickup_Lat_Long:
 */

                parameters = [
                    "action"        : "ridestart",
                    "driverId"      : String(myString),
                    "bookingId"     : "\(self.get_booking_data_for_start_ride["bookingId"]!)",
                    "Actual_PickupAddress"  : (self.get_booking_data_for_start_ride["RequestPickupAddress"] as! String),
                    "Actual_Pickup_Lat_Long" : (self.get_booking_data_for_start_ride["RequestPickupLatLong"] as! String),
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
                            
                            if (JSON["AuthToken"] == nil) {
                                print("TOKEN NOT RETURN IN THIS ACTION = driverconfirm")
                            } else {
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            }

                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
                            self.pick_up_a_customer_click_method()
                            
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
    
    @objc func pick_up_a_customer_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ride_complete_id") as! ride_complete
        
        push.get_booking_data_for_end_ride = get_booking_data_for_start_ride
        
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
}
