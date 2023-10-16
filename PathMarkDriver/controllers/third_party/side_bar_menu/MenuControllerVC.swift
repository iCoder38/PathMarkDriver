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
            imgSidebarMenuImage.layer.cornerRadius = 35
            imgSidebarMenuImage.clipsToBounds = true
        }
    }
    
    // Member
    var arr_customer_title = ["Dashboard",
                              "Booking History",
                              "Earnings",
                              "Review and Rating",
                              "Cashout",
                              "Set Working Details",
                              "Edit Car Details",
                              "Edit Car Details",
                              "Change Password",
    ]
    
    var arr_customer_image = ["home",
                              "home",
                              "edit2",
                              "trip",
                              "lock",
                              "help",
                              "logout",
                              "logout",
                              "logout",
    ]
    
    // driver
    var arr_driver_title = ["Dashboard",
                            "Booking History",
                            "Earnings",
                            "Review and Rating",
                            "Cashout",
                            "Set Working Details",
                            "Edit Car Details",
                            "Update Documents",
                            "Change Password",
                            "About Us",
                            "Privacy Policy",
                            "Terms and Condition",
                            "FAQs",
                            "Emergency Contacts",
                            "Help",
                            "Logout",
  ]
    var arr_driver_image = ["home",
                            "doc",
                            "cashbout",
                            "rating",
                            "cashbout",
                            "reminder",
                            "doc",
                            "file",
                            "lock",
                            "AppIcon",
                            "doc",
                            "doc",
                            "help",
                            "doc",
                            "help",
                            "logout",
  ]
    
    
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
            tbleView.delegate = self
            tbleView.dataSource = self
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
        
        self.sideBarMenuClick()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.view.backgroundColor = navigation_color
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person as Any)
            
             if person["role"] as! String == "Member" {
                
                // self.lblUserName.text = (person["fullName"] as! String)
                 // self.lblAddress.text = (person["address"] as! String)
                 
             } else {
                
                self.lblUserName.text = (person["fullName"] as! String)
                // self.lblPhoneNumber.text = (person["contactNumber"] as! String)
                
                // imgSidebarMenuImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
            }
             
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
}

extension MenuControllerVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
        
            if person["role"] as! String == "Member" {
                return arr_customer_title.count
            } else {
                return self.arr_driver_title.count
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
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
            if person["role"] as! String == "Member" {
                
                cell.lblName.text = self.arr_customer_title[indexPath.row]
                cell.lblName.textColor = .white
                
                cell.imgProfile.image = UIImage(named: self.arr_customer_image[indexPath.row])
                cell.imgProfile.backgroundColor = .clear
                
            } else {
                
                cell.lblName.text = self.arr_driver_title[indexPath.row]
                cell.lblName.textColor = .white
                
                 cell.imgProfile.image = UIImage(named: self.arr_driver_image[indexPath.row])
                 cell.imgProfile.backgroundColor = .clear
                
            }
            
        } else {
            
            // temp
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {

            if arr_driver_title [indexPath.row] == "Booking History" {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                self.view.window?.rootViewController = sw
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ride_history_id")
                let navigationController = UINavigationController(rootViewController: destinationController!)
                sw.setFront(navigationController, animated: true)
                
            } else if arr_driver_title [indexPath.row] == "Dashboard" {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "driver_dashboard_id") as! driver_dashboard
                let navController = UINavigationController(rootViewController: obj)
                navController.setViewControllers([obj], animated:true)
                self.revealViewController().setFront(navController, animated: true)
                self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                
            } else if arr_driver_title [indexPath.row] == "Earnings" {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "earnings_id") as! earnings
                let navController = UINavigationController(rootViewController: obj)
                navController.setViewControllers([obj], animated:true)
                self.revealViewController().setFront(navController, animated: true)
                self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                
            } else if arr_driver_title [indexPath.row] == "Review and Rating" {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "rating_review_id") as! rating_review
                let navController = UINavigationController(rootViewController: obj)
                navController.setViewControllers([obj], animated:true)
                self.revealViewController().setFront(navController, animated: true)
                self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                
            } else if arr_driver_title [indexPath.row] == "FAQs" {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "faq_id") as! faq
                let navController = UINavigationController(rootViewController: obj)
                navController.setViewControllers([obj], animated:true)
                self.revealViewController().setFront(navController, animated: true)
                self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                
            } else if arr_driver_title [indexPath.row] == "Emergency Contacts" {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "emergency_contacts_id") as! emergency_contacts
                let navController = UINavigationController(rootViewController: obj)
                navController.setViewControllers([obj], animated:true)
                self.revealViewController().setFront(navController, animated: true)
                self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                
            } else if arr_driver_title [indexPath.row] == "Set Working Details" {
                
                let obj = self.storyboard?.instantiateViewController(withIdentifier: "set_location_hour_id") as! set_location_hour
                let navController = UINavigationController(rootViewController: obj)
                navController.setViewControllers([obj], animated:true)
                self.revealViewController().setFront(navController, animated: true)
                self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
                
            } else if arr_driver_title [indexPath.row] == "Logout" {
                
                self.validation_before_logout()
            }
            
            
            
            
            
            
            /*
             if person["role"] as! String == "Member" {
             
             if self.arr_customer_title[indexPath.row] == "Change Password" {
             
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
             self.view.window?.rootViewController = sw
             let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassword")
             let navigationController = UINavigationController(rootViewController: destinationController!)
             sw.setFront(navigationController, animated: true)
             
             }
             
             else if self.arr_customer_title[indexPath.row] == "Dashboard" {
             
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
             self.view.window?.rootViewController = sw
             let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "UPDSDashboardId")
             let navigationController = UINavigationController(rootViewController: destinationController!)
             sw.setFront(navigationController, animated: true)
             
             }
             
             else if self.arr_customer_title[indexPath.row] == "Order History" {
             
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
             self.view.window?.rootViewController = sw
             let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "UPDSOrderHistory")
             let navigationController = UINavigationController(rootViewController: destinationController!)
             sw.setFront(navigationController, animated: true)
             
             }
             
             else if self.arr_customer_title[indexPath.row] == "Help" {
             
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
             self.view.window?.rootViewController = sw
             let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "Help")
             let navigationController = UINavigationController(rootViewController: destinationController!)
             sw.setFront(navigationController, animated: true)
             
             }
             
             else if arr_customer_title[indexPath.row] == "Logout" {
             
             let alert = UIAlertController(title: String("Logout"), message: String("Are you sure you want to logout ?"), preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
             self.logoutWB()
             }))
             alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
             }))
             self.present(alert, animated: true, completion: nil)
             
             }
             
             if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
             
             if person["role"] as! String == "Driver" {
             
             if arr_customer_title[indexPath.row] == "Logout" {
             
             let alert = UIAlertController(title: String("Logout"), message: String("Are you sure you want to logout ?"), preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
             // self.logoutWB()
             }))
             alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
             }))
             self.present(alert, animated: true, completion: nil)
             
             }
             
             }
             
             }
             
             } else {
             
             if self.arr_driver_title[indexPath.row] == "Order History" {
             
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
             self.view.window?.rootViewController = sw
             let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "order_history_for_driver_id") as? order_history_for_driver
             let navigationController = UINavigationController(rootViewController: destinationController!)
             sw.setFront(navigationController, animated: true)
             
             } else if self.arr_driver_title[indexPath.row] == "New Orders" {
             
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
             self.view.window?.rootViewController = sw
             let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "driver_new_orders_id") as? driver_new_orders
             let navigationController = UINavigationController(rootViewController: destinationController!)
             sw.setFront(navigationController, animated: true)
             
             }
             
             }
             */
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
