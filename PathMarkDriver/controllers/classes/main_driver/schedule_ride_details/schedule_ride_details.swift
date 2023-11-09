//
//  schedule_ride_details.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 11/08/23.
//

import UIKit
import Alamofire

class schedule_ride_details: UIViewController {

    var dict_get_upcoming_ride_details:NSDictionary!
    
    @IBOutlet weak var view_navigation:UIView! {
        didSet {
            view_navigation.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var view_profile_name:UIView! {
        didSet {
            view_profile_name.backgroundColor = .white
            
            // shadow
            view_profile_name.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_profile_name.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_profile_name.layer.shadowOpacity = 1.0
            view_profile_name.layer.shadowRadius = 10.0
            view_profile_name.layer.masksToBounds = false
            view_profile_name.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.backgroundColor = .gray
            img_profile.layer.cornerRadius = 30
            img_profile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_name:UILabel!
    @IBOutlet weak var lbl_phone:UILabel!
    
    @IBOutlet weak var lbl_date:UILabel!
    @IBOutlet weak var lbl_time:UILabel!
    @IBOutlet weak var lbl_car:UILabel!
    
    @IBOutlet weak var lbl_total_fare:UILabel! {
        didSet {
            lbl_total_fare.text = "₴12"
            lbl_total_fare.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_total_distance:UILabel! {
        didSet {
            lbl_total_distance.text = "12 km"
            lbl_total_distance.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_to:UILabel!
    @IBOutlet weak var lbl_from:UILabel!
    
    @IBOutlet weak var view_from_to:UIView! {
        didSet {
            view_from_to.backgroundColor = .white
            
            // shadow
            view_from_to.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_from_to.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_from_to.layer.shadowOpacity = 1.0
            view_from_to.layer.shadowRadius = 10.0
            view_from_to.layer.masksToBounds = false
            view_from_to.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var view_date:UIView! {
        didSet {
            view_date.backgroundColor = .white
            
            // shadow
            view_date.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_date.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_date.layer.shadowOpacity = 1.0
            view_date.layer.shadowRadius = 10.0
            view_date.layer.masksToBounds = false
            view_date.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var view_time:UIView! {
        didSet {
            view_time.backgroundColor = .white
            
            // shadow
            view_time.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_time.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_time.layer.shadowOpacity = 1.0
            view_time.layer.shadowRadius = 10.0
            view_time.layer.masksToBounds = false
            view_time.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var view_booking:UIView! {
        didSet {
            view_booking.backgroundColor = .white
            
            // shadow
            view_booking.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_booking.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_booking.layer.shadowOpacity = 1.0
            view_booking.layer.shadowRadius = 10.0
            view_booking.layer.masksToBounds = false
            view_booking.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var btn_pickup:UIButton! {
        didSet {
            btn_pickup.setTitle("PICKUP", for: .normal)
            btn_pickup.setTitleColor(.white, for: .normal)
            btn_pickup.layer.cornerRadius = 6
            btn_pickup.clipsToBounds = true
            btn_pickup.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("==============================================")
        print(self.dict_get_upcoming_ride_details as Any)
        print("==============================================")
        
        self.parse_data()
    }
    
    @objc func parse_data() {
        self.lbl_name.text = (self.dict_get_upcoming_ride_details["fullName"] as! String)
        
        self.lbl_to.text = (self.dict_get_upcoming_ride_details["RequestDropAddress"] as! String)
        self.lbl_from.text = (self.dict_get_upcoming_ride_details["RequestPickupAddress"] as! String)
        
        self.lbl_date.text = "Date : "+(self.dict_get_upcoming_ride_details["bookingDate"] as! String)
        self.lbl_time.text = "Time : "+(self.dict_get_upcoming_ride_details["bookingTime"] as! String)
        
        self.lbl_time.text = (self.dict_get_upcoming_ride_details["bookingTime"] as! String)
        self.lbl_time.text = (self.dict_get_upcoming_ride_details["bookingTime"] as! String)
        self.lbl_car.text = "0000\(self.dict_get_upcoming_ride_details["bookingId"]!)"
        
        if "\(self.dict_get_upcoming_ride_details["rideStatus"]!)" == "4" {
            self.btn_pickup.isHidden = true
            self.btn_decline.isHidden = true
        } else {
            self.btn_pickup.isHidden = false
            self.btn_decline.isHidden = false
        }
        // self.btn_pickup.addTarget(self, action: #selector(compare_date_is_today), for: .touchUpInside)
        // self.lbl_.text = (self.dict_get_upcoming_ride_details["RequestPickupAddress"] as! String)
        // compare date
        self.compare_date_is_today()
        
        self.get_fare_and_distance(str_show_loader: "yes")
    }
    
    @objc func compare_date_is_today() {
        let dateString = (self.dict_get_upcoming_ride_details["bookingDate"] as! String)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = String(dateString)
        if let date = dateFormatter.date(from: stringDate) {
            if date.isInThePast {
                print("Date is past")
                self.btn_pickup.backgroundColor = .systemRed
                self.btn_pickup.setTitle("Expired", for: .normal)
                self.btn_pickup.isUserInteractionEnabled = false
            } else if date.isInToday {
                print("Date is today")
                self.btn_pickup.addTarget(self, action: #selector(pick_up), for: .touchUpInside)
            } else {
                print("Date is future")
                self.btn_pickup.backgroundColor = .systemGray
                self.btn_pickup.isUserInteractionEnabled = false
            }
        }
    }
    
    @objc func pick_up() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "after_accept_request_id") as! after_accept_request
        push.str_from_direct_notification = "no"
        push.get_booking_data_for_pickup = self.dict_get_upcoming_ride_details
        self.navigationController?.pushViewController(push, animated: true)
    }
    @objc func get_fare_and_distance(str_show_loader:String) {
        
        if (str_show_loader == "yes") {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        
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
                
                parameters = [
                    "action"        : "getprice",
                    "userId"        : String(myString),
                    "pickuplatLong" : (self.dict_get_upcoming_ride_details["RequestPickupLatLong"] as! String),
                    "droplatLong"   : (self.dict_get_upcoming_ride_details["RequestDropLatLong"] as! String),
                    "categoryId"    : "1"
                     
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
                        
                        // var message : String!
                        // message = (JSON["msg"] as? String)
                        
                        // print(strSuccess as Any)
                        if strSuccess == String("success") {
                            print("yes")
                            
                            /*let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)*/
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            self.lbl_total_fare.text = "\(str_bangladesh_currency_symbol) \(dict["total"]!)"
                            self.lbl_total_distance.text = "\(dict["distance"]!) KM"
                            
                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
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
                            
                            self.get_fare_and_distance(str_show_loader: "no")
                            
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
    /*
     [action] => ridecancel
         [userId] => 71
         [bookingId] => 52
         [userType] => Driver
         [cancelReason] => Passenger denied to go destination
         [cancelComment] => 
     */
}
extension Date {
    static var noon: Date { Date().noon }
    var noon: Date { Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)! }
    var isInToday: Bool { Calendar.current.isDateInToday(self) }
    var isInThePast: Bool { noon < .noon }
    var isInTheFuture: Bool { noon > .noon }
}
