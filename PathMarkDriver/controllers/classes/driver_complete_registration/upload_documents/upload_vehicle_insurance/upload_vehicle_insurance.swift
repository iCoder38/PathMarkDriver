//
//  upload_vehicle_insurance.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 19/07/23.
//

import UIKit
import CryptoKit
import JWTDecode
import Alamofire
import SDWebImage

class upload_vehicle_insurance: UIViewController , UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var str_for_profile:String!
    
    var img_data_banner : Data!
    var img_Str_banner : String!
    
    var str_user_select_image:String! = "0"
    
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
            view_navigation_title.text = "Upload Vehicle Insurance"
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "Upload Vehicle Insurance"
                } else {
                    view_navigation_title.text = "যানবাহন বীমা আপলোড করুন"
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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.tbleView.reloadData()
        
        self.parse_data()
    }
    
    @objc func parse_data() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_vehicle_insurance_table_cell
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
            var ar : NSArray!
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            let arr_mut_order_history:NSMutableArray! = []
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            let item = arr_mut_order_history[0] as? [String:Any]
            // print(item as Any)
            
            if (item!["carInsuranceImage"] as! String != "") {
                cell.img_upload_photo_or_document.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                cell.img_upload_photo_or_document.sd_setImage(with: URL(string: (item!["carInsuranceImage"] as! String)), placeholderImage: UIImage(named: "logo33"))
            }
            
            cell.txt_exp_date.text = (item!["expDate"] as! String)
            cell.txt_policy_holder.text = (item!["policeholder"] as! String)
            cell.txt_policy_number.text = (item!["carInsuranceNo"] as! String)
            cell.txt_commencing_date.text = (item!["insurenceissueDate"] as! String)
            cell.txt_insurance_policy.text = (item!["isurenceCompony"] as! String)
            cell.txt_registration_number.text = (item!["CarRegistrationNo"] as! String)
            // cell.txt_number_of_passengers.text = "\(item!["noOfPassagenger"]!)"
            
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /*@objc func convert_upload_vehicle_insurance_params_into_encode() {
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.show_gif_loader()
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_vehicle_insurance_table_cell
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var ar : NSArray!
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            let arr_mut_order_history:NSMutableArray! = []
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            let item = arr_mut_order_history[0] as? [String:Any]
            
            let params = payload_upload_vehicle_insurance(action: "editcarinformation",
                                                          carinformationId: "\(item!["carinformationId"]!)",
                                                          userId: String(myString),
                                                          carInsuranceNo: String(cell.txt_policy_number.text!),
                                                          isurenceCompony: String(cell.txt_insurance_policy.text!),
                                                          insurenceissueDate: String(cell.txt_commencing_date.text!),
                                                          policeholder: String(cell.txt_policy_holder.text!),
                                                          CarRegistrationNo: String(cell.txt_registration_number.text!),
                                                          noOfPassagenger: String(cell.txt_number_of_passengers.text!),
                                                          expDate: String(cell.txt_exp_date.text!))
            
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
    
    @objc func validation_before_insurance() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_vehicle_insurance_table_cell
        
        if (cell.txt_policy_number.text == "") {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    show_alert(text: "Please enter your Policy Number.")
                } else {
                    show_alert(text: "অনুগ্রহ করে আপনার পলিসি নম্বর লিখুন।")
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
            return
        } else if (cell.txt_insurance_policy.text == "") {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    show_alert(text: "Please enter your Insurance Company Name.")
                } else {
                    show_alert(text: "আপনার বীমা কোম্পানির নাম লিখুন.")
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
            return
        } else if (cell.txt_policy_holder.text == "") {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    show_alert(text: "Please enter Policy holder.")
                } else {
                    show_alert(text: "অনুগ্রহ করে পলিসি হোল্ডার লিখুন।")
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
            return
        } else if (cell.txt_registration_number.text == "") {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    show_alert(text: "Please enter your registration number.")
                } else {
                    show_alert(text: "আপনার নিবন্ধন নম্বর লিখুন.")
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            return
        }/* else if (cell.txt_number_of_passengers.text == "") {
            show_alert(text: "Please enter How many passenger you carry in your vehicle.")
            return
        }*/ else if (cell.txt_commencing_date.text == "") {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    show_alert(text: "Please enter Date.")
                } else {
                    show_alert(text: "তারিখ লিখুন.")
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
            return
        } else if (cell.txt_exp_date.text == "") {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    show_alert(text: "Please enter Expiry Date.")
                } else {
                    show_alert(text: "মেয়াদ শেষ হওয়ার তারিখ লিখুন.")
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
            return
        } else {
            
            if (self.str_for_profile == "yes") {
                
                if (self.str_user_select_image == "1") {
                    self.upload_vehicle_insurance_with_image_WB(str_show_loader: "yes")
                } else {
                     self.upload_vehicle_insurance_WB(str_show_loader: "yes")
                     
                }
            } else {
                if (self.str_user_select_image == "1") {
                    self.upload_vehicle_insurance_with_image_WB(str_show_loader: "yes")
                } else {
                    // self.upload_vehicle_insurance_WB(str_show_loader: "yes")
                    
                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                        print(language as Any)
                        
                        if (language == "en") {
                            show_alert(text: "Please upload your Vehicle Insurance.")
                        } else {
                            show_alert(text: "আপনার যানবাহন বীমা আপলোড করুন.")
                        }
                        
                    } else {
                        print("=============================")
                        print("LOGIN : Select language error")
                        print("=============================")
                        UserDefaults.standard.set("en", forKey: str_language_convert)
                    }
                    
                    
                    return
                }
            }
            
        }
        
        
    }
    
    @objc func upload_vehicle_insurance_WB(str_show_loader:String) {
        
        self.view.endEditing(true)
        
        if (str_show_loader == "yes") {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_vehicle_insurance_table_cell
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var ar : NSArray!
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            let arr_mut_order_history:NSMutableArray! = []
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            let item = arr_mut_order_history[0] as? [String:Any]
            
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
                    
                 
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                
                parameters = [
                    "action"            : "editcarinformation",
                    "userId"            : String(myString),
                    "carinformationId"  : "\(item!["carinformationId"]!)",
                    "carInsuranceNo"    : String(cell.txt_policy_number.text!),
                    "isurenceCompony"   : String(cell.txt_insurance_policy.text!),
                    "insurenceissueDate"    : String(cell.txt_commencing_date.text!),
                    "policeholder"      : String(cell.txt_policy_holder.text!),
                    "CarRegistrationNo" : String(cell.txt_registration_number.text!),
                    // "noOfPassagenger"   : String(cell.txt_number_of_passengers.text!),
                    "expDate"           : String(cell.txt_exp_date.text!),
                    "language"          : String(lan),
                    
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
                            
                            ERProgressHud.sharedInstance.hide()
                            self.get_user_profile_data()
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb()
                            
                        }  else {
                            
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

                            self.upload_vehicle_insurance_WB(str_show_loader: "no")
                            
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
    
    @objc func get_user_profile_data() {
        
        self.view.endEditing(true)
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            var lan:String!
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lan = "en"
                } else {
                    lan = "bn"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            let params = payload_profile_one(action: "profile",
                                         userId: String(myString),
                                         language: String(lan))
            
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
                        
                        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                            print(language as Any)
                            
                            if (language == "en") {
                                let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (JSON["msg"] as! String), style: .alert)
                                let cancel = NewYorkButton(title: "Ok", style: .cancel)
                                alert.addButtons([cancel])
                                self.present(alert, animated: true)
                            } else {
                                let alert = NewYorkAlertController(title: String("সফলতা").uppercased(), message: (JSON["msg"] as! String), style: .alert)
                                let cancel = NewYorkButton(title: "ঠিক আছে", style: .cancel)
                                alert.addButtons([cancel])
                                self.present(alert, animated: true)
                            }
                            
                        } else {
                            print("=============================")
                            print("LOGIN : Select language error")
                            print("=============================")
                            UserDefaults.standard.set("en", forKey: str_language_convert)
                        }
                        
                        
                        
                        self.dismiss(animated: true)
                        ERProgressHud.sharedInstance.hide()
                        
                        self.navigationController?.popViewController(animated: true)
                        
//                        do {
//                            let jwt = try JWTDecode.decode(jwt: (JSON["body"] as! String) )
//                            print(jwt)
//                            // print(jwt.body["data"])
//
//                            let defaults = UserDefaults.standard
//                            defaults.setValue(jwt.body["data"], forKey: str_save_login_user_data)
//
//                            let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (jwt.body["msg"] as! String), style: .alert)
//                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
//                            alert.addButtons([cancel])
//                            self.present(alert, animated: true)
//
//                            self.dismiss(animated: true)
//                            ERProgressHud.sharedInstance.hide()
//
//                        } catch {
//                            print("SOME PROBLEM IN YOUR ENCRYPT CODE")
//                        }
//
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
    
    
    
    
    
    // MARK:- UPLOAD DATA WITH IMAGE -
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.open_camera_gallery()
    }
    
    // MARK: - OPEN CAMERA OR GALLERY -
    @objc func open_camera_gallery() {
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                
                let actionSheet = NewYorkAlertController(title: "Upload pics", message: nil, style: .actionSheet)
                
                // actionSheet.addImage(UIImage(named: "camera"))
                
                let cameraa = NewYorkButton(title: "Camera", style: .default) { _ in
                    // print("camera clicked done")
                    
                    self.open_camera_or_gallery(str_type: "c")
                }
                
                let gallery = NewYorkButton(title: "Gallery", style: .default) { _ in
                    // print("camera clicked done")
                    
                    self.open_camera_or_gallery(str_type: "g")
                }
                
                let cancel = NewYorkButton(title: "Cancel", style: .cancel)
                
                actionSheet.addButtons([cameraa, gallery, cancel])
                
                self.present(actionSheet, animated: true)
                
            } else {
                
                let actionSheet = NewYorkAlertController(title: "ছবি আপলোড করুন", message: nil, style: .actionSheet)
                
                // actionSheet.addImage(UIImage(named: "camera"))
                
                let cameraa = NewYorkButton(title: "ক্যামেরা", style: .default) { _ in
                    // print("camera clicked done")
                    
                    self.open_camera_or_gallery(str_type: "c")
                }
                
                let gallery = NewYorkButton(title: "গ্যালারি", style: .default) { _ in
                    // print("camera clicked done")
                    
                    self.open_camera_or_gallery(str_type: "g")
                }
                
                let cancel = NewYorkButton(title: "বাতিল করুন", style: .cancel)
                
                actionSheet.addButtons([cameraa, gallery, cancel])
                
                self.present(actionSheet, animated: true)
                
                
                
            }
            
        }
        
    }
    
    // MARK: - OPEN CAMERA or GALLERY -
    @objc func open_camera_or_gallery(str_type:String) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if str_type == "c" {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_vehicle_insurance_table_cell
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        cell.img_upload_photo_or_document.image = image_data
        let imageData:Data = image_data!.pngData()!
        self.img_Str_banner = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        self.img_data_banner = image_data!.jpegData(compressionQuality: 0.2)!
        self.dismiss(animated: true, completion: nil)
   
        self.str_user_select_image = "1"
    }
    
    @objc func upload_vehicle_insurance_with_image_WB(str_show_loader:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_vehicle_insurance_table_cell
        
        if (str_show_loader == "yes") {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        
        //Set Your URL
        let api_url = application_base_url
        guard let url = URL(string: api_url) else {
            return
        }
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let x : Int = person["userId"] as! Int
                let myString = String(x)
                
                var ar : NSArray!
                ar = (person["carinfromation"] as! Array<Any>) as NSArray
                
                let arr_mut_order_history:NSMutableArray! = []
                arr_mut_order_history.addObjects(from: ar as! [Any])
                
                let item = arr_mut_order_history[0] as? [String:Any]
                
                var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
                urlRequest.httpMethod = "POST"
                urlRequest.allHTTPHeaderFields = ["token":String(token_id_is)]
                urlRequest.addValue("application/json",
                                    forHTTPHeaderField: "Accept")
                
                /*
                 "action"            : "editcarinformation",
                 "userId"            : String(myString),
                 "carinformationId"  : "\(item!["carinformationId"]!)",
                 "carInsuranceNo"    : String(cell.txt_policy_number.text!),
                 "isurenceCompony"   : String(cell.txt_insurance_policy.text!),
                 "insurenceissueDate"    : String(cell.txt_commencing_date.text!),
                 "policeholder"      : String(cell.txt_policy_holder.text!),
                 "CarRegistrationNo" : String(cell.txt_registration_number.text!),
                 "noOfPassagenger"   : String(cell.txt_number_of_passengers.text!),
                 "expDate"           : String(cell.txt_exp_date.text!)
                 */
                
                var lan:String!
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        lan = "en"
                    } else {
                        lan = "bn"
                    }
                    
                 
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                
                //Set Your Parameter
                let parameterDict = NSMutableDictionary()
                parameterDict.setValue("editcarinformation", forKey: "action")
                parameterDict.setValue(String(myString), forKey: "userId")
                parameterDict.setValue("\(item!["carinformationId"]!)", forKey: "carinformationId")
                parameterDict.setValue(String(cell.txt_policy_number.text!), forKey: "carInsuranceNo")
                parameterDict.setValue(String(cell.txt_insurance_policy.text!), forKey: "isurenceCompony")
                parameterDict.setValue(String(cell.txt_commencing_date.text!), forKey: "insurenceissueDate")
                parameterDict.setValue(String(cell.txt_policy_holder.text!), forKey: "policeholder")
                parameterDict.setValue(String(cell.txt_registration_number.text!), forKey: "CarRegistrationNo")
                // parameterDict.setValue(String(cell.txt_number_of_passengers.text!), forKey: "noOfPassagenger")
                parameterDict.setValue(String(cell.txt_exp_date.text!), forKey: "expDate")
                parameterDict.setValue(String(lan), forKey: "language")
                
                print(parameterDict as Any)
                
                // Now Execute
                AF.upload(multipartFormData: { multiPart in
                    for (key, value) in parameterDict {
                        if let temp = value as? String {
                            multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                        }
                        if let temp = value as? Int {
                            multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                        }
                        if let temp = value as? NSArray {
                            temp.forEach({ element in
                                let keyObj = key as! String + "[]"
                                if let string = element as? String {
                                    multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                                } else
                                if let num = element as? Int {
                                    let value = "\(num)"
                                    multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                                }
                            })
                        }
                    }
                    //
                    multiPart.append(self.img_data_banner, withName: "carInsuranceImage", fileName: "upload_car_isurance.png", mimeType: "image/png")
                }, with: urlRequest)
                .uploadProgress(queue: .main, closure: { progress in
                    //Current upload progress of file
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON(completionHandler: { data in
                    
                    switch data.result {
                        
                    case .success(_):
                        do {
                            
                            let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                            
                            print(dictionary)
                            
                            var message : String!
                            message = (dictionary["msg"] as? String)
                            
                            if (dictionary["status"] as! String) == "success" {
                                
                                // ERProgressHud.sharedInstance.hide()
                                self.get_user_profile_data()
                                
                            } else if (dictionary["status"] as! String) == "Success" {
                                
                                // ERProgressHud.sharedInstance.hide()
                                self.get_user_profile_data()
                                
                            }  else if message == String(not_authorize_api) {
                                self.login_refresh_token_for_vehicle_wb()
                                
                            }

                        }
                        catch {
                            // catch error.
                            print("catch error")
                            ERProgressHud.sharedInstance.hide()
                        }
                        break
                        
                    case .failure(_):
                        print("failure")
                        ERProgressHud.sharedInstance.hide()
                        break
                        
                    }
                    
                    
                })
            }
        } else {
          print("session")
        }
    }
    
    @objc func login_refresh_token_for_vehicle_wb() {
        
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

                            self.upload_vehicle_insurance_with_image_WB(str_show_loader: "no")
                            
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
    
    @objc func issued_on_click_method() {
        self.view.endEditing(true)
        
        let minDate = Date().dateByAddingYears(-60)
        let maxDate = Date().dateByAddingYears(0)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_vehicle_insurance_table_cell
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                RPicker.selectDate(title: "Issued Date",minDate: minDate,maxDate: maxDate, didSelectDate: {[] (selectedDate) in
                   
                    cell.txt_commencing_date.text = selectedDate.dateString("yyyy-MM-dd")
                })
            } else {
                RPicker.selectDate(title: "ইস্যুর তারিখ", minDate: minDate, maxDate: maxDate, didSelectDate: {[] (selectedDate) in
                   
                    cell.txt_commencing_date.text = selectedDate.dateString("yyyy-MM-dd")
                })
            }
            
        }
        
    }
    
    @objc func exp_on_click_method() {
        self.view.endEditing(true)
        
        let minDate = Date().dateByAddingYears(0)
        let maxDate = Date().dateByAddingYears(60)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_vehicle_insurance_table_cell
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                RPicker.selectDate(title: "Expiry Date",minDate: minDate,maxDate: maxDate, didSelectDate: {[] (selectedDate) in
                   
                    cell.txt_exp_date.text = selectedDate.dateString("yyyy-MM-dd")
                })
            } else {
                RPicker.selectDate(title: "ইস্যুর তারিখ", minDate: minDate, maxDate: maxDate, didSelectDate: {[] (selectedDate) in
                   
                    cell.txt_exp_date.text = selectedDate.dateString("yyyy-MM-dd")
                })
            }
            
        }
        
        
    }
    
}


extension upload_vehicle_insurance: UITableViewDataSource  , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:upload_vehicle_insurance_table_cell = tableView.dequeueReusableCell(withIdentifier: "upload_vehicle_insurance_table_cell") as! upload_vehicle_insurance_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView

        cell.layer.cornerRadius = 22
        cell.clipsToBounds = true

        cell.txt_policy_number.delegate = self
        cell.txt_insurance_policy.delegate = self
        cell.txt_commencing_date.delegate = self
        cell.txt_policy_holder.delegate = self
        cell.txt_registration_number.delegate = self
        // cell.txt_number_of_passengers.delegate = self
        cell.txt_exp_date.delegate = self
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let arr_mut_order_history:NSMutableArray! = []
            
            // DRIVER
            var ar : NSArray!
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            let item = arr_mut_order_history[0] as? [String:Any]
            print(item as Any)
            
            if (item!["carInsuranceNo"] as! String) != "" {
                
                cell.txt_policy_number.text = (item!["carInsuranceNo"] as! String)
                cell.txt_insurance_policy.text = (item!["isurenceCompony"] as! String)
                cell.txt_commencing_date.text = (item!["insurenceissueDate"] as! String)
                cell.txt_policy_holder.text = (item!["policeholder"] as! String)
                cell.txt_registration_number.text = (item!["CarRegistrationNo"] as! String)
                // cell.txt_number_of_passengers.text = "\(item!["noOfPassagenger"]!)"
                cell.txt_exp_date.text = (item!["expDate"] as! String)
                
            }
            
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.img_upload_photo_or_document.isUserInteractionEnabled = true
        cell.img_upload_photo_or_document.addGestureRecognizer(tapGestureRecognizer)
        
        cell.btn_submit.addTarget(self, action: #selector(validation_before_insurance), for: .touchUpInside)
        
        cell.btn_issue_date.addTarget(self, action: #selector(issued_on_click_method), for: .touchUpInside)
        cell.btn_exp_date.addTarget(self, action: #selector(exp_on_click_method), for: .touchUpInside)
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                cell.btn_submit.setTitle("Submit", for: .normal)
                
                Utils.textFieldUI(textField: cell.txt_policy_number,
                                  tfName: cell.txt_policy_number.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Policy Number")
                Utils.textFieldUI(textField: cell.txt_insurance_policy,
                                  tfName: cell.txt_insurance_policy.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Insurance Company")
                Utils.textFieldUI(textField: cell.txt_commencing_date,
                                  tfName: cell.txt_commencing_date.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Date")
                Utils.textFieldUI(textField: cell.txt_policy_holder,
                                  tfName: cell.txt_policy_holder.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Policy Holder")
                Utils.textFieldUI(textField: cell.txt_registration_number,
                                  tfName: cell.txt_registration_number.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Regsitration number")
                /*Utils.textFieldUI(textField: cell.txt_number_of_passengers,
                                  tfName: cell.txt_number_of_passengers.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Number of Passengers Licenced To Carry")*/
                Utils.textFieldUI(textField: cell.txt_exp_date,
                                  tfName: cell.txt_exp_date.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "Exp. Date")
                
            } else {
                cell.btn_submit.setTitle("জমা দিন", for: .normal)
                 
                Utils.textFieldUI(textField: cell.txt_policy_number,
                                  tfName: cell.txt_policy_number.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "পলিসি নাম্বার")
                Utils.textFieldUI(textField: cell.txt_insurance_policy,
                                  tfName: cell.txt_insurance_policy.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "বীমা কোম্পানী")
                Utils.textFieldUI(textField: cell.txt_commencing_date,
                                  tfName: cell.txt_commencing_date.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "তারিখ")
                Utils.textFieldUI(textField: cell.txt_policy_holder,
                                  tfName: cell.txt_policy_holder.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "পলিসি হোল্ডার")
                Utils.textFieldUI(textField: cell.txt_registration_number,
                                  tfName: cell.txt_registration_number.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "নিবন্ধন নম্বর")
                /*Utils.textFieldUI(textField: cell.txt_number_of_passengers,
                                  tfName: cell.txt_number_of_passengers.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "বহন করার জন্য লাইসেন্সকৃত যাত্রীর সংখ্যা")*/
                Utils.textFieldUI(textField: cell.txt_exp_date,
                                  tfName: cell.txt_exp_date.text!,
                                  tfCornerRadius: 12,
                                  tfpadding: 20,
                                  tfBorderWidth: 0,
                                  tfBorderColor: .clear,
                                  tfAppearance: .dark,
                                  tfKeyboardType: .default,
                                  tfBackgroundColor: .white,
                                  tfPlaceholderText: "মেয়াদ। তারিখ")
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
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1200
    }
    
}

class upload_vehicle_insurance_table_cell: UITableViewCell {

    @IBOutlet weak var lbl_take_a_photo:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_take_a_photo.text = "Take a photo"
                } else {
                    lbl_take_a_photo.text = "একটি ছবি তুলুন"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    
    @IBOutlet weak var lbl_policy_number:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_policy_number.text = "Policy number"
                } else {
                    lbl_policy_number.text = "পলিসি নাম্বার"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_insurance_company:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_insurance_company.text = "Insurance Company"
                } else {
                    lbl_insurance_company.text = "বীমা কোম্পানী"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_policy_holder:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_policy_holder.text = "Policy holder"
                } else {
                    lbl_policy_holder.text = "পোর্টাল নম্বর"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_registration_number:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_registration_number.text = "Registration number"
                } else {
                    lbl_registration_number.text = "নিবন্ধন নম্বর"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_number_of_pas:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_number_of_pas.text = "Number of passenger license to carry"
                } else {
                    lbl_number_of_pas.text = "বহনযোগ্য যাত্রীর লাইসেন্সের সংখ্যা"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_date:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_date.text = "Date"
                } else {
                    lbl_date.text = "তারিখ"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_expiry_date:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_expiry_date.text = "Expiry Date"
                } else {
                    lbl_expiry_date.text = "মেয়াদ শেষ হওয়ার তারিখ"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    
    
    
    
    
    
    
    @IBOutlet weak var btn_issue_date:UIButton!
    @IBOutlet weak var btn_exp_date:UIButton! {
        didSet {
            btn_exp_date.isHidden = false
        }
    }
    
    @IBOutlet weak var txt_policy_number:UITextField! {
        didSet {
            
            
            txt_policy_number.layer.masksToBounds = false
            txt_policy_number.layer.shadowColor = UIColor.black.cgColor
            txt_policy_number.layer.shadowOffset =  CGSize.zero
            txt_policy_number.layer.shadowOpacity = 0.5
            txt_policy_number.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txt_insurance_policy:UITextField! {
        didSet {
            
            
            txt_insurance_policy.layer.masksToBounds = false
            txt_insurance_policy.layer.shadowColor = UIColor.black.cgColor
            txt_insurance_policy.layer.shadowOffset =  CGSize.zero
            txt_insurance_policy.layer.shadowOpacity = 0.5
            txt_insurance_policy.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txt_commencing_date:UITextField! {
        didSet {
            
            
            txt_commencing_date.layer.masksToBounds = false
            txt_commencing_date.layer.shadowColor = UIColor.black.cgColor
            txt_commencing_date.layer.shadowOffset =  CGSize.zero
            txt_commencing_date.layer.shadowOpacity = 0.5
            txt_commencing_date.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txt_policy_holder:UITextField! {
        didSet {
            
            
            txt_policy_holder.layer.masksToBounds = false
            txt_policy_holder.layer.shadowColor = UIColor.black.cgColor
            txt_policy_holder.layer.shadowOffset =  CGSize.zero
            txt_policy_holder.layer.shadowOpacity = 0.5
            txt_policy_holder.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txt_registration_number:UITextField! {
        didSet {
            
            
            txt_registration_number.layer.masksToBounds = false
            txt_registration_number.layer.shadowColor = UIColor.black.cgColor
            txt_registration_number.layer.shadowOffset =  CGSize.zero
            txt_registration_number.layer.shadowOpacity = 0.5
            txt_registration_number.layer.shadowRadius = 2
            
        }
    }
    
    /*@IBOutlet weak var txt_number_of_passengers:UITextField! {
        didSet {
            
            
            txt_number_of_passengers.layer.masksToBounds = false
            txt_number_of_passengers.layer.shadowColor = UIColor.black.cgColor
            txt_number_of_passengers.layer.shadowOffset =  CGSize.zero
            txt_number_of_passengers.layer.shadowOpacity = 0.5
            txt_number_of_passengers.layer.shadowRadius = 2
            
        }
    }*/
    
    @IBOutlet weak var txt_exp_date:UITextField! {
        didSet {
            
            
            txt_exp_date.layer.masksToBounds = false
            txt_exp_date.layer.shadowColor = UIColor.black.cgColor
            txt_exp_date.layer.shadowOffset =  CGSize.zero
            txt_exp_date.layer.shadowOpacity = 0.5
            txt_exp_date.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
            Utils.buttonStyle(button: btn_submit,
                              bCornerRadius: 16,
                              bBackgroundColor: UIColor(red: 108.0/255.0, green: 216.0/255.0, blue: 134.0/255.0, alpha: 1),
                              bTitle: "Submit",
                              bTitleColor: .white)
            
            btn_submit.layer.masksToBounds = false
            btn_submit.layer.shadowColor = UIColor.black.cgColor
            btn_submit.layer.shadowOffset =  CGSize.zero
            btn_submit.layer.shadowOpacity = 0.5
            btn_submit.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var img_upload_photo_or_document:UIImageView!   {
        didSet {
            img_upload_photo_or_document.layer.cornerRadius = 12
            img_upload_photo_or_document.clipsToBounds = true
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

