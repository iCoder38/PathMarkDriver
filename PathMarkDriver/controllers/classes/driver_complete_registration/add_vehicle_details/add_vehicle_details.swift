//
//  add_vehicle_details.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 17/07/23.
//

import UIKit
import CryptoKit
import JWTDecode
import Alamofire

class add_vehicle_details: UIViewController , UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var str_vehicle_category_id:String!
    
    var img_data_banner : Data!
    var img_Str_banner : String!
    
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
            view_navigation_title.text = "Add Vehicle Details"
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
    
    var str_user_select_image:String! = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        print(self.str_vehicle_category_id as Any)
        // self.get_login_user_full_data()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func accept_terms_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! add_vehicle_details_table_cell
        
        if cell.btn_accept_terms.tag == 1 {
            
            cell.btn_accept_terms.setImage(UIImage(named: "rem1"), for: .normal)
            cell.btn_accept_terms.tag = 0
            // cell.btn_accept_terms.backgroundColor = .lightGray
            cell.btn_continue.backgroundColor = .lightGray
            cell.btn_continue.isUserInteractionEnabled = false
            
        } else {
            
            cell.btn_accept_terms.tag = 1
            cell.btn_accept_terms.setImage(UIImage(named: "rem"), for: .normal)
            cell.btn_continue.backgroundColor = UIColor(red: 108.0/255.0, green: 216.0/255.0, blue: 134.0/255.0, alpha: 1)
            cell.btn_continue.isUserInteractionEnabled = true
            
        }
        
    }
    
    @objc func add_car_details_click_method() {
        
        if (self.str_user_select_image == "1") {
            self.upload_vehicle_details_WB(str_show_loader: "yes")
        } else {
            self.add_vehicle_WB(str_show_loader: "yes")
        }
        
        
    }
    
    
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
        let cell = self.tbleView.cellForRow(at: indexPath) as! add_vehicle_details_table_cell
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        cell.img_upload.image = image_data
        let imageData:Data = image_data!.pngData()!
        self.img_Str_banner = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        self.img_data_banner = image_data!.jpegData(compressionQuality: 0.2)!
        self.dismiss(animated: true, completion: nil)
   
        self.str_user_select_image = "1"
    }
    
    
    @objc func add_vehicle_WB(str_show_loader:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! add_vehicle_details_table_cell
        
        self.view.endEditing(true)
        
        if (str_show_loader == "yes") {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = payload_add_vehicle_details(action: "addcarinformation",
                                                     userId: String(myString),
                                                     categoryId: String(self.str_vehicle_category_id),
                                                     carNumber: String(cell.txt_vehicle_number.text!),
                                                     carModel: String(cell.txt_modal.text!),
                                                     carYear: String(cell.txt_year.text!),
                                                     carColor: String(cell.txt_color.text!),
                                                     carBrand:String(cell.txt_brand.text!))
            
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
                    
                    var message : String!
                    message = (JSON["msg"]as Any as? String)?.lowercased()
                    
                    print(strSuccess as Any)
                    if strSuccess == String("success") {
                        print("yes")
                        
                        self.get_login_user_full_data()
                        
                        
                    } else if message == String(not_authorize_api) {
                        self.login_refresh_token_wb()
                        
                    }  else {
                        
                        print("no")
                        self.dismiss(animated: true)
                        
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

                            self.add_vehicle_WB(str_show_loader: "no")
                            
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
    
    @objc func upload_vehicle_details_WB(str_show_loader:String) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! add_vehicle_details_table_cell
        
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
                
                /*var ar : NSArray!
                ar = (person["carinfromation"] as! Array<Any>) as NSArray
                
                let arr_mut_order_history:NSMutableArray! = []
                arr_mut_order_history.addObjects(from: ar as! [Any])
                
                let item = arr_mut_order_history[0] as? [String:Any]*/
                
                var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
                urlRequest.httpMethod = "POST"
                urlRequest.allHTTPHeaderFields = ["token":String(token_id_is)]
                urlRequest.addValue("application/json",
                                    forHTTPHeaderField: "Accept")
                
                /*
                 action: "addcarinformation",
                                                          userId: String(myString),
                                                          categoryId: String(self.str_vehicle_category_id),
                                                          carNumber: String(cell.txt_vehicle_number.text!),
                                                          carModel: String(cell.txt_modal.text!),
                                                          carYear: String(cell.txt_year.text!),
                                                          carColor: String(cell.txt_color.text!),
                                                          carBrand:String(cell.txt_brand.text!)
                 */
                //Set Your Parameter
                let parameterDict = NSMutableDictionary()
                parameterDict.setValue("addcarinformation", forKey: "action")
                parameterDict.setValue(String(myString), forKey: "userId")
                parameterDict.setValue(String(self.str_vehicle_category_id), forKey: "categoryId")
                parameterDict.setValue(String(cell.txt_vehicle_number.text!), forKey: "carNumber")
                parameterDict.setValue(String(cell.txt_modal.text!), forKey: "carModel")
                parameterDict.setValue(String(cell.txt_year.text!), forKey: "carYear")
                parameterDict.setValue(String(cell.txt_color.text!), forKey: "carColor")
                parameterDict.setValue(String(cell.txt_brand.text!), forKey: "carBrand")
                
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
                    multiPart.append(self.img_data_banner, withName: "DrivingLicenceImage", fileName: "upload_driving_license.png", mimeType: "image/png")
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
                                
                                self.get_login_user_full_data()
                                
                            } else if (dictionary["status"] as! String) == "Success" {
                                // ERProgressHud.sharedInstance.hide()
                                
                                self.get_login_user_full_data()
                                
                            }  else if message == String(not_authorize_api) {
                                self.login_refresh_token_for_upload_image_wb()
                                
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
            } else {
                print("token is expired")
                self.login_refresh_token_for_upload_image_wb()
            }
        } else {
          print("session")
        }
    }
    
    @objc func login_refresh_token_for_upload_image_wb() {
        
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

                            self.upload_vehicle_details_WB(str_show_loader: "no")
                            
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
                        
                        
                        self.dismiss(animated: true)
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_documents_id") as? upload_documents
                        
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

extension add_vehicle_details: UITableViewDataSource  , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:add_vehicle_details_table_cell = tableView.dequeueReusableCell(withIdentifier: "add_vehicle_details_table_cell") as! add_vehicle_details_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.txt_vehicle_number.delegate = self
        cell.txt_brand.delegate = self
        cell.txt_modal.delegate = self
        cell.txt_year.delegate = self
        cell.txt_color.delegate = self
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            
            print(person)
            
            var arr_mut_order_history:NSMutableArray! = []
            
            // DRIVER
            var ar : NSArray!
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            if (arr_mut_order_history.count != 0) {
                
                let item = arr_mut_order_history[0] as? [String:Any]
                // print(item as Any)
                
                if (item!["carNumber"] as! String) != "" {
                    
                    cell.txt_vehicle_number.text = (item!["carNumber"] as! String)
                    cell.txt_brand.text = (item!["carBrand"] as! String)
                    cell.txt_modal.text = (item!["carModel"] as! String)
                    cell.txt_year.text = (item!["carYear"] as! String)
                    cell.txt_color.text = (item!["carColor"] as! String)
                    self.str_vehicle_category_id = "\(item!["categoryId"]!)"
                    
                    cell.btn_accept_terms.tag = 0
                    cell.btn_accept_terms.setImage(UIImage(named: "rem"), for: .normal)
                    cell.btn_continue.isUserInteractionEnabled = true
                    cell.btn_continue.backgroundColor = UIColor(red: 108.0/255.0, green: 216.0/255.0, blue: 134.0/255.0, alpha: 1)
                }
                
            }
            
            
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.img_upload.isUserInteractionEnabled = true
        cell.img_upload.addGestureRecognizer(tapGestureRecognizer)
        
        cell.btn_accept_terms.addTarget(self, action: #selector(accept_terms_click_method), for: .touchUpInside)
        
        cell.btn_continue.addTarget(self, action: #selector(add_car_details_click_method), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 900
    }
    
}

class add_vehicle_details_table_cell: UITableViewCell {

    @IBOutlet weak var lbl_note:UILabel! {
        didSet {
            lbl_note.textAlignment = .center
            lbl_note.text = "Note: vehicle details will show when\nPassenger will book your car."
            lbl_note.numberOfLines = 0
            lbl_note.textColor = .darkGray
        }
    }
    
    @IBOutlet weak var btn_accept_terms:UIButton! {
        didSet {
            btn_accept_terms.backgroundColor = .clear
            btn_accept_terms.tag = 0
            btn_accept_terms.setImage(UIImage(named: "rem1"), for: .normal)
        }
    }
    
    @IBOutlet weak var btn_continue:UIButton! {
        didSet {
             
            Utils.buttonStyle(button: btn_continue,
                              bCornerRadius: 12,
                              bBackgroundColor: .lightGray,
                              bTitle: "Continue",
                              bTitleColor: .black)
            
            btn_continue.isUserInteractionEnabled = false
            
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
   
    @IBOutlet weak var txt_vehicle_number:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_vehicle_number,
                              tfName: txt_vehicle_number.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Vehicle Number")
            
            txt_vehicle_number.layer.masksToBounds = false
            txt_vehicle_number.layer.shadowColor = UIColor.black.cgColor
            txt_vehicle_number.layer.shadowOffset =  CGSize.zero
            txt_vehicle_number.layer.shadowOpacity = 0.5
            txt_vehicle_number.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var txt_brand:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_brand,
                              tfName: txt_brand.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Brand")
            
            txt_brand.layer.masksToBounds = false
            txt_brand.layer.shadowColor = UIColor.black.cgColor
            txt_brand.layer.shadowOffset =  CGSize.zero
            txt_brand.layer.shadowOpacity = 0.5
            txt_brand.layer.shadowRadius = 2
            
        }
    }
    
    
    @IBOutlet weak var txt_modal:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_modal,
                              tfName: txt_modal.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .numberPad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Modal")
            
            txt_modal.layer.masksToBounds = false
            txt_modal.layer.shadowColor = UIColor.black.cgColor
            txt_modal.layer.shadowOffset =  CGSize.zero
            txt_modal.layer.shadowOpacity = 0.5
            txt_modal.layer.shadowRadius = 2
            
        }
    }
    
    
    @IBOutlet weak var txt_year:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_year,
                              tfName: txt_year.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .numberPad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Year")
            
            txt_year.layer.masksToBounds = false
            txt_year.layer.shadowColor = UIColor.black.cgColor
            txt_year.layer.shadowOffset =  CGSize.zero
            txt_year.layer.shadowOpacity = 0.5
            txt_year.layer.shadowRadius = 2
            
        }
    }
    
    
    @IBOutlet weak var txt_color:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_color,
                              tfName: txt_color.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Color")
            
            txt_color.layer.masksToBounds = false
            txt_color.layer.shadowColor = UIColor.black.cgColor
            txt_color.layer.shadowOffset =  CGSize.zero
            txt_color.layer.shadowOpacity = 0.5
            txt_color.layer.shadowRadius = 2
            
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

