//
//  MenuControllerVC.swift
//  SidebarMenu
//
//  Created by Apple  on 16/10/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

import CryptoKit
import JWTDecode
import Alamofire

class MenuControllerVC: UIViewController {

    let cellReuseIdentifier = "menuControllerVCTableCell"
    
    var bgImage: UIImageView?
    
    var roleIs:String!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var viewUnderNavigation:UIView! {
        didSet {
            viewUnderNavigation.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "MENU"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var imgSidebarMenuImage:UIImageView! {
        didSet {
            imgSidebarMenuImage.backgroundColor = .clear
            imgSidebarMenuImage.layer.cornerRadius = 30
            imgSidebarMenuImage.clipsToBounds = true
        }
    }
  
    var str_menu_title_home:String! = "Home"
    var str_menu_title_edit_profile:String! = "Edit Profile"
    var str_menu_title_booking_history:String! = "Booking History"
    var str_menu_title_earnings:String! = "Earnings"
    var str_menu_title_review:String! = "Review and Rating"
    var str_menu_title_cashout:String! = "Cashout"
    var str_menu_title_set_working_details:String! = "Set Working Details"
    var str_menu_title_update_vehicle_details:String! = "Update vehicle details"
    var str_menu_title_upload_documents:String! = "Upload Documents"
    var str_menu_title_about_us:String! = "About Zarib"
    var str_menu_title_change_password:String! = "Change Password"
    var str_menu_title_privacy_policy:String! = "Privacy Policy"
    var str_menu_title_terms:String! = "Terms and Condition"
    var str_menu_title_emergency_contacts:String! = "Emergency Contacts"
    var str_menu_title_help:String! = "Help"
    var str_menu_title_faq:String! = "FAQ(s)"
    var str_menu_title_change_language:String! = "Change Language"
    var str_menu_title_logout:String! = "Logout"
    
    // driver
    var arr_driver_title: NSArray!
    var arr_driver_title_bn:NSArray!
  
    var arr_driver_image: NSArray!
    
    
    @IBOutlet weak var lblUserName:UILabel! {
        didSet {
            lblUserName.text = "JOHN SMITH"
            lblUserName.textColor = .white
        }
    }
    @IBOutlet weak var lblPhoneNumber:UILabel! {
        didSet {
            lblPhoneNumber.textColor = .white
        }
    }
    
    @IBOutlet var menuButton:UIButton!
    
    @IBOutlet weak var btn_panic:UIButton! {
        didSet {
            btn_panic.setTitle("PANIC SOS", for: .normal)
            btn_panic.setTitleColor(.white, for: .normal)
            btn_panic.layer.cornerRadius = 6
            btn_panic.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            
            tbleView.tableFooterView = UIView.init()
            tbleView.backgroundColor = navigation_color
            // tbleView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
            tbleView.separatorColor = .white
        }
    }
    @IBOutlet weak var lblMainTitle:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideBarMenuClick()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.tbleView.separatorColor = .white

        self.view.backgroundColor = .white
        
        self.arr_driver_title = [String(self.str_menu_title_home),
                                 String(self.str_menu_title_edit_profile),
                                 String(self.str_menu_title_booking_history),
                                 String(self.str_menu_title_earnings),
                                 String(self.str_menu_title_review),
                                 String(self.str_menu_title_cashout),
                                 // String(self.str_menu_title_set_working_details),
                                 String(self.str_menu_title_update_vehicle_details),
                                 String(self.str_menu_title_upload_documents),
                                 String(self.str_menu_title_about_us),
                                 // String(self.str_menu_title_change_password),
                                 String(self.str_menu_title_privacy_policy),
                                 String(self.str_menu_title_terms),
                                 String(self.str_menu_title_faq),
                                 String(self.str_menu_title_emergency_contacts),
                                 String(self.str_menu_title_help),
                                 String(self.str_menu_title_change_language),
                                 String(self.str_menu_title_logout)
        ]
        
        // bn
        self.arr_driver_title_bn = ["ড্যাশবোর্ড",
                                 "প্রোফাইল আপডেট করুন",
                                 "বুকিংস ",
                                 "উপার্জন",
                                 "রিভিউ ও রেটিং",
                                 "উত্তোলন",
                                 // String(self.str_menu_title_set_working_details),
                                 "গাড়ির তথ্যাদি আপডেট করুন",
                                 "ডকুমেন্ট আপলোড করুন",
                                 "যারিব সম্পর্কে জানুন",
                                 // String(self.str_menu_title_change_password),
                                 "প্রাইভেসি পলিসি",
                                 "দয়া করে শর্তাদি এবং শর্ত নির্বাচন করুন",
                                 "আপনাদের করা প্রশ্নের উত্তরসমূহ",
                                 "জরুরী যোগাযোগ",
                                 "হেল্প",
                                    "ভাষা পরিবর্তন করুন",
                                 "লগ-আউট করুন",
        ]
        
        self.arr_driver_image = ["home",
                                 "menu_edit",
                                 "note",
                                 "earning",
                                 "rating",
                                 "cashout",
                                 // "gh",
                                 "edit1",
                                 "file",
                                 "logo-white",
                                 // "AppIcon",
                                 "note",
                                 "note",
                                 "help",
                                 "emergency_contact",
                                 "help",
                                 "language_white",
                                 "logout",
       ]
        
        self.tbleView.delegate = self
        self.tbleView.dataSource = self
        
        self.btn_panic.addTarget(self, action: #selector(panic_click_method), for: .touchUpInside)
        
        self.sideBarMenuClick()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.view.backgroundColor = navigation_color
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person as Any)
            
            self.lblUserName.text = (person["fullName"] as! String)
            self.imgSidebarMenuImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.imgSidebarMenuImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
            
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    @objc func sideBarMenuClick() {
        
        if revealViewController() != nil {
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
    
    @objc func panic_click_method() {
        self.panic_sos_WB(str_show_loader: "yes")
    }
     
    
    @objc func panic_sos_WB(str_show_loader:String) {
        
        if (str_show_loader == "yes") {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        
        self.view.endEditing(true)
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var str_lat:String!
            var str_long:String!
            var str_address:String!
            
            let userDefaults = UserDefaults.standard
            let myString2 = userDefaults.string(forKey: "key_current_latitude")
            let myString3 = userDefaults.string(forKey: "key_current_latitude")
            let myString4 = userDefaults.string(forKey: "key_current_address")
            
            str_lat = myString2
            str_long = myString3
            str_address = myString4
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
                parameters = [
                    "action"            : "panic",
                    "userId"            : String(myString),
                    "panicAddress"      : String(str_address),
                    "panicLatLong"      : String(str_lat)+","+String(str_long),
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
                            
                            /*let defaults = UserDefaults.standard
                            defaults.setValue("", forKey: str_save_login_user_data)
                            defaults.setValue("", forKey: str_save_last_api_token)*/
                            
                            
                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
                            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(message), style: .alert)
                            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            
                            /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                            self.view.window?.rootViewController = sw
                            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "login_id")
                            let navigationController = UINavigationController(rootViewController: destinationController!)
                            sw.setFront(navigationController, animated: true)*/
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_2_wb()
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
    
    @objc func login_refresh_token_2_wb() {
        
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
                            
                            self.panic_sos_WB(str_show_loader: "no")
                            
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

extension MenuControllerVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                return self.arr_driver_title.count
            } else {
                return self.arr_driver_title_bn.count
            }
            
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuControllerVCTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MenuControllerVCTableCell
        
        cell.backgroundColor = .clear
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
       // if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
            
            cell.lblName.textColor = .white
            
            
            cell.imgProfile.image = UIImage(named: self.arr_driver_image[indexPath.row] as! String)
            cell.imgProfile.backgroundColor = .clear
            
      // arr_driver_title
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                
                cell.lblName.text = (self.arr_driver_title[indexPath.row] as! String)
                
            } else {
                cell.lblName.text = (self.arr_driver_title_bn[indexPath.row] as! String)
            }
            
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (arr_driver_title [indexPath.row] as! String) ==  String(self.str_menu_title_booking_history) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ride_history_id")
            let navigationController = UINavigationController(rootViewController: destinationController!)
            sw.setFront(navigationController, animated: true)
            
        }  else if (arr_driver_title [indexPath.row] as! String) == "Change Language" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
            self.view.window?.rootViewController = sw
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "change_language_id")
            let navigationController = UINavigationController(rootViewController: destinationController!)
            sw.setFront(navigationController, animated: true)
            
        } else if (arr_driver_title [indexPath.row] as! String) == String(self.str_menu_title_home) {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "driver_dashboard_id") as! driver_dashboard
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        } else if arr_driver_title [indexPath.row] as! String == String(self.str_menu_title_earnings) {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "earnings_id") as! earnings
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        } else if arr_driver_title [indexPath.row] as! String == String(self.str_menu_title_review) {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "rating_review_id") as! rating_review
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        } else if arr_driver_title [indexPath.row] as! String == String(self.str_menu_title_faq) {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "faq_id") as! faq
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        } else if arr_driver_title [indexPath.row] as! String == String(self.str_menu_title_emergency_contacts) {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "emergency_contacts_id") as! emergency_contacts
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        } else if arr_driver_title [indexPath.row] as! String == String(self.str_menu_title_set_working_details) {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "set_location_hour_id") as! set_location_hour
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        } else if arr_driver_title [indexPath.row] as! String == String(self.str_menu_title_update_vehicle_details) {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "add_vehicle_details_id") as! add_vehicle_details
            obj.str_for_update = "yes"
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        } else if arr_driver_title [indexPath.row] as! String == String(self.str_menu_title_upload_documents) {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "upload_documents_id") as! upload_documents
            obj.str_for_update = "yes"
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        } else if arr_driver_title [indexPath.row] as! String == String(self.str_menu_title_about_us) {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "about_us_id") as! about_us
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        } else if arr_driver_title [indexPath.row] as! String == String(self.str_menu_title_cashout) {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "cashout_id") as! cashout
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        } else if arr_driver_title [indexPath.row] as! String == String(self.str_menu_title_help) {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "help_id") as! help
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        }  else if arr_driver_title [indexPath.row] as! String == String(self.str_menu_title_edit_profile) {
            
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "edit_profile_id") as! edit_profile
            let navController = UINavigationController(rootViewController: obj)
            navController.setViewControllers([obj], animated:true)
            self.revealViewController().setFront(navController, animated: true)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
            
        } else if arr_driver_title [indexPath.row] as! String == String(self.str_menu_title_logout) {
            
            self.validation_before_logout()
        }
        
    }
    
    @objc func validation_before_logout() {
        self.logoutWB(str_show_loader: "yes")
    }
    
    @objc func logoutWB(str_show_loader:String) {
        
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
                    "action"    : "logout",
                    "userId"    : String(myString),
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
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue("", forKey: str_save_login_user_data)
                            defaults.setValue("", forKey: str_save_last_api_token)
                            
                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                            self.view.window?.rootViewController = sw
                            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "login_id")
                            let navigationController = UINavigationController(rootViewController: destinationController!)
                            sw.setFront(navigationController, animated: true)
                            
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
                            
                            self.logoutWB(str_show_loader: "no")
                            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MenuControllerVC: UITableViewDelegate {
    
}
