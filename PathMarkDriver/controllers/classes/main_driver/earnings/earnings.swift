//
//  earnings.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 06/09/23.
//

import UIKit
import Alamofire
import SDWebImage

class earnings: UIViewController {

    var str_user_select:String! = "TODAY"
    
    var arr_earnings:NSMutableArray! = []
    
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
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "Earnings"
                } else {
                    view_navigation_title.text = "উপার্জন"
                }
                
             
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_today:UIButton! {
        didSet {
            btn_today.setTitleColor(.black, for: .normal)
            btn_today.tag = 0
            btn_today.backgroundColor = UIColor.init(red: 250.0/255.0, green: 218.0/255.0, blue: 78.0/255.0, alpha: 1)
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_today.setTitle("Today", for: .normal)
                } else {
                    btn_today.setTitle("আজকের", for: .normal)
                }
                
             
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    @IBOutlet weak var btn_week:UIButton! {
        didSet {
            btn_week.setTitleColor(.black, for: .normal)
            btn_week.tag = 0
            btn_week.backgroundColor = UIColor.init(red: 250.0/255.0, green: 218.0/255.0, blue: 78.0/255.0, alpha: 1)
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_week.setTitle("Weekly", for: .normal)
                } else {
                    btn_week.setTitle("সাপ্তাহিক", for: .normal)
                }
                
             
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_today_line:UILabel! {
        didSet {
            lbl_today_line.backgroundColor = .black
        }
    }
    @IBOutlet weak var lbl_week_line:UILabel! {
        didSet {
            lbl_week_line.backgroundColor = .black
        }
    }
    
    @IBOutlet weak var lbl_my_earnings:UILabel!
    @IBOutlet weak var lbl_my_earnings_text:UILabel!
    @IBOutlet weak var lbl_spend_time:UILabel!
    @IBOutlet weak var lbl_completed_trips:UILabel!
    @IBOutlet weak var lbl_completed_trips_text:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                lbl_my_earnings_text.text = "My Earnings"
                lbl_completed_trips_text.text = "Completed Trips"
            } else {
                lbl_my_earnings_text.text = "আমার উপার্জন"
                lbl_completed_trips_text.text = "ট্রিপ সম্পন্ন হয়েছে"
            }
            
         
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        self.sideBarMenu()
        
        self.lbl_today_line.isHidden = false
        self.lbl_week_line.isHidden = true
        
        self.btn_today.addTarget(self, action: #selector(today_earning_click_method), for: .touchUpInside)
        self.btn_week.addTarget(self, action: #selector(weekly_earning_click_method), for: .touchUpInside)
        
        self.str_user_select = "TODAY"
        self.earning_history(str_show_loader: "yes")
    }
    
    @objc func sideBarMenu() {
        
        if revealViewController() != nil {
            
            btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    @objc func today_earning_click_method() {
        self.lbl_today_line.isHidden = false
        self.lbl_week_line.isHidden = true
        
        self.arr_earnings.removeAllObjects()
        self.str_user_select = "TODAY"
        self.earning_history(str_show_loader: "yes")
    }
    
    @objc func weekly_earning_click_method() {
        self.lbl_today_line.isHidden = true
        self.lbl_week_line.isHidden = false
        
        self.arr_earnings.removeAllObjects()
        self.str_user_select = "WEEK"
        self.earning_history(str_show_loader: "yes")
    }
    
    @objc func earning_history(str_show_loader:String) {
        
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
                    "action"    : "earninghistory",
                    "userId"    : String(myString),
                    "usertype"  : String("Driver"),
                    "reportType"  : String(self.str_user_select),
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
                            self.dismiss(animated: true)
                            /*
                             status = success;
                             totalAmount = "947.0999999999999";
                             totalDriverAmount = "644.02";
                             totalRide = 15;
                             */
                            self.lbl_my_earnings.text = "\(JSON["totalDriverAmount"]!)"
                            // self.lbl_spend_time.text = "n.a."// "\(JSON["msg"]!)"
                            self.lbl_completed_trips.text = "\(JSON["totalRide"]!)"
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arr_earnings.addObjects(from: ar as! [Any])
                            
                            // print(self.arr_earnings.count as Any)
                            
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
                            
                            self.earning_history(str_show_loader: "no")
                            
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


extension earnings: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_earnings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:earnings_table_cell = tableView.dequeueReusableCell(withIdentifier: "earnings_table_cell") as! earnings_table_cell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView

        cell.backgroundColor = .clear
        
        let item = self.arr_earnings[indexPath.row] as? [String:Any]
        cell.lbl_user_name.text = "\(item!["fullName"]!)"
        cell.lbl_distance.text = "\(item!["totalDistance"]!)"
        cell.lbl_time.text = "\(item!["created"]!)"
        
        cell.img_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_profile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo33"))
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                cell.lbl_distance_text.text = "Distance"
            } else {
                cell.lbl_distance_text.text = "দূরত্ব"
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
        tableView .deselectRow(at: indexPath, animated: true)
 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           
        return 80
    }
    
}

class earnings_table_cell: UITableViewCell {
    
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
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.layer.cornerRadius = 30
            img_profile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_user_name:UILabel!
    @IBOutlet weak var lbl_distance:UILabel!
    @IBOutlet weak var lbl_distance_text:UILabel!
    @IBOutlet weak var lbl_time:UILabel!
    
    
}
