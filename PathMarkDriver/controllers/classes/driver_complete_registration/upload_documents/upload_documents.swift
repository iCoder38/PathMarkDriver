//
//  upload_documents.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 17/07/23.
//

import UIKit
import CryptoKit
import JWTDecode
import Alamofire

class upload_documents: UIViewController {
    
    var str_for_update:String!
    
    var str_driving_license:String! = "0"
    var str_vehicle_insurance:String! = "0"
    var str_vehicle_registration_permit:String! = "0"
    var str_vehicle_registration_four:String! = "0"
    var str_tax_permit:String! = "0"
    
    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var btn_back:UIButton! {
        didSet {
            btn_back.tintColor = .white
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "Upload Documents"
                } else {
                    view_navigation_title.text = "নথি আপলোড করুন"
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
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tbleView.separatorColor = .clear
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var sum = 0
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            // print(person as Any)
            
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "checking...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "পরীক্ষা করা...")
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            // # 1 = driving license
            if (person["drivingLicenceNo"] as! String == "") {

                print("==============================")
                print("Driving license is not done")
                print("==============================")
                
            } else {
                
                print("==============================")
                print("Driving license is done")
                print("==============================")
                sum += 1
            }
            
            // # 2 : insurance company
            let arr_mut_order_history:NSMutableArray! = []
            var ar : NSArray!
            
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            if (arr_mut_order_history.count == 0) {
                
                print("==============================")
                print("Vehicle is not Registered")
                print("==============================")
                
            } else {
                
                let item = arr_mut_order_history[0] as? [String:Any]
                
                // # 2 : insurance company
                if (item!["isurenceCompony"] as! String) == "" {
                    
                    print("==============================")
                    print("Insurance is not done")
                    print("==============================")
                    
                } else {
                    
                    print("==============================")
                    print("Insurance is done")
                    print("==============================")
                    sum += 1
                }
                
                //  # 2 : insurance company
                if (item!["vehiclePermitIsssuesDate"] as! String) == "" {
                    
                    print("==============================")
                    print("Permit is not done")
                    print("==============================")
                    
                } else {
                    
                    print("==============================")
                    print("Permit is done")
                    print("==============================")
                    sum += 1
                }
                
                //  # 3 : Regsitration state
                if (item!["registration_state"] as! String) == "" {
                    
                    print("==============================")
                    print("Registration State is not done")
                    print("==============================")
                    
                } else {
                    
                    print("==============================")
                    print("Registration State is done")
                    print("==============================")
                    sum += 1
                }
                
                //  # 4 : TAX TOKEN
                if (item!["taxTokenImage"] as! String) == "" {
                    
                    print("==============================")
                    print("Tax Token is not done")
                    print("==============================")
                    
                } else {
                    
                    print("==============================")
                    print("Tax Token State is done")
                    print("==============================")
                    sum += 1
                }
                
            }
            
            // print(sum as Any)
            
        }
        
        if (sum == 5) {
            ERProgressHud.sharedInstance.hide()
            if (self.str_for_update != "yes") {
                self.push_to_success()
                
                self.btn_back.isHidden = true
                self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
            } else {
                self.sideBarMenu()
                self.btn_back.isHidden = false
                
            }
            
        } else {
            //
            ERProgressHud.sharedInstance.hide()
            self.tbleView.reloadData()
        }
        
 
    }
    
    @objc func sideBarMenu() {
        
        if revealViewController() != nil {
            self.btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
    
    @objc func push_to_success() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "success_registration_id") as? success_registration
        self.navigationController?.pushViewController(push!, animated: true)
    }

    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_vehicle_license_id") as? upload_vehicle_license
        
        if (self.str_for_update == "yes") {
            push!.str_for_profile = "yes"
        } else {
            push!.str_for_profile = "no"
        }
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc
    func insurance_click_method(sender:UITapGestureRecognizer) {
        print("tap working")
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
             print(person as Any)
            
            let arr_mut_order_history:NSMutableArray! = []
            var ar : NSArray!
            
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            if (arr_mut_order_history.count == 0) {
                
                self.upload_vehicle_insurance_WB()
                
            } else {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_vehicle_insurance_id") as? upload_vehicle_insurance
                if (self.str_for_update == "yes") {
                    push!.str_for_profile = "yes"
                } else {
                    push!.str_for_profile = "no"
                }
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
        }
    }
    
    
    @objc
    func reg_permit_click_method(sender:UITapGestureRecognizer) {
        print("tap working")
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            // print(person as Any)
            
            let arr_mut_order_history:NSMutableArray! = []
            var ar : NSArray!
            
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            if (arr_mut_order_history.count == 0) {
                
                let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please upload Vehicle Insurance first."), style: .alert)
                let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                alert.addButtons([cancel])
                self.present(alert, animated: true)
                
            } else {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_reg_permit_id") as? upload_reg_permit
                if (self.str_for_update == "yes") {
                    push!.str_for_profile = "yes"
                } else {
                    push!.str_for_profile = "no"
                }
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
    }
    
    @objc
    func vehicle_reg_four_click_method(sender:UITapGestureRecognizer) {
        print("tap working")
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            // print(person as Any)
            
            let arr_mut_order_history:NSMutableArray! = []
            var ar : NSArray!
            
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            if (arr_mut_order_history.count == 0) {
                
                let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please upload Vehicle Insurance first."), style: .alert)
                let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                alert.addButtons([cancel])
                self.present(alert, animated: true)
                
            } else {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_vehicle_reg_document_id") as? upload_vehicle_reg_document
                if (self.str_for_update == "yes") {
                    push!.str_for_profile = "yes"
                } else {
                    push!.str_for_profile = "no"
                }
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
    }
    
    
    
    @objc
    func tax_click_method(sender:UITapGestureRecognizer) {
        print("tax tap working")
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            // print(person as Any)
            
            let arr_mut_order_history:NSMutableArray! = []
            var ar : NSArray!
            
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            if (arr_mut_order_history.count == 0) {
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please upload Vehicle Insurance first."), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                    } else {
                        let alert = NewYorkAlertController(title: String("সতর্কতা").uppercased(), message: String("অনুগ্রহ করে প্রথমে যানবাহন বীমা আপলোড করুন।"), style: .alert)
                        let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                    }
                    
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                
                
                
            } else {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_tax_id") as? upload_tax
                if (self.str_for_update == "yes") {
                    push!.str_for_profile = "yes"
                } else {
                    push!.str_for_profile = "no"
                }
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
    }
    
    
    
    @objc
    func four_click_method(sender:UITapGestureRecognizer) {
        print("four tap working")
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            // print(person as Any)
            
            let arr_mut_order_history:NSMutableArray! = []
            var ar : NSArray!
            
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            if (arr_mut_order_history.count == 0) {
                
                
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please upload Vehicle Insurance first."), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                    } else {
                        let alert = NewYorkAlertController(title: String("সতর্কতা").uppercased(), message: String("অনুগ্রহ করে প্রথমে যানবাহন বীমা আপলোড করুন।"), style: .alert)
                        let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                    }
                    
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                
            } else {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_tax_id") as? upload_tax
                self.navigationController?.pushViewController(push!, animated: true)
            }
        }
    }
    
    
    
    /*@objc func create_dummy_car_info() {
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.show_gif_loader()
         
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)

            let params = payload_dummy_create_car_info(action: "addcarinformation",
                                                           userId: String(myString))

            print(params as Any)
            
            
            let secret = sha_token_api_key
            let privateKey = SymmetricKey(data: Data(secret.utf8))
            
            let headerJSONData = try! JSONEncoder().encode(Header())
            let headerBase64String = headerJSONData.urlSafeBase64EncodedString()
            
            let payloadJSONData = try! JSONEncoder().encode(params)
            let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()
            
            let toSign = Data((headerBase64String + "." + payloadBase64String).utf8)
            
            let signature = HMAC<SHA512>.authenticationCode(for: toSign, using: privateKey)
            let signatureBase64String = Data(signature).urlSafeBase64EncodedString()
            // print(signatureBase64String)
            
            let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")
            // print(token)
            // ERProgressHud.sharedInstance.hide()
            
            // send this token to server
            self.upload_vehicle_insurance_WB(get_encrpyt_token: token)
            
            // decode
            do {
                let jwt = try decode(jwt: token)
                print(jwt)
                
                print(type(of: jwt))
                
                
                print(jwt["body"])
            } catch {
                print("The file could not be loaded")
            }
            
            
        }
        
    }*/
    
    @objc func upload_vehicle_insurance_WB() {
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = payload_dummy_create_car_info(action: "addcarinformation",
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
                        
                        self.get_login_user_full_data()
                        
                    } else {
                        
                        print("no")
                        self.dismiss(animated: true)
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
                    self.dismiss(animated: true)
                    ERProgressHud.sharedInstance.hide()
                    
                    self.please_check_your_internet_connection()
                    
                }
            }
        }
    }
        
    /*@objc func get_user_profile_data() {

        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
             
            let params = payload_profile(action: "profile",
                                         userId: String(myString))
            
            print(params as Any)
            
            
            let secret = sha_token_api_key
            let privateKey = SymmetricKey(data: Data(secret.utf8))
            
            let headerJSONData = try! JSONEncoder().encode(Header())
            let headerBase64String = headerJSONData.urlSafeBase64EncodedString()
            
            let payloadJSONData = try! JSONEncoder().encode(params)
            let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()
            
            let toSign = Data((headerBase64String + "." + payloadBase64String).utf8)
            
            let signature = HMAC<SHA512>.authenticationCode(for: toSign, using: privateKey)
            let signatureBase64String = Data(signature).urlSafeBase64EncodedString()
            // print(signatureBase64String)
            
            let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")
            // print(token)
            // ERProgressHud.sharedInstance.hide()
            
            // send this token to server
            self.get_login_user_full_data(get_encrpyt_token: token)
            
            // decode
            do {
                let jwt = try decode(jwt: token)
                // print(jwt)
                
                print(type(of: jwt))
                
                
                print(jwt["body"])
            } catch {
                print("The file could not be loaded")
            }
            
            
        }
        
    }*/
    
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
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(JSON["data"], forKey: str_save_login_user_data)
                        
                        self.dismiss(animated: true)
                        ERProgressHud.sharedInstance.hide()
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_vehicle_license_id") as? upload_vehicle_license
                        self.navigationController?.pushViewController(push!, animated: true)
                        
                        
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

extension upload_documents: UITableViewDataSource  , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell:upload_documents_table_cell = tableView.dequeueReusableCell(withIdentifier: "driving_license") as! upload_documents_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if (self.str_driving_license == "0") {
                
                cell.lbl_driving_license_seaprator.isHidden = true
                cell.btn_driving_license_arrow.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            } else {
                
                cell.lbl_driving_license_seaprator.isHidden = false
                cell.btn_driving_license_arrow.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            }
            
            if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                print(person as Any)
                
                if (person["drivingLicenceNo"] as! String == "") {
                    
                    cell.btn_check_driving_license.setBackgroundImage(UIImage(named: "rem1"), for: .normal)
                } else {
                    self.str_driving_license = "1"
                    cell.lbl_driving_license_seaprator.isHidden = false
                    cell.btn_driving_license_arrow.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                    
                    cell.btn_check_driving_license.setBackgroundImage(UIImage(named: "rem"), for: .normal)
                }
                
            }
            
            cell.btn_check_vehicle_documents.setBackgroundImage(UIImage(named: "rem1"), for: .normal)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(upload_documents.tapFunction))
            cell.lbl_please_upload_your_driving_document.isUserInteractionEnabled = true
            cell.lbl_please_upload_your_driving_document.addGestureRecognizer(tap)
            
            return cell
            
        } else if (indexPath.row == 1) {
            let cell:upload_documents_table_cell = tableView.dequeueReusableCell(withIdentifier: "vehicle_insurance") as! upload_documents_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if (self.str_vehicle_insurance == "0") {

                cell.lbl_vehicle_insurance_seaprator.isHidden = true
                cell.btn_vehicle_insurance_arrow.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            } else {
                cell.lbl_vehicle_insurance_seaprator.isHidden = false
                cell.btn_vehicle_insurance_arrow.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            }
            
            if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                print(person as Any)
                
                let arr_mut_order_history:NSMutableArray! = []
                var ar : NSArray!
                
                ar = (person["carinfromation"] as! Array<Any>) as NSArray
                arr_mut_order_history.addObjects(from: ar as! [Any])
                
                if (arr_mut_order_history.count == 0) {
                    
                    cell.btn_vehicle_insurance.setBackgroundImage(UIImage(named: "rem1"), for: .normal)
                    
                } else {
                    
                    let item = arr_mut_order_history[0] as? [String:Any]
                    
                    if (item!["isurenceCompony"] as! String) == "" {
                        
                        cell.btn_vehicle_insurance.setBackgroundImage(UIImage(named: "rem1"), for: .normal)
                    } else {
                        self.str_vehicle_insurance = "1"
                        cell.lbl_vehicle_insurance_seaprator.isHidden = false
                        cell.btn_vehicle_insurance_arrow.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                        
                        cell.btn_vehicle_insurance.setBackgroundImage(UIImage(named: "rem"), for: .normal)
                    }
                }
                
            }
            
            // cell.btn_check_vehicle_documents.setBackgroundImage(UIImage(named: "rem1"), for: .normal)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(upload_documents.insurance_click_method))
            cell.lbl_please_upload_your_vehicle_insurance.isUserInteractionEnabled = true
            cell.lbl_please_upload_your_vehicle_insurance.addGestureRecognizer(tap)

            return cell
            
        } else if (indexPath.row == 2) {
            
            let cell:upload_documents_table_cell = tableView.dequeueReusableCell(withIdentifier: "vehicle_registration_permit") as! upload_documents_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if (self.str_vehicle_registration_permit == "0") {

                cell.lbl_vehicle_reg_permit_seaprator.isHidden = true
                cell.btn_vehicle_registratio_arrow.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            } else {
                cell.lbl_vehicle_reg_permit_seaprator.isHidden = false
                cell.btn_vehicle_registratio_arrow.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            }
            
            if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                print(person as Any)
                
                let arr_mut_order_history:NSMutableArray! = []
                var ar : NSArray!
                
                ar = (person["carinfromation"] as! Array<Any>) as NSArray
                arr_mut_order_history.addObjects(from: ar as! [Any])
                
                if (arr_mut_order_history.count == 0) {
                    
                    cell.btn_vehicle_registration_permit.setBackgroundImage(UIImage(named: "rem1"), for: .normal)
                    
                } else {
                    
                    let item = arr_mut_order_history[0] as? [String:Any]
                    
                    if (item!["vehiclePermitIsssuesDate"] as! String) == "" {
                        
                        cell.btn_vehicle_registration_permit.setBackgroundImage(UIImage(named: "rem1"), for: .normal)
                    } else {
                        self.str_vehicle_registration_permit = "1"
                        cell.lbl_vehicle_reg_permit_seaprator.isHidden = false
                        cell.btn_vehicle_registratio_arrow.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                        
                        cell.btn_vehicle_registration_permit.setBackgroundImage(UIImage(named: "rem"), for: .normal)
                    }
                }
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(upload_documents.reg_permit_click_method))
            cell.lbl_please_upload_your_vehicle_registration_permit.isUserInteractionEnabled = true
            cell.lbl_please_upload_your_vehicle_registration_permit.addGestureRecognizer(tap)
            
            return cell
            
        }  else if (indexPath.row == 3) {
            
            let cell:upload_documents_table_cell = tableView.dequeueReusableCell(withIdentifier: "vehicle_registration_four") as! upload_documents_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if (self.str_vehicle_registration_four == "0") {

                cell.lbl_vehicle_registration_four_seaprator.isHidden = true
                cell.btn_vehicle_registration_four_arrow.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            } else {
                cell.lbl_vehicle_registration_four_seaprator.isHidden = false
                cell.btn_vehicle_registration_four_arrow.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            }
            
            if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                print(person as Any)
                
                let arr_mut_order_history:NSMutableArray! = []
                var ar : NSArray!
                
                ar = (person["carinfromation"] as! Array<Any>) as NSArray
                arr_mut_order_history.addObjects(from: ar as! [Any])
                
                if (arr_mut_order_history.count == 0) {
                    
                    cell.btn_vehicle_registration_four.setBackgroundImage(UIImage(named: "rem1"), for: .normal)
                    
                } else {
                    
                    let item = arr_mut_order_history[0] as? [String:Any]
                    
                    if (item!["registration_state"] as! String) == "" {
                        
                        cell.btn_vehicle_registration_four.setBackgroundImage(UIImage(named: "rem1"), for: .normal)
                    } else {
                        self.str_vehicle_registration_four = "1"
                        cell.lbl_vehicle_registration_four_seaprator.isHidden = false
                        cell.btn_vehicle_registration_four_arrow.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                        
                        cell.btn_vehicle_registration_four.setBackgroundImage(UIImage(named: "rem"), for: .normal)
                    }
                }
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(upload_documents.vehicle_reg_four_click_method))
            cell.lbl_vehicle_registration_four_permit.isUserInteractionEnabled = true
            cell.lbl_vehicle_registration_four_permit.addGestureRecognizer(tap)
             
            return cell
            
            
        }  else {
            
            let cell:upload_documents_table_cell = tableView.dequeueReusableCell(withIdentifier: "vehicle_registration_tax") as! upload_documents_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            if (self.str_tax_permit == "0") {

                cell.lbl_tax_seaprator.isHidden = true
                cell.btn_tax_arrow.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            } else {
                cell.lbl_tax_seaprator.isHidden = false
                cell.btn_tax_arrow.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            }
            
            if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                print(person as Any)
                
                let arr_mut_order_history:NSMutableArray! = []
                var ar : NSArray!
                
                ar = (person["carinfromation"] as! Array<Any>) as NSArray
                arr_mut_order_history.addObjects(from: ar as! [Any])
                
                if (arr_mut_order_history.count == 0) {
                    
                    cell.btn_tax_permit.setBackgroundImage(UIImage(named: "rem1"), for: .normal)
                    
                } else {
                    
                    let item = arr_mut_order_history[0] as? [String:Any]
                    
                    if (item!["taxTokenImage"] as! String) == "" {
                        
                        cell.btn_tax_permit.setBackgroundImage(UIImage(named: "rem1"), for: .normal)
                    } else {
                        self.str_tax_permit = "1"
                        cell.lbl_tax_seaprator.isHidden = false
                        cell.btn_tax_arrow.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                        
                        cell.btn_tax_permit.setBackgroundImage(UIImage(named: "rem"), for: .normal)
                    }
                }
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(upload_documents.tax_click_method))
            cell.lbl_tax_permit.isUserInteractionEnabled = true
            cell.lbl_tax_permit.addGestureRecognizer(tap)
             
            return cell
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.row == 0) {
            
            if (self.str_driving_license == "0") {
                self.str_driving_license = "1"
            } else {
                self.str_driving_license = "0"
            }
            
        } else if (indexPath.row == 1) {
            
            if (self.str_vehicle_insurance == "0") {
                self.str_vehicle_insurance = "1"
            } else {
                self.str_vehicle_insurance = "0"
            }
            
        } else if (indexPath.row == 2) {
            
            if (self.str_vehicle_registration_permit == "0") {
                self.str_vehicle_registration_permit = "1"
            } else {
                self.str_vehicle_registration_permit = "0"
            }
            
        } else if (indexPath.row == 4) {
            
            if (self.str_tax_permit == "0") {
                self.str_tax_permit = "1"
            } else {
                self.str_tax_permit = "0"
            }
            
        } else if (indexPath.row == 3) {
            
            if (self.str_vehicle_registration_four == "0") {
                self.str_vehicle_registration_four = "1"
            } else {
                self.str_vehicle_registration_four = "0"
            }
            
        }
        
        //
        self.tbleView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            if (self.str_driving_license == "1") {
                return 114
            } else {
                return 66
            }
            
        } else  if indexPath.row == 1 {
            
            if (self.str_vehicle_insurance == "1") {
                return 114
            } else {
                return 64
            }
            
        }
        else  if indexPath.row == 4 {
           
           if (self.str_tax_permit == "1") {
               return 114
           } else {
               return 64
           }
           
       } else  if indexPath.row == 3 {
           
           if (self.str_vehicle_registration_four == "1") {
               return 114
           } else {
               return 64
           }
           
       }  else {
            
            if (self.str_vehicle_registration_permit == "1") {
                return 114
            } else {
                return 64
            }
            
        }
        
    }
    
}

class upload_documents_table_cell: UITableViewCell {

    // driving license
    @IBOutlet weak var btn_check_driving_license:UIButton!
    @IBOutlet weak var btn_check_vehicle_documents:UIButton!
    @IBOutlet weak var btn_driving_license_arrow:UIButton!
    
    @IBOutlet weak var view_driver_license:UIView! {
        didSet {
            view_driver_license.backgroundColor = .white
            
            view_driver_license.layer.masksToBounds = false
            view_driver_license.layer.shadowColor = UIColor.black.cgColor
            view_driver_license.layer.shadowOffset =  CGSize.zero
            view_driver_license.layer.shadowOpacity = 0.5
            view_driver_license.layer.shadowRadius = 2
            view_driver_license.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var lbl_driving_license_seaprator:UILabel!
    @IBOutlet weak var lbl_please_upload_your_driving_document:UILabel!     {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_please_upload_your_driving_document.text = "Please upload your Driving License"
                } else {
                    lbl_please_upload_your_driving_document.text = "আপনার ড্রাইভিং লাইসেন্স আপলোড করুন"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    @IBOutlet weak var lbl_please_upload_your_vehicle_document:UILabel!
    
    // Vehicle Insurance
    @IBOutlet weak var btn_vehicle_insurance:UIButton!
    @IBOutlet weak var btn_vehicle_insurance_arrow:UIButton!
    
    @IBOutlet weak var view_vehicle_insurance:UIView! {
        didSet {
            view_vehicle_insurance.backgroundColor = .white
            
            view_vehicle_insurance.layer.masksToBounds = false
            view_vehicle_insurance.layer.shadowColor = UIColor.black.cgColor
            view_vehicle_insurance.layer.shadowOffset =  CGSize.zero
            view_vehicle_insurance.layer.shadowOpacity = 0.5
            view_vehicle_insurance.layer.shadowRadius = 2
            view_vehicle_insurance.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var lbl_vehicle_insurance_seaprator:UILabel!
    @IBOutlet weak var lbl_please_upload_your_vehicle_insurance:UILabel!     {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_please_upload_your_vehicle_insurance.text = "Please upload your Vehicle Insurance"
                } else {
                    lbl_please_upload_your_vehicle_insurance.text = "আপনার যানবাহন বীমা আপলোড করুন"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    // Vehicle Registration / Permit
    @IBOutlet weak var btn_vehicle_registration_permit:UIButton!
    @IBOutlet weak var btn_vehicle_registratio_arrow:UIButton!
    
    @IBOutlet weak var view_vehicle_registration_permit:UIView! {
        didSet {
            view_vehicle_registration_permit.backgroundColor = .white
            
            view_vehicle_registration_permit.layer.masksToBounds = false
            view_vehicle_registration_permit.layer.shadowColor = UIColor.black.cgColor
            view_vehicle_registration_permit.layer.shadowOffset =  CGSize.zero
            view_vehicle_registration_permit.layer.shadowOpacity = 0.5
            view_vehicle_registration_permit.layer.shadowRadius = 2
            view_vehicle_registration_permit.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var lbl_vehicle_reg_permit_seaprator:UILabel!
    @IBOutlet weak var lbl_please_upload_your_vehicle_registration_permit:UILabel!    {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_please_upload_your_vehicle_registration_permit.text = "Please upload your Vehicle Permit & Fitness"
                } else {
                    lbl_please_upload_your_vehicle_registration_permit.text = "আপনার যানবাহন পারমিট এবং ফিটনেস আপলোড করুন"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    
    // Tax
    @IBOutlet weak var btn_tax_permit:UIButton!
    @IBOutlet weak var btn_tax_arrow:UIButton!
    
    @IBOutlet weak var view_tax_permit:UIView! {
        didSet {
            view_tax_permit.backgroundColor = .white
            
            view_tax_permit.layer.masksToBounds = false
            view_tax_permit.layer.shadowColor = UIColor.black.cgColor
            view_tax_permit.layer.shadowOffset =  CGSize.zero
            view_tax_permit.layer.shadowOpacity = 0.5
            view_tax_permit.layer.shadowRadius = 2
            view_tax_permit.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var lbl_tax_seaprator:UILabel!
    @IBOutlet weak var lbl_tax_permit:UILabel!  {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_tax_permit.text = "Please upload your Tax Token"
                } else {
                    lbl_tax_permit.text = "আপনার ট্যাক্স টোকেন আপলোড করুন"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    
    // registration four
    @IBOutlet weak var btn_vehicle_registration_four:UIButton!
    @IBOutlet weak var btn_vehicle_registration_four_arrow:UIButton!
    
    @IBOutlet weak var view_vehicle_registration_four:UIView! {
        didSet {
            view_vehicle_registration_four.backgroundColor = .white
            
            view_vehicle_registration_four.layer.masksToBounds = false
            view_vehicle_registration_four.layer.shadowColor = UIColor.black.cgColor
            view_vehicle_registration_four.layer.shadowOffset =  CGSize.zero
            view_vehicle_registration_four.layer.shadowOpacity = 0.5
            view_vehicle_registration_four.layer.shadowRadius = 2
            view_vehicle_registration_four.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var lbl_vehicle_registration_four_seaprator:UILabel!
    @IBOutlet weak var lbl_vehicle_registration_four_permit:UILabel!   {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_vehicle_registration_four_permit.text = "Please upload your Vehicle Registration details"
                } else {
                    lbl_vehicle_registration_four_permit.text = "আপনার যানবাহন নিবন্ধন বিশদ আপলোড করুন"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_step_one:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_step_one.text = "Step 1 : Driver license"
                } else {
                    lbl_step_one.text = "ধাপ 1 : ড্রাইভার লাইসেন্স"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    @IBOutlet weak var lbl_step_two:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_step_two.text = "Step 2 : Vehicle Insurance"
                } else {
                    lbl_step_two.text = "ধাপ 2 : যানবাহন বীমা"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    @IBOutlet weak var lbl_step_three:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_step_three.text = "Step 3 : Vehicle permit & Fitness"
                } else {
                    lbl_step_three.text = "ধাপ 3 : যানবাহনের পারমিট এবং ফিটনেস"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    @IBOutlet weak var lbl_step_four:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_step_four.text = "Step 4 : Vehicle Registration"
                } else {
                    lbl_step_four.text = "ধাপ 4 : যানবাহন নিবন্ধন"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    @IBOutlet weak var lbl_step_five:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_step_five.text = "Step 5 : Tax Token"
                } else {
                    lbl_step_five.text = "ধাপ 5 : ট্যাক্স টোকেন"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
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

