//
//  sign_up.swift
//  PathMark
//
//  Created by Dishant Rajput on 10/07/23.
//

import UIKit
import Alamofire
import CryptoKit
import CommonCrypto
import JWTDecode

// MARK:- LOCATION -
import CoreLocation

class sign_up: UIViewController , UITextFieldDelegate, CLLocationManagerDelegate {

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
    
    
    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            view_navigation_title.text = "Create an account"
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.get_country_list_WB()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    /*@objc func convert_country_list_params_into_encode() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = payload_country_list(action: "countrylist")
        
        
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
        print(token)
        // ERProgressHud.sharedInstance.hide()
        
        // send this token to server
        self.get_country_list_WB(get_encrpyt_token: token)
        
        // decode
        do {
            let jwt = try decode(jwt: token)
            print(jwt)

            print(type(of: jwt))


            print(jwt["body"])
            } catch {
                print("The file could not be loaded")
         }
        
    }*/
    
    // get country list
    @objc func get_country_list_WB() {
        
        self.view.endEditing(true)
        
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
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
                    
                    ERProgressHud.sharedInstance.hide()
                    
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
    
    /*@objc func convert_sign_up_params_into_encode() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! sign_up_table_cell
        
        
        let params = payload_registration(action: "registration",
                                          fullName: String(cell.txt_full_name.text!),
                                          email: String(cell.txtEmailAddress.text!),
                                          countryCode: String("91"),
                                          contactNumber: String(cell.txt_phone_number.text!),
                                          password: String(cell.txtPassword.text!),
                                          role: "Driver",
                                          INDNo: String(cell.txt_nid_number.text!))
        
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
        print(token)
        
        // decode for testing
        // decode
        do {
            let jwt = try decode(jwt: token)
            print(jwt)

            print(type(of: jwt))


            print(jwt["body"])
            } catch {
                print("The file could not be loaded")
         }
        
        // send this token to server
        sign_up_WB(get_encrpyt_token: token)
        
        
    }*/
    
    @objc func sign_up_WB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! sign_up_table_cell
        
        self.view.endEditing(true)
        
        self.show_loading_UI()
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        // let params = main_token(body: get_encrpyt_token)
        
        let params = payload_registration(action: "registration",
                                          fullName: String(cell.txt_full_name.text!),
                                          email: String(cell.txtEmailAddress.text!),
                                          countryCode: String("91"),
                                          contactNumber: String(cell.txt_phone_number.text!),
                                          password: String(cell.txtPassword.text!),
                                          role: "Driver",
                                          INDNo: String(cell.txt_nid_number.text!),
                                          latitude: "",
                                          longitude: "",
                                          device: "iOS",
                                          deviceToken: "")
        
        
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
                    
                    var dict: Dictionary<AnyHashable, Any>
                    dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                    
                    let defaults = UserDefaults.standard
                    defaults.setValue(dict, forKey: str_save_login_user_data)
                    
                    // save email and password
                    let custom_email_pass = ["email":cell.txtEmailAddress.text!,
                                             "password":cell.txtPassword.text!]
                    
                    UserDefaults.standard.setValue(custom_email_pass, forKey: str_save_email_password)
                    
                    let alert = NewYorkAlertController(title: String("Success").uppercased(), message: (JSON["msg"] as! String), style: .alert)
                    let cancel = NewYorkButton(title: "Ok", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                    
                    self.hide_loading_UI()
                    ERProgressHud.sharedInstance.hide()
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "verify_phone_number_id") as? verify_phone_number
                    
                    push!.str_get_user_id = "\(dict["userId"]!)"
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
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

extension sign_up: UITableViewDataSource  , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:sign_up_table_cell = tableView.dequeueReusableCell(withIdentifier: "sign_up_table_cell") as! sign_up_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.txtEmailAddress.delegate = self
        cell.txtPassword.delegate = self
        cell.txt_address.delegate = self
        cell.txt_full_name.delegate = self
        cell.txt_address.delegate = self
        
        cell.btn_accept_terms.addTarget(self, action: #selector(accept_terms_click_method), for: .touchUpInside)
        
        cell.btnSignUp.addTarget(self, action: #selector(sign_up_click_method), for: .touchUpInside)
        
        return cell
    }
    
    // 989013037178
    // VLMBIP
    
    @objc func sign_up_click_method() {
        
        self.sign_up_WB()
    }
    
    @objc func accept_terms_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! sign_up_table_cell
        
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
        return 900
    }
    
}

class sign_up_table_cell: UITableViewCell {

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
    
    @IBOutlet weak var txt_phone_number:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txt_phone_number,
                              tfName: txt_phone_number.text!,
                              tfCornerRadius: 12,
                              tfpadding: 20,
                              tfBorderWidth: 0,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
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
                              tfKeyboardType: .default,
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
                              bTitle: "Create an account",
                              bTitleColor: .black)
            
            btnSignUp.layer.masksToBounds = false
            btnSignUp.layer.shadowColor = UIColor.black.cgColor
            btnSignUp.layer.shadowOffset =  CGSize.zero
            btnSignUp.layer.shadowOpacity = 0.5
            btnSignUp.layer.shadowRadius = 2
            
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

