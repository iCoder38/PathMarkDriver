//
//  edit_profile.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 07/11/23.
//

import UIKit
import Alamofire
import CryptoKit
import CommonCrypto
import JWTDecode

// MARK:- LOCATION -
import CoreLocation

class edit_profile: UIViewController , UITextFieldDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String!
    var strSaveLongitude:String!
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    var arr_country_array:NSArray!
    
    var str_country_name:String!
    
    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            view_navigation_title.text = "Edit Profile"
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_back:UIButton! {
        didSet {
            btn_back.tintColor = .white
        }
    }
    
    var str_token_id:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        sideBarMenu()
        //
        self.get_country_list_WB()
        
    }
    @objc func sideBarMenu() {
        
        if revealViewController() != nil {
            
            btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // get country list
    @objc func get_country_list_WB() {
        
        self.view.endEditing(true)
        
         ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = payload_country_list(action: "countrylist")
        
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
                    
                    self.arr_country_array = (JSON["data"] as! NSArray)
                    
                    if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                        print(person)
                        
                        // cell.txt_phone_code.text = (person["countryCode"] as! String)
                        for indexx in 0..<self.arr_country_array.count {
                            
                            let item = self.arr_country_array[indexx] as? [String:Any]
                            // print(item as Any)
                            
                            if (person["countryCode"] as! String == (item!["phonecode"] as! String)) {
                                print("yes matched")
                                print(item!["phonecode"] as! String)
                                
                                // cell.txt_phone_code.text = (item!["phonecode"] as! String)
                                self.str_country_name = (item!["name"] as! String)
                            }
                            
                        }
                    }
                    
                    ERProgressHud.sharedInstance.hide()
                    self.tbleView.delegate = self
                    self.tbleView.dataSource = self
                    self.tbleView.reloadData()
                    
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
    
    @objc func sign_up_WB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! edit_profile_table_cell
        
        self.view.endEditing(true)
        
        // self.show_loading_UI()
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        // let params = main_token(body: get_encrpyt_token)
        
        // print(cell.txt_country.text!)
        
        var phone_number_code : String!
        
        if (cell.txt_full_name.text! == "") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter full name"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        } else if (cell.txtEmailAddress.text! == "") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter email address"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        }else if (cell.txt_phone_number.text! == "") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter phone number"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        }  else if (cell.txt_nid_number.text! == "") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter nid number"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        }  else if (cell.txt_address.text! == "") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter address"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        }else if (cell.txt_country.text! == "") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter country name"), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        } else if (cell.txt_nid_number.text!.count < 17) {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter valid NID No."), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            ERProgressHud.sharedInstance.hide()
            
            return
            
        } else {
            
            for indexx in 0..<self.arr_country_array.count {
                
                let item = self.arr_country_array[indexx] as? [String:Any]
                print(item as Any)
                
                if (cell.txt_country.text! == (item!["name"] as! String)) {
                    print("yes matched")
                    phone_number_code = (item!["phonecode"] as! String)
                }
                
            }
            
        }
        
        if let device_token = UserDefaults.standard.string(forKey: "key_my_device_token") {
            
            self.str_token_id = String(device_token)
            
        }
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var parameters:Dictionary<AnyHashable, Any>!
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
                parameters = [
                    "action"        : "editprofile",
                    "userId"        : String(myString),
                    "fullName"      : String(cell.txt_full_name.text!),
                    "email"         : String(cell.txtEmailAddress.text!),
                    "countryCode"   : String(phone_number_code),
                    "role"          : "Driver",
                    "contactNumber" : String(cell.txt_phone_number.text!),
                    "INDNo"         : String(cell.txt_nid_number.text!),
                    "device"        : "iOS",
                    "address"       : String(cell.txt_address.text!),
                    "deviceToken"   : String(self.str_token_id)
                ]
                
                print(parameters as Any)
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON {
                    response in
                    
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
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(dict, forKey: str_save_login_user_data)
                            
                            let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (JSON["msg"] as! String), style: .alert)
                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            
                            // self.hide_loading_UI()
                            ERProgressHud.sharedInstance.hide()
                            
                            self.tbleView.reloadData()
                            // self.navigationController?.popViewController(animated: true)
                            
                        }  else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb()
                            
                        } else {
                            
                            print("no")
                            self.hide_loading_UI()
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
                        self.hide_loading_UI()
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
                            
                            self.sign_up_WB()
                            
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
    
    @objc func alert_warning () {
        
        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: "Field should not be empty.", style: .alert)
        let cancel = NewYorkButton(title: "Ok", style: .cancel)
        alert.addButtons([cancel])
        self.present(alert, animated: true)
        
    }
    
    @objc func before_open_popup() {
        self.country_click_method()
    }
    @objc func country_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! edit_profile_table_cell
        
        print(self.arr_country_array as Any)
        
        var arr_mut:NSMutableArray = []
        
        for index in 0..<self.arr_country_array.count {
            
            // print(self.arr_country_array[index])
            
            let item = self.arr_country_array[index] as? [String:Any]
            print(item as Any)
            
            arr_mut.add(item!["name"] as! String)
            
        }
        
        if let swiftArray = arr_mut as NSArray as? [String] {
            ERProgressHud.sharedInstance.hide()
            RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: swiftArray, selectedIndex: 0) { (selctedText, atIndex) in
                cell.txt_country.text = String(selctedText)
                
                //
                for indexx in 0..<self.arr_country_array.count {
                    
                    let item = self.arr_country_array[indexx] as? [String:Any]
                    // print(item as Any)
                    
                    if (cell.txt_country.text! == (item!["name"] as! String)) {
                        print("yes matched")
                        cell.txt_phone_code.text = (item!["phonecode"] as! String)
                    }
                    
                }
            }
        }
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! edit_profile_table_cell
        
       if textField == cell.txt_nid_number {
           
           guard let textFieldText = textField.text,
               let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                   return false
           }
           let substringToReplace = textFieldText[rangeOfTextToReplace]
           let count = textFieldText.count - substringToReplace.count + string.count
           return count <= 17
       }
        
        return true
    }
    
}

extension edit_profile: UITableViewDataSource  , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:edit_profile_table_cell = tableView.dequeueReusableCell(withIdentifier: "edit_profile_table_cell") as! edit_profile_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.txtEmailAddress.delegate = self
         
        cell.txt_address.delegate = self
        cell.txt_full_name.delegate = self
        cell.txt_address.delegate = self
        cell.txt_nid_number.delegate = self
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            cell.txtEmailAddress.text = (person["email"] as! String)
            cell.txt_full_name.text = (person["fullName"] as! String)
            cell.txt_nid_number.text = (person["INDNo"] as! String)
            cell.txt_phone_number.text = (person["contactNumber"] as! String)
            cell.txt_phone_code.text = (person["countryCode"] as! String)
            cell.txt_address.text = (person["address"] as! String)
            cell.txt_country.text = String(self.str_country_name)
        }
        
        cell.btnSignUp.backgroundColor = UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1)
        cell.btnSignUp.isUserInteractionEnabled = true
        
        cell.btnSignUp.addTarget(self, action: #selector(sign_up_click_method), for: .touchUpInside)
        
        cell.btn_country.addTarget(self, action: #selector(before_open_popup), for: .touchUpInside)
        
        return cell
    }
    
    // 989013037178
    // VLMBIP
    
    @objc func sign_up_click_method() {
        
        self.sign_up_WB()
    }
    
    @objc func accept_terms_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! edit_profile_table_cell
        
        if cell.btn_accept_terms.tag == 1 {
            
            cell.btn_accept_terms.setImage(UIImage(named: "un_check"), for: .normal)
            cell.btn_accept_terms.tag = 0
            cell.btnSignUp.backgroundColor = .lightGray
            cell.btnSignUp.isUserInteractionEnabled = false
            
        } else {
            
            cell.btn_accept_terms.tag = 1
            cell.btn_accept_terms.setImage(UIImage(named: "check"), for: .normal)
            cell.btnSignUp.backgroundColor = UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1)
            cell.btnSignUp.isUserInteractionEnabled = true
            
        }
        
    }
    
    @objc func btnForgotPasswordPress() {
        
//        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPassword") as? ForgotPassword
//        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func signInClickMethod() {
        
//        self.login_WB()
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UPDSAddressId")
         self.navigationController?.pushViewController(push, animated: true)*/
    }
    
    @objc func dontHaveAntAccountClickMethod() {
        
//        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegistraitonId") as? Registraiton
//        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1200
    }
    
}

class edit_profile_table_cell: UITableViewCell {

    @IBOutlet weak var header_full_view_navigation_bar:UIView! {
        didSet {
            header_full_view_navigation_bar.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var header_half_view_navigation_bar:UIView! {
        didSet {
            header_half_view_navigation_bar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var img_upload:UIImageView! {
        didSet {
            img_upload.layer.cornerRadius = 12
            img_upload.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var bgColor:UIImageView!
    
    @IBOutlet weak var viewBGForUpperImage:UIView! {
        didSet {
            viewBGForUpperImage.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_country:UIButton!
    
    @IBOutlet weak var txt_country:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_country,
                              tfName: txt_country.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .emailAddress,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Country")
            
            txt_country.layer.masksToBounds = false
            txt_country.layer.shadowColor = UIColor.black.cgColor
            txt_country.layer.shadowOffset =  CGSize.zero
            txt_country.layer.shadowOpacity = 0.5
            txt_country.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txtEmailAddress:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtEmailAddress,
                              tfName: txtEmailAddress.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .emailAddress,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Email Address")
            
            txtEmailAddress.layer.masksToBounds = false
            txtEmailAddress.layer.shadowColor = UIColor.black.cgColor
            txtEmailAddress.layer.shadowOffset =  CGSize.zero
            txtEmailAddress.layer.shadowOpacity = 0.5
            txtEmailAddress.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txtPassword:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtPassword,
                              tfName: txtPassword.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Password")
            
            txtPassword.layer.masksToBounds = false
            txtPassword.layer.shadowColor = UIColor.black.cgColor
            txtPassword.layer.shadowOffset =  CGSize.zero
            txtPassword.layer.shadowOpacity = 0.5
            txtPassword.layer.shadowRadius = 2
            
        }
    }
    
    //
    @IBOutlet weak var txt_full_name:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_full_name,
                              tfName: txt_full_name.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Full name")
            
            txt_full_name.layer.masksToBounds = false
            txt_full_name.layer.shadowColor = UIColor.black.cgColor
            txt_full_name.layer.shadowOffset =  CGSize.zero
            txt_full_name.layer.shadowOpacity = 0.5
            txt_full_name.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txt_phone_code:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_phone_code,
                              tfName: txt_phone_code.text!,
                              tfCornerRadius: 12,
                              tfpadding: 0,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .numberPad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "+91")
            
            txt_phone_code.layer.masksToBounds = false
            txt_phone_code.layer.shadowColor = UIColor.black.cgColor
            txt_phone_code.layer.shadowOffset =  CGSize.zero
            txt_phone_code.layer.shadowOpacity = 0.5
            txt_phone_code.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txt_phone_number:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_phone_number,
                              tfName: txt_phone_number.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .numberPad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Phone Number")
            
            txt_phone_number.layer.masksToBounds = false
            txt_phone_number.layer.shadowColor = UIColor.black.cgColor
            txt_phone_number.layer.shadowOffset =  CGSize.zero
            txt_phone_number.layer.shadowOpacity = 0.5
            txt_phone_number.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txt_nid_number:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_nid_number,
                              tfName: txt_nid_number.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .numberPad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "NID No.")
            
            txt_nid_number.layer.masksToBounds = false
            txt_nid_number.layer.shadowColor = UIColor.black.cgColor
            txt_nid_number.layer.shadowOffset =  CGSize.zero
            txt_nid_number.layer.shadowOpacity = 0.5
            txt_nid_number.layer.shadowRadius = 2
            
            txt_nid_number.attributedPlaceholder = NSAttributedString(
                string: "NID No.",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            
        }
    }
    
    @IBOutlet weak var txt_address:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_address,
                              tfName: txt_address.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Address")
            
            txt_address.layer.masksToBounds = false
            txt_address.layer.shadowColor = UIColor.black.cgColor
            txt_address.layer.shadowOffset =  CGSize.zero
            txt_address.layer.shadowOpacity = 0.5
            txt_address.layer.shadowRadius = 2
            
        }
    }
    
    
    @IBOutlet weak var btn_accept_terms:UIButton! {
        didSet {
            btn_accept_terms.backgroundColor = .clear
            btn_accept_terms.tag = 0
            btn_accept_terms.setImage(UIImage(named: "un_check"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnSignIn:UIButton! {
        didSet {
             
            Utils.buttonStyle(button: btnSignIn,
                              bCornerRadius: 12,
                              bBackgroundColor: .lightGray,
                              bTitle: "Sign In",
                              bTitleColor: .black)
        }
    }
    
    @IBOutlet weak var btnSignUp:UIButton! {
        didSet {
            btnSignUp.isUserInteractionEnabled = false
            Utils.buttonStyle(button: btnSignUp,
                              bCornerRadius: 12,
                              bBackgroundColor: .lightGray,
                              bTitle: "Update",
                              bTitleColor: .black)
            
            btnSignUp.layer.masksToBounds = false
            btnSignUp.layer.shadowColor = UIColor.black.cgColor
            btnSignUp.layer.shadowOffset =  CGSize.zero
            btnSignUp.layer.shadowOpacity = 0.5
            btnSignUp.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var btn_update_vehicle:UIButton! {
        didSet {
            btn_update_vehicle.isUserInteractionEnabled = false
            Utils.buttonStyle(button: btn_update_vehicle,
                              bCornerRadius: 12,
                              bBackgroundColor: .lightGray,
                              bTitle: "Update Vehicle Details",
                              bTitleColor: .black)
            
            btn_update_vehicle.layer.masksToBounds = false
            btn_update_vehicle.layer.shadowColor = UIColor.black.cgColor
            btn_update_vehicle.layer.shadowOffset =  CGSize.zero
            btn_update_vehicle.layer.shadowOpacity = 0.5
            btn_update_vehicle.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var btnSaveAndContinue:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnSaveAndContinue,
                              bCornerRadius: 6,
                              bBackgroundColor: .black,
                              bTitle: "Sign In",
                              bTitleColor: .white)
        }
    }
    
    @IBOutlet weak var btn_disclaimer:UIButton! {
        didSet {
            Utils.buttonStyle(button: btn_disclaimer,
                              bCornerRadius: 17,
                              bBackgroundColor: navigation_color,
                              bTitle: "Disclaimer", bTitleColor: .white)
        }
    }
    
    
    @IBOutlet weak var btnForgotPassword:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnForgotPassword,
                              bCornerRadius: 6,
                              bBackgroundColor: .clear,
                              bTitle: "Forgot Password ? - Click here",
                              bTitleColor: navigation_color)
        }
    }
    
    @IBOutlet weak var btnDontHaveAnAccount:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnDontHaveAnAccount, bCornerRadius: 6, bBackgroundColor: .clear, bTitle: "Don't have an Account - Sign Up", bTitleColor: UIColor(red: 87.0/255.0, green: 77.0/255.0, blue: 112.0/255.0, alpha: 1))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

