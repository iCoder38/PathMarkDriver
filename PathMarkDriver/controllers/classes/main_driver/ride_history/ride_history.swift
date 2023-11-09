//
//  ride_history.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 11/08/23.
//

import UIKit
import Alamofire

class ride_history: UIViewController {

    var str_which_panel_select:String! = "0"
    
    var arr_mut_dashboard_data:NSMutableArray! = []
    
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
            view_navigation_title.text = "RIDE HISTORY"
            view_navigation_title.textColor = .white
        }
    }

    // 250 218 78
    @IBOutlet weak var btn_upcoming_ride:UIButton! {
        didSet {
            btn_upcoming_ride.setTitleColor(.black, for: .normal)
            btn_upcoming_ride.tag = 0
            btn_upcoming_ride.backgroundColor = UIColor.init(red: 250.0/255.0, green: 218.0/255.0, blue: 78.0/255.0, alpha: 1)
            btn_upcoming_ride.setTitle("Upcoming Ride", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_completed_ride:UIButton! {
        didSet {
            btn_completed_ride.setTitleColor(.black, for: .normal)
            btn_completed_ride.tag = 0
            btn_completed_ride.backgroundColor = UIColor.init(red: 250.0/255.0, green: 218.0/255.0, blue: 78.0/255.0, alpha: 1)
            btn_completed_ride.setTitle("History", for: .normal)
        }
    }
    
    @IBOutlet weak var lbl_upcoming_mark:UILabel! {
        didSet {
            lbl_upcoming_mark.backgroundColor = navigation_color
            lbl_upcoming_mark.isHidden = true
        }
    }
    
    @IBOutlet weak var lbl_complete_mark:UILabel! {
        didSet {
            lbl_complete_mark.backgroundColor = navigation_color
            lbl_complete_mark.isHidden = true
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sideBarMenu()
        
        self.tbleView.separatorColor = .clear
        
        self.lbl_upcoming_mark.isHidden = false
        self.btn_upcoming_ride.addTarget(self, action: #selector(upcoming_ride_click_method), for: .touchUpInside)
        self.btn_completed_ride.addTarget(self, action: #selector(completed_ride_click_method), for: .touchUpInside)
        
        self.arr_mut_dashboard_data.removeAllObjects()
        self.upcoming_ride_WB(str_show_loader: "yes")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // self.arr_mut_dashboard_data.removeAllObjects()
        // self.booking_history(str_show_loader: "yes")
    }
    
    @objc func sideBarMenu() {
        if revealViewController() != nil {
            btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @objc func upcoming_ride_click_method() {
        
        if (self.btn_upcoming_ride.tag == 0) {
            
            self.lbl_upcoming_mark.isHidden = false
            self.lbl_complete_mark.isHidden = true
            
            self.btn_upcoming_ride.tag = 1
        } else {
            
            self.btn_upcoming_ride.tag = 0
        }
        
        //
        self.str_which_panel_select = "0"
        // self.tbleView.reloadData()
        
        self.arr_mut_dashboard_data.removeAllObjects()
        self.upcoming_ride_WB(str_show_loader: "yes")
        
    }
    
    @objc func completed_ride_click_method() {
        self.validation_before_history()
    }
    
    @objc func validation_before_history() {
        
        if (self.btn_completed_ride.tag == 0) {
            
            self.lbl_upcoming_mark.isHidden = true
            self.lbl_complete_mark.isHidden = false
            
            self.btn_completed_ride.tag = 1
        } else {
            
            self.btn_completed_ride.tag = 0
        }
        
        //
        self.str_which_panel_select = "1"
        // self.tbleView.reloadData()
        
        self.arr_mut_dashboard_data.removeAllObjects()
        self.booking_history(str_show_loader: "yes")
    }
    
    
    @objc func upcoming_ride_WB(str_show_loader:String) {
        
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
                    "action"    : "bookinglist",
                    "userId"    : String(myString),
                    "usertype"  : String("Driver"),
                    "scheduled" : String("Yes"),
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

                            /*let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)*/
                            
                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arr_mut_dashboard_data.addObjects(from: ar as! [Any])
                            
                            print(self.arr_mut_dashboard_data.count as Any)
                            ERProgressHud.sharedInstance.hide()
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_for_upcoming_ride_wb()
                            
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
    
    @objc func login_refresh_token_for_upcoming_ride_wb() {
        
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
                            
                            self.upcoming_ride_WB(str_show_loader: "no")
                            
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
  
    @objc func booking_history(str_show_loader:String) {
        
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
                    "action"    : "bookinglist",
                    "userId"    : String(myString),
                    "usertype"  : String("Driver"),
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

                            /*let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)*/
                            
                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arr_mut_dashboard_data.addObjects(from: ar as! [Any])
                            
                            print(self.arr_mut_dashboard_data.count as Any)
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            
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
                            
                            self.booking_history(str_show_loader: "no")
                            
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
    
    // MARK: - PAYMENT IS PENDING POPUP -
    @objc func payment_is_pending_popup(fullData:NSDictionary) {
        
        let alert = NewYorkAlertController(title: String("Pending Payment").uppercased(), message: "Your payment of \(fullData["FinalFare"]!) is pending. Please pay and clear your all dues.", style: .alert)
        
        let pay = NewYorkButton(title: "pay", style: .default)  {_ in
            
        }
        
        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
        
        alert.addButtons([pay, cancel])
        self.present(alert, animated: true)
        
    }
    
}


extension ride_history: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.str_which_panel_select == "0" {
            return self.arr_mut_dashboard_data.count
        } else {
            return self.arr_mut_dashboard_data.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.str_which_panel_select == "0" {
            
            let cell:ride_history_upcoming_table_cell = tableView.dequeueReusableCell(withIdentifier: "ride_history_upcoming_table_cell") as! ride_history_upcoming_table_cell
            
            cell.backgroundColor = .clear
            
            let item = self.arr_mut_dashboard_data[indexPath.row] as? [String:Any]
            print(item as Any)
            
            cell.lbl_name.text = (item!["fullName"] as! String)
            cell.lbl_car_model.text = (item!["CarName"] as! String)
            cell.lbl_car_number.text = (item!["vehicleNumber"] as! String)+" ("+(item!["VehicleColor"] as! String)+")"
            
            cell.lbl_from.text = (item!["RequestPickupAddress"] as! String)
            cell.lbl_to.text = (item!["RequestDropAddress"] as! String)
            
            cell.lbl_date.text = (item!["bookingDate"] as! String)
            
            if "\(item!["rideStatus"]!)" == "4" {
                cell.lbl_status.backgroundColor = .systemGreen
                cell.lbl_status.text = "Completed"
                cell.lbl_status.textColor = .white
            } else {
                // compare date
                let dateString = (item!["bookingDate"] as! String)
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let stringDate = String(dateString)
                if let date = dateFormatter.date(from: stringDate) {
                    if date.isInThePast {
                        print("Date is past")
                        
                        cell.lbl_status.backgroundColor = .systemRed
                        cell.lbl_status.text = "Expired"
                        
                    } else if date.isInToday {
                        print("Date is today")
                        if "\(item!["rideStatus"]!)" == "1" {
                            cell.lbl_status.backgroundColor = .systemOrange
                            cell.lbl_status.text = "Pending"
                        }
                    } else {
                        print("Date is future")
                        if "\(item!["rideStatus"]!)" == "1" {
                            cell.lbl_status.backgroundColor = .systemOrange
                            cell.lbl_status.text = "Pending"
                        }
                    }
                }
            }
            
            
            
            
            return cell
            
        } else {
            
            let cell:ride_history_completed_table_cell = tableView.dequeueReusableCell(withIdentifier: "ride_history_completed_table_cell") as! ride_history_completed_table_cell
            
            cell.backgroundColor = .white
            
            let item = self.arr_mut_dashboard_data[indexPath.row] as? [String:Any]
            print(item as Any)
            
            cell.lbl_name_for_complete.text = (item!["fullName"] as! String)
            cell.lbl_car_model_for_complete.text = (item!["CarName"] as! String)
            cell.lbl_address_for_complete.text = (item!["RequestDropAddress"] as! String)
            
            
            // if payment is empty
            if "\(item!["paymentStatus"]!)" == "" {
                
                if "\(item!["rideStatus"]!)" == "1" {
                     
                    cell.lbl_status_for_complete.text = "You accepted"
                    cell.lbl_status_for_complete.textColor = .systemGreen
                } else if "\(item!["rideStatus"]!)" == "2" {
                     
                    cell.lbl_status_for_complete.text = "You picked your customer"
                    cell.lbl_status_for_complete.textColor = .systemYellow
                } else if "\(item!["rideStatus"]!)" == "3" {
                     
                    cell.lbl_status_for_complete.text = "On Going"
                    cell.lbl_status_for_complete.textColor = .systemOrange
                } else if "\(item!["rideStatus"]!)" == "4" {
                    
                    if "\(item!["paymentStatus"]!)" == "" {
                        cell.lbl_status_for_complete.text = "Yet to pay"
                        cell.lbl_status_for_complete.textColor = .systemBrown
                    } else {
                        cell.lbl_status_for_complete.text = "Completed"
                        cell.lbl_status_for_complete.textColor = .systemGreen
                    }
                    
                }  else if "\(item!["rideStatus"]!)" == "5" {
                    
                    if "\(item!["paymentStatus"]!)" == "" {
                         
                        cell.lbl_status_for_complete.text = "Yet to pay"
                        cell.lbl_status_for_complete.textColor = .systemBrown
                    } else {
                        cell.lbl_status_for_complete.text = "Completed"
                        cell.lbl_status_for_complete.textColor = .systemGreen
                                                
                    }
                    
                }
                
            } else {
                // if payment done
                if "\(item!["rideStatus"]!)" == "5" {
                    
                    if "\(item!["paymentStatus"]!)" == "" {
                        cell.lbl_status_for_complete.text = "Payment Pending"
                        cell.lbl_status_for_complete.textColor = .systemBrown
                    } else {
                        cell.lbl_status_for_complete.text = "Completed"
                        cell.lbl_status_for_complete.textColor = .systemGreen
                        
                    }
                    
                }
                
            }
            
            cell.lbl_status_for_complete.font = UIFont(name:"Poppins-SemiBold", size: 16.0)
            cell.lbl_date_for_complete.text = "\(item!["created"]!)"
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        // 0=send, 1=accepted, 2=PickupArrived, 3=RideStart,4=dropStatus,5=PaymentDone,6=Driver Not available
        
        /*let item = self.arr_mut_dashboard_data[indexPath.row] as? [String:Any]
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "start_ride_now_id") as! start_ride_now
        push.get_booking_data_for_start_ride = (item! as NSDictionary)
        self.navigationController?.pushViewController(push, animated: true)*/
        
        if self.str_which_panel_select == "0" {
            let item = self.arr_mut_dashboard_data[indexPath.row] as? [String:Any]
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_ride_details_id") as? schedule_ride_details
             push!.dict_get_upcoming_ride_details = (item! as NSDictionary)
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else {
            let item = self.arr_mut_dashboard_data[indexPath.row] as? [String:Any]
            
            // RIDE IS COMPLETE BUT PAYMENT IS PENDING
            if "\(item!["rideStatus"]!)" == "5" {
                
                if "\(item!["paymentStatus"]!)" != "" { // payment done
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ride_history_details_id") as? ride_history_details
                    push!.dict_get_booking_details = (item! as NSDictionary)
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                
            } else if "\(item!["rideStatus"]!)" == "1" { // after accept
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "after_accept_request_id") as! after_accept_request
                push.get_booking_data_for_pickup = (item! as NSDictionary)
                self.navigationController?.pushViewController(push, animated: true)
                
            } else if "\(item!["rideStatus"]!)" == "2" { // if you accepted
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "start_ride_now_id") as! start_ride_now
                
                push.get_booking_data_for_start_ride = (item! as NSDictionary)
                
                self.navigationController?.pushViewController(push, animated: true)
                
            } else if "\(item!["rideStatus"]!)" == "3" { // end
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ride_complete_id") as! ride_complete
                
                push.get_booking_data_for_end_ride = (item! as NSDictionary)
                
                self.navigationController?.pushViewController(push, animated: true)
                
            }  else if "\(item!["rideStatus"]!)" == "4" { // end
                
                let alert = UIAlertController(title: String("Payment Pending"), message: String("Customer yet to pay"), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                }))
                 
                self.present(alert, animated: true, completion: nil)
                
            }

        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.str_which_panel_select == "0" {
            return 220
        } else {
            return UITableView.automaticDimension
        }

    }
    
}

class ride_history_upcoming_table_cell: UITableViewCell {
    
    @IBOutlet weak var view_bg_full:UIView! {
        didSet {
            view_bg_full.backgroundColor = .white
            
            // shadow
            view_bg_full.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg_full.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_bg_full.layer.shadowOpacity = 1.0
            view_bg_full.layer.shadowRadius = 10.0
            view_bg_full.layer.masksToBounds = false
            view_bg_full.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.backgroundColor = .gray
            img_profile.layer.cornerRadius = 40
            img_profile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_name:UILabel!
    @IBOutlet weak var lbl_car_model:UILabel!
    @IBOutlet weak var lbl_car_number:UILabel!
    
    @IBOutlet weak var lbl_to:UILabel!
    @IBOutlet weak var lbl_from:UILabel!
    
    @IBOutlet weak var lbl_status:UILabel! {
        didSet {
            lbl_status.layer.cornerRadius = 8
            lbl_status.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_date:UILabel! {
        didSet {
            lbl_date.backgroundColor = navigation_color
            lbl_date.layer.cornerRadius = 12
            lbl_date.clipsToBounds = true
            lbl_date.text = "May 13th"
            lbl_date.textColor = .white
        }
    }
}

class ride_history_completed_table_cell: UITableViewCell {
    
    @IBOutlet weak var img_profile_for_complete:UIImageView! {
        didSet {
            img_profile_for_complete.backgroundColor = .gray
            img_profile_for_complete.layer.cornerRadius = 40
            img_profile_for_complete.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_name_for_complete:UILabel!
    @IBOutlet weak var lbl_car_model_for_complete:UILabel!
    @IBOutlet weak var lbl_address_for_complete:UILabel!
    
    @IBOutlet weak var lbl_status_for_complete:UILabel!
    @IBOutlet weak var lbl_date_for_complete:UILabel!
    
}

