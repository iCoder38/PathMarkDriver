//
//  schedule_ride_details.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 11/08/23.
//

import UIKit
import Alamofire

class schedule_ride_details: UIViewController {
    
    var str_from_noti:String!
    
    let serverDateFormatter:DateFormatter = {
        let result = DateFormatter()
        result.dateFormat = "HH:MM"
        result.locale = Locale(identifier: "en_US_POSIX")
        result.timeZone = TimeZone(secondsFromGMT: 0)
        return result
    }()
    
    @IBOutlet weak var btn_back:UIButton!
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
    
    @IBOutlet weak var lbl_message:UILabel!  {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_message.text = "You have confirmed a schedule ride with passenger. Pickup button will be activated before 10 minute of the schedule ride time."
                    
                } else {
                    lbl_message.text = "আপনি যাত্রীর সাথে একটি শিডিউল রাইড নিশ্চিত করেছেন। পিকআপ বোতামটি শিডিউল রাইডের সময় 10 মিনিটের আগে সক্রিয় করা হবে।"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_name:UILabel!
    @IBOutlet weak var lbl_phone:UILabel!
    
    @IBOutlet weak var lbl_date:UILabel!
    @IBOutlet weak var lbl_time:UILabel!
    @IBOutlet weak var lbl_car:UILabel!
    
    @IBOutlet weak var lbl_total_fare_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_total_fare_text.text = "TOTAL FARE"
                    
                } else {
                    lbl_total_fare_text.text = "মোট ভাড়া"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    @IBOutlet weak var lbl_total_distance_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_total_distance_text.text = "TOTAL DISTANCE"
                    
                } else {
                    lbl_total_distance_text.text = "সম্পুর্ণ দুরত্ব"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
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
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_pickup.setTitle("PICKUP", for: .normal)
                    
                } else {
                    btn_pickup.setTitle("পিকআপ", for: .normal)
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            btn_pickup.setTitleColor(.white, for: .normal)
            btn_pickup.layer.cornerRadius = 6
            btn_pickup.clipsToBounds = true
            btn_pickup.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
            btn_pickup.backgroundColor = .systemGray
            btn_pickup.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var btn_decline:UIButton! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_decline.setTitle("DECLINE", for: .normal)
                    
                } else {
                    btn_decline.setTitle("অস্বীকার করুন", for: .normal)
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
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
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if (self.str_from_noti == "yes") {
            self.btn_back.isHidden = false
            self.btn_back.setImage(UIImage(systemName: "home"), for: .normal)
            self.btn_back.addTarget(self, action: #selector(home_page), for: .touchUpInside)
            self.btn_back.tintColor = .white
            
        } else {
            self.btn_back.isHidden = false
            self.btn_back.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btn_back.addTarget(self, action: #selector(back_page), for: .touchUpInside)
            
        }
        self.parse_data()
        
        self.btn_decline.addTarget(self, action: #selector(cancancel_ride_click_method), for: .touchUpInside)
    }
    
    @objc func cancancel_ride_click_method() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "decline_request_id") as? decline_request
        myAlert!.dict_booking_details = self.dict_get_upcoming_ride_details
        myAlert!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(myAlert!, animated: true, completion: nil)
    }
    
    @objc func home_page() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "driver_dashboard_id") as! driver_dashboard
         self.navigationController?.pushViewController(push, animated: true)
    }
    @objc func back_page() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func parse_data() {
        /*
         CustomerImage = "https://demo4.evirtualservices.net/pathmark/img/uploads/users/1703176416PLUDIN_1703144035652.png";
         CustomerName = "biz@1";
         CustomerPhone = 9865325241;
         RequestDropAddress = "Sector 10 Dwarka, Dwarka, Delhi, 110075, India";
         RequestDropLatLong = "28.5849492,77.05828439999999";
         RequestPickupAddress = "9/1, Block C, Yojna Vihar, Anand Vihar, Ghaziabad, Uttar Pradesh 110092, India ";
         RequestPickupLatLong = "28.6634225,77.324078";
         RideCode = 608688;
         aps =     {
             alert = "New booking request for Confir or Cancel.";
         };
         bookingDate = "02-07-2024";
         bookingId = 86;
         bookingTime = "23:00";
         device = iOS;
         deviceToken = "c5gz-g9rUEqUs2qZ6PW93c:APA91bF9mr0vAtxGCzJr-_3bSVlPQUWFbfWxmOoUG0sp0VVC-oG4zPgZIT5Wdsy3UeaEwohqAAZbYgLy3R9nF640iEDIfDF4Htpe4CuZqPzdul-qPHCFl-zGeVBtmktw6aHswSrQNgOs";
         distance = "23.6";
         duration = "1 hour 6 mins";
         estimateAmount = "328.2";
         "gcm.message_id" = 1707296077361223;
         "google.c.a.e" = 1;
         "google.c.fid" = "c5gz-g9rUEqUs2qZ6PW93c";
         "google.c.sender.id" = 750959835757;
         message = "New booking request for Confir or Cancel.";
         type = request;
         */
        
        if self.dict_get_upcoming_ride_details["fullName"] == nil {
            self.lbl_name.text = (self.dict_get_upcoming_ride_details["CustomerName"] as! String)
        } else {
            self.lbl_name.text = (self.dict_get_upcoming_ride_details["fullName"] as! String)
        }
        
        self.lbl_to.text = (self.dict_get_upcoming_ride_details["RequestDropAddress"] as! String)
        self.lbl_from.text = (self.dict_get_upcoming_ride_details["RequestPickupAddress"] as! String)
        
        if self.dict_get_upcoming_ride_details["bookingTime"] == nil {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    self.lbl_date.text = "Date : "+(self.dict_get_upcoming_ride_details["bookingDate"] as! String)
                    // self.lbl_time.text = "Time : "+(self.dict_get_upcoming_ride_details["bookingTime"] as! String)
                } else {
                    self.lbl_date.text = "তারিখ : "+(self.dict_get_upcoming_ride_details["bookingDate"] as! String)
                    // self.lbl_time.text = "সময় : "+(self.dict_get_upcoming_ride_details["bookingTime"] as! String)
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
                    self.lbl_date.text = "Date : "+(self.dict_get_upcoming_ride_details["bookingDate"] as! String)
                    self.lbl_time.text = "Time : "+(self.dict_get_upcoming_ride_details["bookingTime"] as! String)
                    
                    let fullName    = (self.dict_get_upcoming_ride_details["bookingTime"] as! String)
                    let fullNameArr = fullName.components(separatedBy: ":")

                    let hour    = fullNameArr[0]
                    let minute = fullNameArr[1]
                    
                    var str_am:String! = "am"
                    var str_pm:String! = "pm"
                    
                    var booking_date_and_time_text = ""
                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                        print(language as Any)
                        
                        if (language == "en") {
                            booking_date_and_time_text = "Time"
                        } else {
                            booking_date_and_time_text = "সময়"
                        }
                        
                         
                    } else {
                        print("=============================")
                        print("LOGIN : Select language error")
                        print("=============================")
                        UserDefaults.standard.set("en", forKey: str_language_convert)
                    }
                    
                    if (hour == "13") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 1:"+minute+str_pm
                    } else if (hour == "14") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 2:"+minute+str_pm
                    } else if (hour == "15") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 3:"+minute+str_pm
                    } else if (hour == "16") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 4:"+minute+str_pm
                    } else if (hour == "17") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 5:"+minute+str_pm
                    } else if (hour == "18") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 6:"+minute+str_pm
                    } else if (hour == "19") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 7:"+minute+str_pm
                    } else if (hour == "20") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 8:"+minute+str_pm
                    } else if (hour == "21") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 9:"+minute+str_pm
                    } else if (hour == "22") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 10:"+minute+str_pm
                    } else if (hour == "23") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 11:"+minute+str_pm
                    } else if (hour == "24") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 12:"+minute+str_pm
                    } else {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" "+(self.dict_get_upcoming_ride_details["bookingTime"] as! String)+str_am
                    }
                    
                } else {
                    self.lbl_date.text = "তারিখ : "+(self.dict_get_upcoming_ride_details["bookingDate"] as! String)
                    self.lbl_time.text = "সময় : "+(self.dict_get_upcoming_ride_details["bookingTime"] as! String)
                    
                    let fullName    = (self.dict_get_upcoming_ride_details["bookingTime"] as! String)
                    let fullNameArr = fullName.components(separatedBy: ":")

                    let hour    = fullNameArr[0]
                    let minute = fullNameArr[1]
                    
                    var str_am:String! = "am"
                    var str_pm:String! = "pm"
                    
                    var booking_date_and_time_text = ""
                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                        print(language as Any)
                        
                        if (language == "en") {
                            booking_date_and_time_text = "Time"
                        } else {
                            booking_date_and_time_text = "সময়"
                        }
                        
                         
                    } else {
                        print("=============================")
                        print("LOGIN : Select language error")
                        print("=============================")
                        UserDefaults.standard.set("en", forKey: str_language_convert)
                    }
                    
                    if (hour == "13") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 1:"+minute+str_pm
                    } else if (hour == "14") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 2:"+minute+str_pm
                    } else if (hour == "15") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 3:"+minute+str_pm
                    } else if (hour == "16") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 4:"+minute+str_pm
                    } else if (hour == "17") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 5:"+minute+str_pm
                    } else if (hour == "18") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 6:"+minute+str_pm
                    } else if (hour == "19") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 7:"+minute+str_pm
                    } else if (hour == "20") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 8:"+minute+str_pm
                    } else if (hour == "21") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 9:"+minute+str_pm
                    } else if (hour == "22") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 10:"+minute+str_pm
                    } else if (hour == "23") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 11:"+minute+str_pm
                    } else if (hour == "24") {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" 12:"+minute+str_pm
                    } else {
                        self.lbl_time.text = "\(booking_date_and_time_text) : "+" "+(self.dict_get_upcoming_ride_details["bookingTime"] as! String)+str_am
                    }
                    
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
        
        // self.lbl_time.text = (self.dict_get_upcoming_ride_details["bookingTime"] as! String)
        // self.lbl_time.text = (self.dict_get_upcoming_ride_details["bookingTime"] as! String)
        
        self.lbl_car.text = "0000\(self.dict_get_upcoming_ride_details["bookingId"]!)"
        
        if (self.dict_get_upcoming_ride_details["rideStatus"] == nil) {
            
        } else {
            
            if "\(self.dict_get_upcoming_ride_details["rideStatus"]!)" == "4" {
                self.btn_pickup.isHidden = true
                self.btn_decline.isHidden = true
            } else {
                self.btn_pickup.isHidden = false
                self.btn_decline.isHidden = false
            }
            
        }
       
        self.compare_date_is_today()
        self.get_fare_and_distance(str_show_loader: "yes")
    }
    
    @objc func compare_date_is_today() {
        let dateString = (self.dict_get_upcoming_ride_details["bookingDate"] as! String)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let stringDate = String(dateString)
        if let date = dateFormatter.date(from: stringDate) {
            if date.isInThePast {
                print("Date is past")
                self.btn_pickup.backgroundColor = .systemRed
                self.btn_pickup.setTitle("Expired", for: .normal)
                self.btn_pickup.isUserInteractionEnabled = false
            } else if date.isInToday {
                print("Date is today")
                self.check_time_validation()
            } else {
                print("Date is future")
                self.btn_pickup.backgroundColor = .systemGray
                self.btn_pickup.isUserInteractionEnabled = false
            }
        } else {
            print("DATE FORMAT IS NOT CORRECT. PLEASE CHECK AGAIN")
        }
        
        //
        
        //
    }
    
    // time 10 min
    
    @objc func check_time_validation() {
        print("date is today and pickup")
       
        let string = "\(self.dict_get_upcoming_ride_details["bookingTime"]!)"
        // let string = "14:22"

        // set time format from server time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: string)
        
        // minus 10 minutes from it
        let addminutes = date!.addingTimeInterval(-9*60)
        dateFormatter.dateFormat = "HH:mm"
        let after_add_time = dateFormatter.string(from: addminutes)
        
        if Date.getCurrentDate() > after_add_time {
            print("YES, GOOD TO GO")
            self.btn_pickup.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
            self.btn_pickup.isUserInteractionEnabled = true
            
            self.btn_pickup.addTarget(self, action: #selector(pick_up), for: .touchUpInside)
            
        } else {
            print("NO PICKUP")
            self.btn_pickup.backgroundColor = .systemGray
            self.btn_pickup.isUserInteractionEnabled = false
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
            
            var ar : NSArray!
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            let arr_mut_order_history:NSMutableArray! = []
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
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
                    
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                
                parameters = [
                    "action"        : "getprice",
                    "userId"        : String(myString),
                    "pickuplatLong" : (self.dict_get_upcoming_ride_details["RequestPickupLatLong"] as! String),
                    "droplatLong"   : (self.dict_get_upcoming_ride_details["RequestDropLatLong"] as! String),
                    "categoryId"    : "1",
                    "language"      : String(lan)
                     
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
    func getFormattedDate(format: String) -> String {
         let dateformat = DateFormatter()
         dateformat.dateFormat = format
         return dateformat.string(from: self)
     }
    
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date())
    }
    
    
    static var noon: Date { Date().noon }
    var noon: Date { Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)! }
    var isInToday: Bool { Calendar.current.isDateInToday(self) }
    var isInThePast: Bool { noon < .noon }
    var isInTheFuture: Bool { noon > .noon }
}

 
