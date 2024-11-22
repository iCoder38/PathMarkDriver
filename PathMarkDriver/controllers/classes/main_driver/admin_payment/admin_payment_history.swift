//
//  admin_payment_history.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 21/11/24.
//

import UIKit
import Alamofire
import SDWebImage

class admin_payment_history: UIViewController {
    
    var str_user_select:String! = "TODAY"
    
    var arr_earnings:NSMutableArray! = []
    
    var page : Int! = 1
    var loadMore : Int! = 1;
    
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
                    view_navigation_title.text = "Admin payment history"
                } else {
                    view_navigation_title.text = "অ্যাডমিন পেমেন্ট ইতিহাস"
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
    @IBOutlet weak var btn_cashout:UIButton! {
        didSet {
            btn_cashout.layer.cornerRadius = 12
            btn_cashout.clipsToBounds = true
            btn_cashout.backgroundColor = navigation_color
            
            btn_cashout.setTitleColor(.white, for: .normal)
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_cashout.setTitle("Cashout", for: .normal)
                } else {
                    btn_cashout.setTitle("উত্তোলন", for: .normal)
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
    
    @IBOutlet weak var lbl_total_earning:UILabel!
    @IBOutlet weak var lbl_day:UILabel! {
        didSet {
            //
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_day.text = "TODAY"
                } else {
                    lbl_day.text = "আজ"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_total_earning_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_total_earning_text.text = "Total earnings"
                } else {
                    lbl_total_earning_text.text = "মোট উপার্জন"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var btn_drop:UIButton!
    
    @IBOutlet weak var view_one:UIView! {
        didSet {
            view_one.layer.cornerRadius = 2
            view_one.clipsToBounds = true
            view_one.dropShadow()
        }
    }
    @IBOutlet weak var view_two:UIView! {
        didSet {
            view_two.layer.cornerRadius = 2
            view_two.clipsToBounds = true
            view_two.dropShadow()
        }
    }
    @IBOutlet weak var view_3:UIView! {
        didSet {
            view_3.layer.cornerRadius = 2
            view_3.clipsToBounds = true
            view_3.dropShadow()
        }
    }
    @IBOutlet weak var view_4:UIView! {
        didSet {
            view_4.layer.cornerRadius = 2
            view_4.clipsToBounds = true
            view_4.dropShadow()
        }
    }
    
    @IBOutlet weak var btnPay:UIButton! {
        didSet {
            btnPay.isHidden = true
            btnPay.addTarget(self, action: #selector(pay_click_method), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var lblAdminPayableAmountText:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lblAdminPayableAmountText.text = "Admin payable amount"
                } else {
                    lblAdminPayableAmountText.text = "অ্যাডমিন প্রদেয় পরিমাণ"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    @IBOutlet weak var lblAdminPayableAmount:UILabel! {
        didSet {
             
        }
    }
    
    var strStoreAmount:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        /*if let language = UserDefaults.standard.string(forKey: str_language_convert) {
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
        }*/
        
        self.sideBarMenu()
        
        // self.lbl_today_line.isHidden = false
        // self.lbl_week_line.isHidden = true
        
        // self.btn_today.addTarget(self, action: #selector(today_earning_click_method), for: .touchUpInside)
        // self.btn_week.addTarget(self, action: #selector(weekly_earning_click_method), for: .touchUpInside)
        
        // self.btn_drop.addTarget(self, action: #selector(days_drop), for: .touchUpInside)
        // self.btn_cashout.addTarget(self, action: #selector(cashout_click_method), for: .touchUpInside)
        
        // self.lbl_day.text = "TODAY"
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.arr_earnings.removeAllObjects()
        self.profileWB()
    }
    
    @objc func pay_click_method() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "pay_id") as! pay
        push.strAmount = String(self.strStoreAmount)
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    @objc func cashout_click_method() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "cashout_id") as! cashout
        self.navigationController?.pushViewController(push, animated: true)
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
        // self.earning_history(str_show_loader: "yes")
    }
    
    @objc func weekly_earning_click_method() {
        self.lbl_today_line.isHidden = true
        self.lbl_week_line.isHidden = false
        
        self.arr_earnings.removeAllObjects()
        self.str_user_select = "WEEK"
        // self.earning_history(str_show_loader: "yes", pageNumber: 1)
    }
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if scrollView == self.tbleView {
            let isReachingEnd = scrollView.contentOffset.y >= 0
                && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    self.earning_history(str_show_loader: "no", pageNumber: page)
                    
                }
            }
        }
    }*/
    
    @objc func profileWB() {
        
         
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "অপেক্ষা করুন")
                }
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
                var lan:String!
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        lan = "en"
                    } else {
                        lan = "bn"
                    }
                }
                    
                parameters = [
                    "action"    : "profile",
                    "userId"    : String(myString),
                    "language"  : String(lan),
                   
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
                            
                            // ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                           
                            let get_data = (JSON["data"] as! NSDictionary)
                            
                            let value = "\(get_data["wallet"]!)"
                            // let value = "-1" // testing porpose only
                            
                            if value.hasPrefix("-") {
                                let sign = "-"
                                let numericValue = value.dropFirst()
                                print("Sign: \(sign), Numeric Value: \(numericValue)")
                                
                                 if let walletValue = Double(numericValue) {
                                    //if let walletValue = Double("1") {
                                    // Format to 2 decimal places
                                    let formattedWallet = String(format: "%.2f", walletValue)
                                    print("Formatted Wallet Value: \(formattedWallet)")
                                    self.strStoreAmount = "\(formattedWallet)"
                                    self.lblAdminPayableAmount.text = "\(str_bangladesh_currency_symbol) \(formattedWallet)"
                                } else {
                                    print("Invalid number format")
                                }
                                
                                
                                
                                self.btnPay.isHidden = false
                            } else {
                                self.strStoreAmount = "\(str_bangladesh_currency_symbol) 0"
                                self.lblAdminPayableAmount.text = "\(str_bangladesh_currency_symbol) 0"
                                self.btnPay.isHidden = true
                                
                            }
                            
                           
                            self.earning_history(str_show_loader: "no", pageNumber: 1)
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb2()
                            
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
    
    @objc func login_refresh_token_wb2() {
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let get_login_details = UserDefaults.standard.value(forKey: str_save_email_password) as? [String:Any] {
            print(get_login_details as Any)
            
            if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                
                let x : Int = person["userId"] as! Int
                let myString = String(x)
                
                parameters = [
                    "action"    : "gettoken",
                    "userId"    : String(myString),
                    "email"     : (get_login_details["email"] as! String),
                    "role"      : (person["role"] as! String)
                ]
            }
            
            print("parameters-------\(String(describing: parameters))")
            
            AF.request(application_base_url, method: .post, parameters: parameters as? Parameters).responseJSON { [self]
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
                            
                            self.earning_history(str_show_loader: "no", pageNumber: page)
                            
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
    
    @objc func earning_history(str_show_loader:String,pageNumber: Int) {
        
        if (str_show_loader == "yes") {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "অপেক্ষা করুন")
                }
            }
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
                var lan:String!
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        lan = "en"
                    } else {
                        lan = "bn"
                    }
                }
                parameters = [
                    "action"    : "upadteadminpaymentlist",
                    "userId"    : String(myString),
                    "language"  : String(lan),
                   
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
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arr_earnings.addObjects(from: ar as! [Any])
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            self.loadMore = 1
                            
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
            
            if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                
                let x : Int = person["userId"] as! Int
                let myString = String(x)
                
                parameters = [
                    "action"    : "gettoken",
                    "userId"    : String(myString),
                    "email"     : (get_login_details["email"] as! String),
                    "role"      : (person["role"] as! String)
                ]
            }
            
            print("parameters-------\(String(describing: parameters))")
            
            AF.request(application_base_url, method: .post, parameters: parameters as? Parameters).responseJSON { [self]
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
                            
                            self.earning_history(str_show_loader: "no", pageNumber: page)
                            
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
    
    @objc func days_drop() {
        
        
        let arr_year = ["ALL","TODAY","WEEKLY"]
        
        var int_index:Int! = 1
        
        if (self.lbl_day.text == "ALL") {
            int_index = 0
        } else if (self.lbl_day.text == "TODAY") {
            int_index = 1
        } else {
            int_index = 2
        }
        
        RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: arr_year, selectedIndex: int_index) { [self] (selctedText, atIndex) in
            self.lbl_day.text = String(selctedText)
            self.arr_earnings.removeAllObjects()
            self.earning_history(str_show_loader: "yes", pageNumber: page)
        }
    }
    
}


extension admin_payment_history: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_earnings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:admin_payment_history_table_cell = tableView.dequeueReusableCell(withIdentifier: "admin_payment_history_table_cell") as! admin_payment_history_table_cell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView

        cell.backgroundColor = .clear
        
        let item = self.arr_earnings[indexPath.row] as? [String:Any]
        // print(item as Any)
        /*
         PaymentMethod = BKash;
         adminpaymentId = 7;
         amount = "6.34";
         created = "Nov 7th, 2024, 12:01 am";
         status = 2;
         transactionId = BK790KV049;
         */
        
        cell.lbl_user_name.text = "\(item!["created"]!)"
        
        cell.lbl_time.text = "\(str_bangladesh_currency_symbol) \(item!["amount"]!)"
        cell.lbl_payment_type.text = "\(item!["PaymentMethod"]!)"
        cell.lbl_payment_type.backgroundColor = .green
        
        if "\(item!["status"]!)" == "1" {
            if "\(item!["PaymentMethod"]!)" == "BKash" {
                cell.lbl_amount.text = "Approved"
                cell.lbl_amount.textColor = .systemGreen
            } else {
                cell.lbl_amount.text = "Pending"
                cell.lbl_amount.textColor = .red
            }
            
        } else {
            cell.lbl_amount.text = "Approved"
            cell.lbl_amount.textColor = .systemGreen
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

class admin_payment_history_table_cell: UITableViewCell {
    
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
    
    @IBOutlet weak var lbl_payment_type:UILabel!
    @IBOutlet weak var lbl_amount:UILabel!
    
    @IBOutlet weak var view_up:UIView! {
        didSet {
            view_up.layer.cornerRadius = 4
            view_up.clipsToBounds = true
            view_up.backgroundColor = .white
        }
    }
    @IBOutlet weak var view_down:UIView!  {
        didSet {
            view_down.layer.cornerRadius = 4
            view_down.clipsToBounds = true
            view_down.backgroundColor = .white
        }
    }
}
