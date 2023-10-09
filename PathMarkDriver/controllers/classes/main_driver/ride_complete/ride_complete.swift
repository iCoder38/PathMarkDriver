//
//  ride_complete.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 10/08/23.
//

import UIKit
import Alamofire

class ride_complete: UIViewController {

    var get_booking_data_for_end_ride:NSDictionary!

    @IBOutlet weak var view_big:UIView! {
        didSet {
            view_big.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btn_ride_complete:UIButton! {
        didSet {
            btn_ride_complete.setTitle("RIDE COMPLETED", for: .normal)
            btn_ride_complete.setTitleColor(.white, for: .normal)
            btn_ride_complete.layer.cornerRadius = 6
            btn_ride_complete.clipsToBounds = true
            btn_ride_complete.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
            
            // shadow
            btn_ride_complete.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_ride_complete.layer.shadowOffset = CGSize(width: 0, height: 3)
            btn_ride_complete.layer.shadowOpacity = 1.0
            btn_ride_complete.layer.shadowRadius = 10.0
            btn_ride_complete.layer.masksToBounds = false
            
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
    
    @IBOutlet weak var view_destination:UIView! {
        didSet {
            view_destination.layer.cornerRadius = 14
            view_destination.clipsToBounds = true
            
            // shadow
            view_destination.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_destination.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_destination.layer.shadowOpacity = 1.0
            view_destination.layer.shadowRadius = 10.0
            view_destination.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var lbl_drop_location:UILabel!
    
    @IBOutlet weak var lbl_distance:UILabel!
    @IBOutlet weak var lbl_duration:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // 
        
        self.get_and_parse_UI()
    }
    
    
    @objc func get_and_parse_UI() {
        
        if (self.get_booking_data_for_end_ride["distance"] == nil) {
            self.btn_distance.setTitle("\(self.get_booking_data_for_end_ride["totalDistance"]!)", for: .normal)
            self.lbl_distance.text = "\(self.get_booking_data_for_end_ride["totalDistance"]!)"
            
        } else {
            
            self.btn_distance.setTitle((self.get_booking_data_for_end_ride["distance"] as! String), for: .normal)
            self.lbl_distance.text = (self.get_booking_data_for_end_ride["distance"] as! String)
            
        }
        
        self.btn_est_earn.setTitle("n.a.", for: .normal)
        
        
        self.lbl_duration.text = "n.a."
        
        self.lbl_drop_location.text = (self.get_booking_data_for_end_ride["RequestDropAddress"] as! String)
        
        self.btn_ride_complete.addTarget(self, action: #selector(validation_before_accept_booking), for: .touchUpInside)
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
                    "action"        : "rideend",
                    "driverId"      : String(myString),
                    "bookingId"     : "\(self.get_booking_data_for_end_ride["bookingId"]!)",
                    "Actual_Drop_Address"  : (self.get_booking_data_for_end_ride["RequestDropAddress"] as! String),
                    "Actual_Drop_Lat_Long" : (self.get_booking_data_for_end_ride["RequestDropLatLong"] as! String),
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
                            
                            // self.pick_up_a_customer_click_method()
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "success_ride_done_id") as! success_ride_done
                            
                            push.str_final_price = "\(JSON["FinalFare"]!)"
                            
                            self.navigationController?.pushViewController(push, animated: true)
                            
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
