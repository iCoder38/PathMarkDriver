//
//  add_contacts.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 11/08/23.
//

import UIKit
import Alamofire

class add_contacts: UIViewController , UITextFieldDelegate {

    var dict_emergency:NSDictionary!
    
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
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var txt_full_name:UITextField! {
        didSet {
            // shadow
            txt_full_name.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_full_name.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_full_name.layer.shadowOpacity = 1.0
            txt_full_name.layer.shadowRadius = 10.0
            txt_full_name.layer.masksToBounds = false
            txt_full_name.layer.cornerRadius = 12
            txt_full_name.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_full_name.frame.height))
            txt_full_name.leftView = paddingView
            txt_full_name.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var txt_email:UITextField! {
        didSet {
            // shadow
            txt_email.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_email.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_email.layer.shadowOpacity = 1.0
            txt_email.layer.shadowRadius = 10.0
            txt_email.layer.masksToBounds = false
            txt_email.layer.cornerRadius = 12
            txt_email.backgroundColor = .white
            txt_email.keyboardType = .emailAddress
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_email.frame.height))
            txt_email.leftView = paddingView
            txt_email.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var txt_phone:UITextField! {
        didSet {
            // shadow
            txt_phone.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_phone.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_phone.layer.shadowOpacity = 1.0
            txt_phone.layer.shadowRadius = 10.0
            txt_phone.layer.masksToBounds = false
            txt_phone.layer.cornerRadius = 12
            txt_phone.backgroundColor = .white
            txt_phone.keyboardType = .numberPad
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_phone.frame.height))
            txt_phone.leftView = paddingView
            txt_phone.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var btn_relation:UIButton!
    @IBOutlet weak var txt_relation:UITextField! {
        didSet {
            // shadow
            txt_relation.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_relation.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_relation.layer.shadowOpacity = 1.0
            txt_relation.layer.shadowRadius = 10.0
            txt_relation.layer.masksToBounds = false
            txt_relation.layer.cornerRadius = 12
            txt_relation.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_relation.frame.height))
            txt_relation.leftView = paddingView
            txt_relation.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
            btn_submit.setTitle("SUBMIT", for: .normal)
            btn_submit.setTitleColor(.white, for: .normal)
            btn_submit.layer.cornerRadius = 6
            btn_submit.clipsToBounds = true
            btn_submit.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
            
            // shadow
            btn_submit.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_submit.layer.shadowOffset = CGSize(width: 0, height: 3)
            btn_submit.layer.shadowOpacity = 1.0
            btn_submit.layer.shadowRadius = 10.0
            btn_submit.layer.masksToBounds = false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.btn_submit.addTarget(self, action: #selector(check_validate), for: .touchUpInside)
        
        if (self.dict_emergency == nil) {
            print("add contact")
            self.view_navigation_title.text = "NEW CONTACTS"
            
        } else {
            print("edit contact")
            self.view_navigation_title.text = "EDIT CONTACTS"
            
            self.txt_full_name.text = (self.dict_emergency["Name"] as! String)
            self.txt_email.text = (self.dict_emergency["email"] as! String)
            self.txt_phone.text = (self.dict_emergency["phone"] as! String)
            self.txt_relation.text = (self.dict_emergency["relation"] as! String)
        }
        
        self.btn_relation.addTarget(self, action: #selector(open_relation_drop_down), for: .touchUpInside)
        
    }
    
    @objc func open_relation_drop_down() {
        var arr_relation = ["Friend", "Family", "Other"]
        
        RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: arr_relation, selectedIndex: 0) { (selctedText, atIndex) in
            self.txt_relation.text = String(selctedText)
             
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    @objc func check_validate() {
        if (self.dict_emergency == nil) {
            print("add contact")
            self.add_emergency_phone()
        } else {
            print("edit contact")
            self.check_edit_or_add_contact_WB()
        }
    }
    @objc func check_edit_or_add_contact_WB() {
        
        // self.show_loading_UI()
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "editing...")
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                     "token":String(token_id_is),
                ]
                parameters = [
                    "action"    : "emergencyadd",
                    "addressId"   : "\(self.dict_emergency["emergencyId"]!)",
                    "userId"    : String(myString),
                    "Name"      : String(self.txt_full_name.text!),
                    "phone"     : String(self.txt_phone.text!),
                    "relation"  : String(self.txt_relation.text!),
                    "email"     : String(self.txt_email.text!),
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
                            // self.hide_loading_UI()
                            
                            if strSuccess.lowercased() == "success" {
                                
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                                
                                ERProgressHud.sharedInstance.hide()
                                self.back_click_method()

                            }
                            else {
                                print("two")
                                ERProgressHud.sharedInstance.hide()
                                self.hide_loading_UI()
                            }
                            
                        }
                        
                    case .failure(_):
                        print("Error message:\(String(describing: response.error))")
                        self.hide_loading_UI()
                        self.please_check_your_internet_connection()
                        
                        break
                    }
                }
            }
        }
    }
    
    @objc func add_emergency_phone() {
        
        // self.show_loading_UI()
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                     "token":String(token_id_is),
                ]
                parameters = [
                    "action"    : "emergencyadd",
                    "userId"    : String(myString),
                    "Name"      : String(self.txt_full_name.text!),
                    "phone"     : String(self.txt_phone.text!),
                    "relation"  : String(self.txt_relation.text!),
                    "email"     : String(self.txt_email.text!),
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
                            // self.hide_loading_UI()
                            
                            if strSuccess.lowercased() == "success" {
                                
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                                
                                ERProgressHud.sharedInstance.hide()
                                self.back_click_method()

                            }
                            else {
                                print("two")
                                ERProgressHud.sharedInstance.hide()
                                self.hide_loading_UI()
                            }
                            
                        }
                        
                    case .failure(_):
                        print("Error message:\(String(describing: response.error))")
                        self.hide_loading_UI()
                        self.please_check_your_internet_connection()
                        
                        break
                    }
                }
            }
        }
    }
    
}
