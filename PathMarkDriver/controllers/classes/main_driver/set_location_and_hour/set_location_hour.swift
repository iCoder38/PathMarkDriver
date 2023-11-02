//
//  set_location_hour.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 11/08/23.
//

import UIKit
import Alamofire

class set_location_hour: UIViewController , UITextFieldDelegate {

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
            view_navigation_title.text = "Set location & Hour"
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    var str_location_type:String! = "0"
    
    var str_from_location:String!
    var str_to_location:String!
    
    var str_from_latitude:String!
    var str_from_longitude:String!
    var str_to_latitude:String!
    var str_to_longitude:String!
    
    /*
     [action] => editProfile
        [userId] => 71
        [pickupAddress] => 9/1, Block C, Yojna Vihar, Anand Vihar, Ghaziabad, Uttar Pradesh 110092, India
        [pickup_Latitude] => 28.6634564
        [pickup_Longitude] => 77.3240168
        [dropAddress] => G6HC+WWV, Sector 6, Pushp Vihar, New Delhi, Delhi 110017, India
        [drop_Latitude] => 28.529733
        [drop_Longitude] => 77.2223521
        [Working_startDate] => 2023-11-02
        [Working_endDate] => 2024-04-23
        [Working_startTime] => 06:00
        [Working_endTime] => 23:00
     */
    let timePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sideBarMenu()
        
        self.tbleView.separatorColor = .clear
        
    }
    
    @objc func sideBarMenu() {
        
        if revealViewController() != nil {
            
            btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // latitude
        if let load_latitude = UserDefaults.standard.string(forKey: "key_saved_latitude") {
            print(load_latitude)
            
            if (self.str_location_type == "1") {
                self.str_from_latitude = load_latitude
            } else {
                self.str_to_latitude = load_latitude
            }
            
        }
        
        // longitude
        if let load_longitude = UserDefaults.standard.string(forKey: "key_saved_longitude") {
            print(load_longitude)
            
            if (self.str_location_type == "1") {
                self.str_from_longitude = load_longitude
            } else {
                self.str_to_longitude = load_longitude
            }
            
        }
        
        // address
        if let load_address = UserDefaults.standard.string(forKey: "key_saved_address") {
            print(load_address)
            
            if (self.str_location_type == "1") {
                self.str_from_location = load_address
            } else {
                self.str_to_location = load_address
            }
            
        }
        
        UserDefaults.standard.set("", forKey: "key_saved_latitude")
        UserDefaults.standard.set("", forKey: "key_saved_longitude")
        UserDefaults.standard.set("", forKey: "key_saved_address")
        
        print(self.str_from_latitude as Any)
        print(self.str_from_longitude as Any)
        print(self.str_from_location as Any)
        print(self.str_to_latitude as Any)
        print(self.str_to_longitude as Any)
        print(self.str_to_location as Any)
        
        self.tbleView.reloadData()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func from_location_click_method() {
        self.str_location_type = "1"
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "map_view_id") as? map_view
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func to_location_click_method() {
        self.str_location_type = "2"
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "map_view_id") as? map_view
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    
    @objc func working_hour_from_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! set_location_hour_table_cell
        
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { (selectedDate) in
            // TODO: Your implementation for date
            cell.txt_working_hour_from.text = selectedDate.dateString("hh:mm")
        })
    }
    
    @objc func working_hour_to_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! set_location_hour_table_cell
        //
        
        /*timePicker.datePickerMode = UIDatePicker.Mode.time
        timePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height/2 + 60), width: self.view.frame.width, height: 150.0)
        timePicker.backgroundColor = UIColor.white
        self.view.addSubview(timePicker)
        timePicker.addTarget(self, action: #selector(startTimeDiveChanged), for: .valueChanged)*/
        
        RPicker.selectDate(title: "Select Time", cancelText: "Cancel", datePickerMode: .time, didSelectDate: { (selectedDate) in
            // TODO: Your implementation for date
            cell.txt_working_hour_to.text = selectedDate.dateString("HH:MM")
        })
    }
    
    @objc func startTimeDiveChanged(sender: UIDatePicker) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! set_location_hour_table_cell
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        cell.txt_working_hour_to.text = formatter.string(from: sender.date)
        timePicker.removeFromSuperview() // if you want to remove time picker
    }
    
    @objc func working_time_from_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! set_location_hour_table_cell
        
        RPicker.selectDate(title: "Select Date", minDate: Date(), maxDate: Date().dateByAddingYears(30), didSelectDate: { (selectedDate) in
            // TODO: Your implementation for date
            cell.txt_working_time_from.text = selectedDate.dateString("yyyy-MM-dd")
        })
    }
    
    @objc func working_time_to_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! set_location_hour_table_cell
        
        RPicker.selectDate(title: "Select Date", minDate: Date(), maxDate: Date().dateByAddingYears(30), didSelectDate: { (selectedDate) in
            // TODO: Your implementation for date
            cell.txt_working_time_to.text = selectedDate.dateString("yyyy-MM-dd")
        })
    }
    
    
    @objc func validation_before_accept_booking() {
        self.set_location_hour_WB(str_show_loader: "yes")
    }
    
    @objc func set_location_hour_WB(str_show_loader:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! set_location_hour_table_cell
        
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
                    "action"            : "editProfile",
                    "userId"            : String(myString),
                    
                    "pickupAddress"     : String(cell.txt_from_location.text!),
                    "dropAddress"       : String(cell.txt_to_location.text!),
                    
                    "drop_Longitude"    : String(self.str_to_longitude),
                    "drop_Latitude"     : String(self.str_to_latitude),
                    
                    "pickup_Latitude"   : String(self.str_from_latitude),
                    "pickup_Longitude"  : String(self.str_from_longitude),
                    
                    "Working_startDate" : String(cell.txt_working_time_from.text!),
                    "Working_endDate"   : String(cell.txt_working_time_to.text!),
                    
                    "Working_startTime" : String(cell.txt_working_hour_from.text!),
                    "Working_endTime"   : String(cell.txt_working_hour_to.text!),
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
                                print("TOKEN NOT RETURN IN THIS ACTION = editProfile")
                            } else {
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            }

                            self.get_login_user_full_data()
                            
                        } else if strSuccess == String("Success") {
                            print("yes")
                            
                            if (JSON["AuthToken"] == nil) {
                                print("TOKEN NOT RETURN IN THIS ACTION = editProfile")
                            } else {
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            }

                            self.get_login_user_full_data()
                            
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
                            
                            self.set_location_hour_WB(str_show_loader: "no")
                            
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
    
    @objc func get_login_user_full_data() {
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = payload_profile(action: "profile",
                                         userId: String(myString))
            
            print(params as Any)
            
            AF.request(application_base_url,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                // debugPrint(response.result)
                
                switch response.result {
                case let .success(value):
                    
                    let JSON = value as! NSDictionary
                    print(JSON as Any)
                    
                    var strSuccess : String!
                    strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                    
                    print(strSuccess as Any)
                    if strSuccess == String("success") {
                        print("yes")
                        ERProgressHud.sharedInstance.hide()
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(JSON["data"], forKey: str_save_login_user_data)
                        
                        let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (JSON["msg"] as! String), style: .alert)
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        
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

extension set_location_hour: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:set_location_hour_table_cell = tableView.dequeueReusableCell(withIdentifier: "set_location_hour_table_cell") as! set_location_hour_table_cell
            
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.backgroundColor = .white
            
        cell.txt_from_location.delegate = self
        cell.txt_to_location.delegate = self
        
        if (self.str_location_type != "0") {
            cell.txt_from_location.text = String(self.str_from_location)
            cell.txt_to_location.text = String(self.str_to_location)
        }
        
        /*if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
             
            self.str_to_longitude = (person["drop_Longitude"] as! String)
            self.str_to_latitude = (person["drop_Latitude"] as! String)
            
            self.str_from_latitude = (person["pickup_Latitude"] as! String)
            self.str_from_longitude = (person["pickup_Longitude"] as! String)
            
            cell.txt_from_location.text = (person["pickupAddress"] as! String)
            cell.txt_to_location.text = (person["dropAddress"] as! String)
            
            cell.txt_working_hour_from.text = (person["Working_endTime"] as! String)
            cell.txt_working_hour_to.text = (person["Working_startTime"] as! String)
            
            cell.txt_working_time_from.text = (person["Working_startDate"] as! String)
            cell.txt_working_time_to.text = (person["Working_endDate"] as! String)
        }*/
        
        
        cell.btn_working_hour_from.addTarget(self, action: #selector(working_hour_from_click_method), for: .touchUpInside)
        cell.btn_working_hour_to.addTarget(self, action: #selector(working_hour_to_click_method), for: .touchUpInside)
        
        cell.btn_working_time_from.addTarget(self, action: #selector(working_time_from_click_method), for: .touchUpInside)
        cell.btn_working_time_to.addTarget(self, action: #selector(working_time_to_click_method), for: .touchUpInside)
        
        cell.btn_from_location.addTarget(self, action: #selector(from_location_click_method), for: .touchUpInside)
        cell.btn_to_location.addTarget(self, action: #selector(to_location_click_method), for: .touchUpInside)
        
        cell.btn_save_details.addTarget(self, action: #selector(validation_before_accept_booking), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 434
    }
    
}

class set_location_hour_table_cell: UITableViewCell {
    
    @IBOutlet weak var btn_from_location:UIButton!
    @IBOutlet weak var btn_to_location:UIButton!
    
    @IBOutlet weak var txt_from_location:UITextField! {
        didSet {
            // shadow
            txt_from_location.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_from_location.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_from_location.layer.shadowOpacity = 1.0
            txt_from_location.layer.shadowRadius = 10.0
            txt_from_location.layer.masksToBounds = false
            txt_from_location.layer.cornerRadius = 12
            txt_from_location.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_from_location.frame.height))
            txt_from_location.leftView = paddingView
            txt_from_location.leftViewMode = UITextField.ViewMode.always
        }
    }
    @IBOutlet weak var txt_to_location:UITextField! {
        didSet {
            // shadow
            txt_to_location.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_to_location.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_to_location.layer.shadowOpacity = 1.0
            txt_to_location.layer.shadowRadius = 10.0
            txt_to_location.layer.masksToBounds = false
            txt_to_location.layer.cornerRadius = 12
            txt_to_location.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_to_location.frame.height))
            txt_to_location.leftView = paddingView
            txt_to_location.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var btn_working_hour_from:UIButton!
    @IBOutlet weak var txt_working_hour_from:UITextField! {
        didSet {
            // shadow
            txt_working_hour_from.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_working_hour_from.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_working_hour_from.layer.shadowOpacity = 1.0
            txt_working_hour_from.layer.shadowRadius = 10.0
            txt_working_hour_from.layer.masksToBounds = false
            txt_working_hour_from.layer.cornerRadius = 12
            txt_working_hour_from.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_working_hour_from.frame.height))
            txt_working_hour_from.leftView = paddingView
            txt_working_hour_from.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var btn_working_hour_to:UIButton!
    @IBOutlet weak var txt_working_hour_to:UITextField! {
        didSet {
            // shadow
            txt_working_hour_to.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_working_hour_to.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_working_hour_to.layer.shadowOpacity = 1.0
            txt_working_hour_to.layer.shadowRadius = 10.0
            txt_working_hour_to.layer.masksToBounds = false
            txt_working_hour_to.layer.cornerRadius = 12
            txt_working_hour_to.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_working_hour_to.frame.height))
            txt_working_hour_to.leftView = paddingView
            txt_working_hour_to.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var btn_working_time_from:UIButton!
    @IBOutlet weak var txt_working_time_from:UITextField! {
        didSet {
            // shadow
            txt_working_time_from.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_working_time_from.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_working_time_from.layer.shadowOpacity = 1.0
            txt_working_time_from.layer.shadowRadius = 10.0
            txt_working_time_from.layer.masksToBounds = false
            txt_working_time_from.layer.cornerRadius = 12
            txt_working_time_from.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_working_time_from.frame.height))
            txt_working_time_from.leftView = paddingView
            txt_working_time_from.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var btn_working_time_to:UIButton!
    @IBOutlet weak var txt_working_time_to:UITextField! {
        didSet {
            // shadow
            txt_working_time_to.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_working_time_to.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_working_time_to.layer.shadowOpacity = 1.0
            txt_working_time_to.layer.shadowRadius = 10.0
            txt_working_time_to.layer.masksToBounds = false
            txt_working_time_to.layer.cornerRadius = 12
            txt_working_time_to.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_working_time_to.frame.height))
            txt_working_time_to.leftView = paddingView
            txt_working_time_to.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var btn_save_details:UIButton! {
        didSet {
            btn_save_details.setTitle("Update", for: .normal)
            btn_save_details.setTitleColor(.white, for: .normal)
            btn_save_details.layer.cornerRadius = 6
            btn_save_details.clipsToBounds = true
            btn_save_details.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
            
            // shadow
            btn_save_details.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_save_details.layer.shadowOffset = CGSize(width: 0, height: 3)
            btn_save_details.layer.shadowOpacity = 1.0
            btn_save_details.layer.shadowRadius = 10.0
            btn_save_details.layer.masksToBounds = false
            
        }
    }
    
}
