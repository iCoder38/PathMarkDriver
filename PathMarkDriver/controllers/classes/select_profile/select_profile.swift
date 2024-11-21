//
//  select_profile.swift
//  PathMark
//
//  Created by Dishant Rajput on 22/05/24.
//



// class select_profile: UIViewController {
    // import UIKit
import UIKit

class select_profile: UIViewController {
    
    @IBOutlet weak var btn_language:UIButton!
    
    @IBOutlet weak var btn_create_ac_account:UIButton! {
        didSet {
            btn_create_ac_account.layer.cornerRadius = 12
            btn_create_ac_account.clipsToBounds = true
            btn_create_ac_account.backgroundColor = .systemOrange
        }
    }
    @IBOutlet weak var btn_login:UIButton!  {
        didSet {
            btn_login.layer.cornerRadius = 12
            btn_login.clipsToBounds = true
            btn_login.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lbl_title:UILabel!
    @IBOutlet weak var lbl_sub_title:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("", forKey: "key_accept_term")
        
        if let remember_me = UserDefaults.standard.string(forKey: "key_remember_me") {
            print(remember_me as Any)
            
            if (remember_me == "yes") {
                self.remember_me()
            }
        }
        
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
                        push.str_for_update = "no"
                        self.navigationController?.pushViewController(push, animated: true)
                        
                    } else if (person["drivingLicenceNo"] as! String) == "" {
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_documents_id") as! upload_documents
                        push.str_for_update = "no"
                        self.navigationController?.pushViewController(push, animated: true)
                        
                    }  else if (item!["insurenceissueDate"] as! String) == "" {
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_documents_id") as! upload_documents
                        push.str_for_update = "no"
                        self.navigationController?.pushViewController(push, animated: true)
                        
                    }  else if (item!["vehiclePermitIsssuesDate"] as! String) == "" {
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_documents_id") as! upload_documents
                        push.str_for_update = "no"
                        self.navigationController?.pushViewController(push, animated: true)
                        
                    }  else if (item!["taxTokenImage"] as! String) == "" {
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "upload_documents_id") as! upload_documents
                        push.str_for_update = "no"
                        self.navigationController?.pushViewController(push, animated: true)
                        
                    } else {
                        
                        if ("\(person["AdminApproved"]!)") == "0" {
                            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                print(language as Any)
                                
                                if (language == "en") {
                                    let alert = NewYorkAlertController(title: String("Not Approved.").uppercased(), message: String("Your profile is not approved yet. Please wait or contact our customer support."), style: .alert)
                                    let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                                    alert.addButtons([cancel])
                                    self.present(alert, animated: true)
                                } else {
                                    let alert = NewYorkAlertController(title: String("অনুমোদিত না.").uppercased(), message: String("আপনার প্রোফাইল এখনও অনুমোদিত নয়. অনুগ্রহ করে অপেক্ষা করুন বা আমাদের গ্রাহক সহায়তার সাথে যোগাযোগ করুন।"), style: .alert)
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
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "driver_dashboard_id") as! driver_dashboard
                            self.navigationController?.pushViewController(push, animated: true)
                        }
                        
                    }
                }
                
            }
        } else {
            debugPrint("DATA NOT STORED IN LOCAL DATABASE")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                btn_create_ac_account.setTitle("Create an account", for: .normal)
                btn_login.setTitle("Login", for: .normal)
                lbl_title.text = "Hello, welcome to zarib app"
                lbl_sub_title.text = "Get started now"
            } else {
                btn_create_ac_account.setTitle("অ্যাকাউন্ট তৈরি করুন", for: .normal)
                btn_login.setTitle("লগ-ইন", for: .normal)
                lbl_title.text = "হ্যালো, যারিব অ্যাপে আপনাকে স্বাগতম !"
                lbl_sub_title.text = "এখনই শুরু করুন"
            }
            
        }
        
        self.btn_language.addTarget(self, action: #selector(language), for: .touchUpInside)
        self.btn_login.addTarget(self, action: #selector(login_click_method), for: .touchUpInside)
        self.btn_create_ac_account.addTarget(self, action: #selector(register_click_method), for: .touchUpInside)
    }
    
    @objc func login_click_method() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "login_id") as? login
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func register_click_method() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "sign_up_id") as? sign_up
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func language() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "change_language_id") as? change_language
        push!.str_start_screens = "yes"
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func loginButtonTapped() {
        // Handle login button tap action
        print("Login button tapped!")
    }
    
    @objc func createAccountButtonTapped() {
        // Handle create account button tap action
        print("Create an account button tapped!")
    }
}
