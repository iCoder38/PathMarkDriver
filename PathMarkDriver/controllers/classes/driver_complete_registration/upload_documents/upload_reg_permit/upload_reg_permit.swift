//
//  upload_reg_permit.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 19/07/23.
//

import UIKit
import CryptoKit
import JWTDecode
import Alamofire
import SDWebImage

class upload_reg_permit: UIViewController , UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
            view_navigation_title.text = "Upload Vehicle Permit and Fitness"
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_reg_permit_table_cell
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
            var ar : NSArray!
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            let arr_mut_order_history:NSMutableArray! = []
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            let item = arr_mut_order_history[0] as? [String:Any]
            print(item as Any)
            
            if (item!["vehiclePermitImage"] as! String != "") {
                cell.img_upload_photo_or_document.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                cell.img_upload_photo_or_document.sd_setImage(with: URL(string: (item!["vehiclePermitImage"] as! String)), placeholderImage: UIImage(named: "logo33"))
            }
            
            //
            // cell.txt_vehicle_Registration_number.text = (item!["CarRegistrationNo"] as! String)
            cell.txt_vehicle_permit_number.text = (item!["vehiclePermitNo"] as! String)
            cell.txt_permit_issue.text = (item!["vehiclePermitIsssuesDate"] as! String)
            cell.txt_permit_exp.text = (item!["vehiclePermitIsssuesExpDate"] as! String)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /*@objc func convert_upload_vehicle_reg_permit_params_into_encode() {
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.show_gif_loader()
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_reg_permit_table_cell
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var ar : NSArray!
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            var arr_mut_order_history:NSMutableArray! = []
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            let item = arr_mut_order_history[0] as? [String:Any]
            
            let params = payload_upload_vehicle_reg_permit(action: "editcarinformation",
                                                           carinformationId: "\(item!["carinformationId"]!)",
                                                           userId: String(myString),
                                                           drivingLicenceNo: String(cell.txt_license_number.text!),
                                                           CarRegistrationNo: String(cell.txt_vehicle_Registration_number.text!),
                                                           vehiclePermitIsssuesDate: String(cell.txt_permit_issue.text!),
                                                           vehiclePermitIsssuesExpDate: String(cell.txt_permit_exp.text!),
                                                           vehicleType: String(cell.txt_vehicle_type.text!),
                                                           registration_state: String(cell.txt_state.text!))
            
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
    
    @objc func validation_before_submit() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_reg_permit_table_cell
        
        if (cell.txt_vehicle_permit_number.text == "") {
            show_alert(text: "Please enter Vehicle permit Number.")
            return
        } else if (cell.txt_permit_issue.text == "") {
            show_alert(text: "Please enter Issue Date.")
            return
        } else if (cell.txt_permit_exp.text == "") {
            show_alert(text: "Please enter Expiry Date.")
            return
        } else {
            
            if (self.str_for_profile == "yes") {
                
                if (self.str_user_select_image == "1") {
                    self.upload_permit_document_WB(str_show_loader: "yes")
                } else {
                     self.upload_vehicle_insurance_WB(str_show_loader: "yes")
                     
                }
            } else {
                if (self.str_user_select_image == "1") {
                    self.upload_permit_document_WB(str_show_loader: "yes")
                } else {
                    // self.upload_vehicle_insurance_WB(str_show_loader: "yes")
                    show_alert(text: "Please upload your Vehicle Permit and Fitness.")
                    return
                }
            }
            
        }
    }
    
    @objc func upload_vehicle_insurance_WB(str_show_loader:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_reg_permit_table_cell
        
        if (str_show_loader == "yes") {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        self.view.endEditing(true)
        
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
                
                parameters = [
                    "action"                    : "editcarinformation",
                    "userId"                    : String(myString),
                    "carinformationId"          : "\(item!["carinformationId"]!)",
                    "vehiclePermitNo"           : String(cell.txt_vehicle_permit_number.text!),
                    // "drivingLicenceNo"          : String(cell.txt_license_number.text!),
                    // "CarRegistrationNo"         : String(cell.txt_vehicle_Registration_number.text!),
                    "vehiclePermitIsssuesDate"  : String(cell.txt_permit_issue.text!),
                    "vehiclePermitIsssuesExpDate"   : String(cell.txt_permit_exp.text!),
                    // "vehicleType"               : String(cell.txt_vehicle_type.text!),
                    // "registration_state"        : String(cell.txt_state.text!)
                    
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
                            
                        }   else {
                            
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
                        
                        let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (JSON["msg"] as! String), style: .alert)
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        
                        // self.dismiss(animated: true)
                        ERProgressHud.sharedInstance.hide()
                        
                        self.navigationController?.popViewController(animated: true)
                        
                        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "driver_dashboard_id") as! driver_dashboard
                        self.navigationController?.pushViewController(push, animated: true)*/
                        
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
    
    
    
    // MARK: - UPLOAD DATA WITH IMAGE -
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.open_camera_gallery()
    }
    
    // MARK: - OPEN CAMERA OR GALLERY -
    @objc func open_camera_gallery() {
        
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_reg_permit_table_cell
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        cell.img_upload_photo_or_document.image = image_data
        let imageData:Data = image_data!.pngData()!
        self.img_Str_banner = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        self.img_data_banner = image_data!.jpegData(compressionQuality: 0.2)!
        self.dismiss(animated: true, completion: nil)
   
        self.str_user_select_image = "1"
    }
    
    @objc func upload_permit_document_WB(str_show_loader:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_reg_permit_table_cell
        
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
                 "action"                    : "editcarinformation",
                 "userId"                    : String(myString),
                 "carinformationId"          : "\(item!["carinformationId"]!)",
                 "drivingLicenceNo"          : String(cell.txt_license_number.text!),
                 "CarRegistrationNo"         : String(cell.txt_vehicle_Registration_number.text!),
                 "vehiclePermitIsssuesDate"  : String(cell.txt_permit_issue.text!),
                 "vehiclePermitIsssuesExpDate"   : String(cell.txt_permit_exp.text!),
                 "vehicleType"               : String(cell.txt_vehicle_type.text!),
                 "registration_state"        : String(cell.txt_state.text!)
                 */
                
                //Set Your Parameter
                let parameterDict = NSMutableDictionary()
                parameterDict.setValue("editcarinformation", forKey: "action")
                parameterDict.setValue(String(myString), forKey: "userId")
                parameterDict.setValue("\(item!["carinformationId"]!)", forKey: "carinformationId")
                //
                parameterDict.setValue(String(cell.txt_vehicle_permit_number.text!), forKey: "vehiclePermitNo")
                //
                // parameterDict.setValue(String(cell.txt_license_number.text!), forKey: "drivingLicenceNo")
                // parameterDict.setValue(String(cell.txt_vehicle_Registration_number.text!), forKey: "CarRegistrationNo")
                parameterDict.setValue(String(cell.txt_permit_issue.text!), forKey: "vehiclePermitIsssuesDate")
                parameterDict.setValue(String(cell.txt_permit_issue.text!), forKey: "vehiclePermitIsssuesExpDate")
                // parameterDict.setValue(String(cell.txt_vehicle_type.text!), forKey: "vehicleType")
                // parameterDict.setValue(String(cell.txt_state.text!), forKey: "registration_state")
                
                
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
                    // carInsuranceImage
                    multiPart.append(self.img_data_banner, withName: "vehiclePermitImage", fileName: "upload_car_permit.png", mimeType: "image/png")
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
                                self.login_refresh_token_for_permi_wb()
                                
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
    
    @objc func login_refresh_token_for_permi_wb() {
        
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

                            self.upload_permit_document_WB(str_show_loader: "no")
                            
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_reg_permit_table_cell
        
        RPicker.selectDate(title: "Issued Date",minDate: minDate,maxDate: maxDate, didSelectDate: {[] (selectedDate) in
           
            cell.txt_permit_issue.text = selectedDate.dateString("yyyy-MM-dd")
        })
    }
    
    @objc func exp_on_click_method() {
        self.view.endEditing(true)
        
        let minDate = Date().dateByAddingYears(0)
        let maxDate = Date().dateByAddingYears(60)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_reg_permit_table_cell
        
        RPicker.selectDate(title: "Expiry Date",minDate: minDate,maxDate: maxDate, didSelectDate: {[] (selectedDate) in
           
            cell.txt_permit_exp.text = selectedDate.dateString("yyyy-MM-dd")
        })
        
    }
    
    @objc func car_types_click_method() {
        self.view.endEditing(true)
        
        /*let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! upload_reg_permit_table_cell
        
        let actionSheet = NewYorkAlertController(title: "Car type", message: nil, style: .actionSheet)
        
        let type_sedan = NewYorkButton(title: "Sedan", style: .default) { _ in
            
            cell.txt_vehicle_type.text = "Sedan"
        }
        
        let type_economy = NewYorkButton(title: "Economy", style: .default) { _ in
            
            cell.txt_vehicle_type.text = "Economy"
        }
        
        let type_suv = NewYorkButton(title: "SUV", style: .default) { _ in
            
            cell.txt_vehicle_type.text = "SUV"
        }
        
        let type_luxury = NewYorkButton(title: "Luxury", style: .default) { _ in
            
            cell.txt_vehicle_type.text = "Luxury"
        }
        
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        
        actionSheet.addButtons([type_sedan,type_economy,type_suv,type_luxury, cancel])
        
        self.present(actionSheet, animated: true)*/
        
    }

    
    
}

extension upload_reg_permit: UITableViewDataSource  , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:upload_reg_permit_table_cell = tableView.dequeueReusableCell(withIdentifier: "upload_reg_permit_table_cell") as! upload_reg_permit_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView

        cell.layer.cornerRadius = 22
        cell.clipsToBounds = true

        cell.txt_vehicle_permit_number.delegate = self
        cell.txt_permit_issue.delegate = self
        cell.txt_permit_exp.delegate = self
        
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
                
//                cell.txt_policy_number.text = (item!["carInsuranceNo"] as! String)
//                cell.txt_insurance_policy.text = (item!["isurenceCompony"] as! String)
//                cell.txt_commencing_date.text = (item!["insurenceissueDate"] as! String)
//                cell.txt_policy_holder.text = (item!["policeholder"] as! String)
//                cell.txt_registration_number.text = (item!["CarRegistrationNo"] as! String)
//                cell.txt_number_of_passengers.text = "\(item!["noOfPassagenger"]!)"
//                cell.txt_exp_date.text = (item!["expDate"] as! String)
                
            }
            
            /*if (item!["carInsuranceNo"] as! String) != "" {
                
                cell.txt_vehicle_Registration_number.text = (item!["CarRegistrationNo"] as! String)
            }
            
            if (person["drivingLicenceNo"] as! String) != "" {
                
                cell.txt_license_number.text = (person["drivingLicenceNo"] as! String)
                cell.txt_vehicle_type.text = (person["vechicleType"] as! String)
  
            }*/
            
            
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.img_upload_photo_or_document.isUserInteractionEnabled = true
        cell.img_upload_photo_or_document.addGestureRecognizer(tapGestureRecognizer)
        
        cell.btn_submit.addTarget(self, action: #selector(validation_before_submit), for: .touchUpInside)
        
         cell.btn_open_issued_on_calendar.addTarget(self, action: #selector(issued_on_click_method), for: .touchUpInside)
         cell.btn_open_exp_on_calendar.addTarget(self, action: #selector(exp_on_click_method), for: .touchUpInside)
        // cell.btn_select_car_type.addTarget(self, action: #selector(car_types_click_method), for: .touchUpInside)
        
        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1400
    }
    
}

class upload_reg_permit_table_cell: UITableViewCell {

    @IBOutlet weak var btn_open_issued_on_calendar:UIButton!
    @IBOutlet weak var btn_open_exp_on_calendar:UIButton!
    
    @IBOutlet weak var txt_vehicle_permit_number:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_vehicle_permit_number,
                              tfName: txt_vehicle_permit_number.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Vehicle Permit Number")
            
            txt_vehicle_permit_number.layer.masksToBounds = false
            txt_vehicle_permit_number.layer.shadowColor = UIColor.black.cgColor
            txt_vehicle_permit_number.layer.shadowOffset =  CGSize.zero
            txt_vehicle_permit_number.layer.shadowOpacity = 0.5
            txt_vehicle_permit_number.layer.shadowRadius = 2
            
        }
    }
    
    
    @IBOutlet weak var txt_permit_exp:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_permit_exp,
                              tfName: txt_permit_exp.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Permit Exp. Date")
            
            txt_permit_exp.layer.masksToBounds = false
            txt_permit_exp.layer.shadowColor = UIColor.black.cgColor
            txt_permit_exp.layer.shadowOffset =  CGSize.zero
            txt_permit_exp.layer.shadowOpacity = 0.5
            txt_permit_exp.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txt_permit_issue:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_permit_issue,
                              tfName: txt_permit_issue.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Issue")
            
            txt_permit_issue.layer.masksToBounds = false
            txt_permit_issue.layer.shadowColor = UIColor.black.cgColor
            txt_permit_issue.layer.shadowOffset =  CGSize.zero
            txt_permit_issue.layer.shadowOpacity = 0.5
            txt_permit_issue.layer.shadowRadius = 2
            
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
    
    @IBOutlet weak var img_upload_photo_or_document:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
