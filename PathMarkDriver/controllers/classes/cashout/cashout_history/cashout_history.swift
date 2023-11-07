//
//  cashout_history.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 07/11/23.
//

import UIKit
import Alamofire

class cashout_history: UIViewController {

    var arr_cashout_history:NSMutableArray! = []
    
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
            view_navigation_title.text = "Cashout History"
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            
            // tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.cashout_history_WB(str_show_loader: "yes")
    }
    
    @objc func cashout_history_WB(str_show_loader:String) {

        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
            if (str_show_loader == "yes") {
                ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            }
            
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                     "token":String(token_id_is),
                ]
                
                parameters = [
                    "action"    : "cashoutlist",
                    "userId"     : String(myString),
                    "pageNo" : "1"
                ]
                
                print(headers)
                print("parameters-------\(String(describing: parameters))")
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON {
                    response in
                    
                    switch(response.result) {
                    case .success(_):
                        if let data = response.value {
                            
                            let JSON = data as! NSDictionary
                            print(JSON)
                            
                            var strSuccess : String!
                            strSuccess = JSON["status"] as? String
                            
                            if strSuccess.lowercased() == "success" {
                                ERProgressHud.sharedInstance.hide()
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arr_cashout_history.addObjects(from: ar as! [Any])

                                if (JSON["AuthToken"] == nil) {
                                    print("TOKEN NOT RETURN IN THIS ACTION = cashoutlist")
                                } else {
                                    let str_token = (JSON["AuthToken"] as! String)
                                    UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                    UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                                }
                                self.tbleView.delegate = self
                                self.tbleView.dataSource = self
                                self.tbleView.reloadData()
                            }
                            else {
                                self.login_refresh_token_wb()
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
    
    @objc func login_refresh_token_wb() {
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let get_login_details = UserDefaults.standard.value(forKey: str_save_email_password) as? [String:Any] {
            print(get_login_details as Any)
            
            parameters = [
                "action"    : "login",
                "email"     : (get_login_details["email"] as! String),
                "password"  : (get_login_details["password"] as! String),
            ]
            //        }
            
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
                            
                            
                            self.cashout_history_WB(str_show_loader: "no")
                            
                            
                        }
                        else {
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


extension cashout_history: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.arr_cashout_history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:cashout_history_table_cell = tableView.dequeueReusableCell(withIdentifier: "cashout_history_table_cell") as! cashout_history_table_cell
            
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.backgroundColor = .clear
         
        /* pending
         created = "2023-11-07 07:14:00";
         requestAmount = 1;
         requestId = 15;
         sendAmount = "";
         sendDate = "";
         */
        /*
         created = "2023-11-07 07:14:00";
         requestAmount = 1;
         requestId = 15;
         sendAmount = 1;
         sendDate = "2023-11-07 00:00:00";
         */
        
        let item = self.arr_cashout_history[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        cell.lbl_time.text = (item!["created"] as! String)
        cell.lbl_amount.text = "Amount : \(str_bangladesh_currency_symbol)\(item!["requestAmount"]!)"
        
        if (item!["sendDate"] as! String == "") {
            cell.btn_pending.backgroundColor = .lightGray
            cell.btn_pending.setTitle("Pending", for: .normal)
        } else {
            cell.btn_pending.backgroundColor = .systemGreen
            cell.btn_pending.setTitle("Done", for: .normal)
        }
        
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
}

class cashout_history_table_cell: UITableViewCell {
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.backgroundColor = .white
            
            // shadow
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 10.0
            view_bg.layer.masksToBounds = false
            view_bg.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var lbl_time:UILabel!
    @IBOutlet weak var lbl_amount:UILabel!
    
    @IBOutlet weak var btn_pending:UIButton! {
        didSet {
            btn_pending.layer.cornerRadius = 12
            btn_pending.clipsToBounds = true
        }
    }
    
}
