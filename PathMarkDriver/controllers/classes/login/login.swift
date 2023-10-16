//
//  login.swift
//  PathMark
//
//  Created by Dishant Rajput on 10/07/23.
//

import UIKit
 
import CryptoKit
import JWTDecode
import Alamofire

// MARK:- LOCATION -
import CoreLocation


class login: UIViewController , UITextFieldDelegate , CLLocationManagerDelegate {

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
            view_navigation_title.text = "Login"
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
    
    var dict:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
         
        self.iAmHereForLocationPermission()
        
        /*let defaults = UserDefaults.standard
        defaults.setValue(nil, forKey: str_save_login_user_data)
        defaults.setValue("", forKey: str_save_login_user_data)*/
        
        self.remember_me()
    }
    
    @objc func remember_me() {
        
         
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person as Any)
            // print(person["role"] as! String)
            
            if person["role"] as! String == "Member" {
                
                // CUSTOMER
                // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as! dashboard
                // self.navigationController?.pushViewController(push, animated: true)
                
            } else {
                
                let arr_mut_order_history:NSMutableArray! = []
                
                // DRIVER
                var ar : NSArray!
                ar = (person["carinfromation"] as! Array<Any>) as NSArray
                
                arr_mut_order_history.addObjects(from: ar as! [Any])
                
                if (arr_mut_order_history.count == 0) {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "select_vehicle_type_id") as! select_vehicle_type
                    self.navigationController?.pushViewController(push, animated: true)
                    
                } else {
                    let item = arr_mut_order_history[0] as? [String:Any]
                     print(item as Any)
                    
                    if (item!["carNumber"] as! String) == "" {
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_vehicle_details_id") as! add_vehicle_details
                        self.navigationController?.pushViewController(push, animated: true)
                        
                    } else if (person["drivingLicenceNo"] as! String) == "" {
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_documents_id") as! upload_documents
                        self.navigationController?.pushViewController(push, animated: true)
                        
                    }  else if (item!["insurenceissueDate"] as! String) == "" {
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_documents_id") as! upload_documents
                        self.navigationController?.pushViewController(push, animated: true)
                        
                    }  else if (item!["vehiclePermitIsssuesDate"] as! String) == "" {
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_documents_id") as! upload_documents
                        self.navigationController?.pushViewController(push, animated: true)
                        
                    }  else if (item!["taxTokenImage"] as! String) == "" {
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_documents_id") as! upload_documents
                        self.navigationController?.pushViewController(push, animated: true)
                        
                    } else {
                        
                        if ("\(person["AdminApproved"]!)") == "0" {
                            
                            let alert = NewYorkAlertController(title: String("Not Approved.").uppercased(), message: String("Your profile is not approved yet. Please wait or contact our customer support."), style: .alert)
                            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            
                        } else {
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "driver_dashboard_id") as! driver_dashboard
                            self.navigationController?.pushViewController(push, animated: true)
                        }
                        
                    }
                }
                
            }
        }
    }

    @objc func iAmHereForLocationPermission() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
              
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.strSaveLatitude = "0"
                self.strSaveLongitude = "0"
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                          
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                      
            @unknown default:
                break
            }
        }
    }
    
    
    
    
    /*@objc func convert_sign_in_params_into_encode() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
        
        self.show_gif_loader()
        
        let params = payload_login(action: "login",
                                   email: String(cell.txtEmailAddress.text!),
                                   password: String(cell.txtPassword.text!))
        
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

            // print(type(of: jwt))

            print(jwt["body"])
            
            } catch {
                print("The file could not be loaded")
         }
        
        // send this token to server
        self.sign_up_WB(get_encrpyt_token: token)
        
    }*/
    
    @objc func sign_up_WB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
       
        let params = payload_login(action: "login",
                                   email: String(cell.txtEmailAddress.text!),
                                   password: String(cell.txtPassword.text!))

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
                    
                    // save token
                    // print("\(JSON["AuthToken"]!)")
                    // print(type(of: JSON["AuthToken"]))
                    
                    let str_token = (JSON["AuthToken"] as! String)
                    UserDefaults.standard.set("", forKey: str_save_last_api_token)
                    UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                    
                    let indexPath = IndexPath.init(row: 0, section: 0)
                    let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
                    
                    // save email and pass
                    // email
                    let custom_email_pass = ["email":cell.txtEmailAddress.text!,
                                             "password":cell.txtPassword.text!]
                    
                    UserDefaults.standard.setValue(custom_email_pass, forKey: str_save_email_password)
                    //
                    
                    self.hide_loading_UI()
                    ERProgressHud.sharedInstance.hide()
                    
                    self.remember_me()
                    
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

extension login: UITableViewDataSource  , UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:login_table_cell = tableView.dequeueReusableCell(withIdentifier: "login_table_cell") as! login_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.txtEmailAddress.delegate = self
        cell.txtPassword.delegate = self
        
        cell.btnSignIn.addTarget(self, action: #selector(home_click_method), for: .touchUpInside)
        cell.btnDontHaveAnAccount.addTarget(self, action: #selector(dontHaveAntAccountClickMethod), for: .touchUpInside)
        cell.btn_remember_me.addTarget(self, action: #selector(remember_me_click_method), for: .touchUpInside)
        
        return cell
    }
    
    // 989013037178
    // VLMBIP
    
    @objc func remember_me_click_method() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! login_table_cell
        
        if cell.btn_remember_me.tag == 1 {
            
            cell.btn_remember_me.setImage(UIImage(named: "un_check"), for: .normal)
            cell.btn_remember_me.tag = 0
            
            
        } else {
            
            cell.btn_remember_me.tag = 1
            cell.btn_remember_me.setImage(UIImage(named: "check"), for: .normal)
            
            
        }
        
    }
    
    @objc func home_click_method() {
        
        self.sign_up_WB()
    }
    
    @objc func btnForgotPasswordPress() {
        

        
    }
    
    @objc func signInClickMethod() {
        
        
    }
    
    @objc func dontHaveAntAccountClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "sign_up_id")
         self.navigationController?.pushViewController(push, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 900
    }
    
}

class login_table_cell: UITableViewCell {

     
    
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
            txtPassword.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var btn_remember_me:UIButton! {
        didSet {
            btn_remember_me.tag = 0
            btn_remember_me.setImage(UIImage(named: "un_check"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnSignIn:UIButton! {
        didSet {
             
            Utils.buttonStyle(button: btnSignIn,
                              bCornerRadius: 12,
                              bBackgroundColor: UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1),
                              bTitle: "Sign In",
                              bTitleColor: .black)
            
            btnSignIn.layer.masksToBounds = false
            btnSignIn.layer.shadowColor = UIColor.black.cgColor
            btnSignIn.layer.shadowOffset =  CGSize.zero
            btnSignIn.layer.shadowOpacity = 0.5
            btnSignIn.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var btnSignUp:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnSignUp, bCornerRadius: 0, bBackgroundColor: .clear, bTitle: "Sign Up", bTitleColor: .white)
        }
    }
    
    @IBOutlet weak var btnSaveAndContinue:UIButton! {
        didSet {
            Utils.buttonStyle(button: btnSaveAndContinue, bCornerRadius: 6, bBackgroundColor: .black, bTitle: "Sign In", bTitleColor: .white)
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
            Utils.buttonStyle(button: btnDontHaveAnAccount, bCornerRadius: 6, bBackgroundColor: .clear, bTitle: "Not a member? Register Now", bTitleColor: UIColor(red: 87.0/255.0, green: 77.0/255.0, blue: 112.0/255.0, alpha: 1))
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
