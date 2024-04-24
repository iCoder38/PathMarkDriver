//
//  language_splash.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 06/02/24.
//

import UIKit

class language_splash: UIViewController {

    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
             
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "Select language"
                } else {
                    view_navigation_title.text = "ভাষা নির্বাচন কর"
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
    
    @IBOutlet weak var btn_english:UIButton!
    @IBOutlet weak var btn_bangla:UIButton!
    
    @IBOutlet weak var btnSignIn:UIButton! {
        didSet {
             
            Utils.buttonStyle(button: btnSignIn,
                              bCornerRadius: 12,
                              bBackgroundColor: UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1),
                              bTitle: "Continue",
                              bTitleColor: .black)
            
            btnSignIn.layer.masksToBounds = false
            btnSignIn.layer.shadowColor = UIColor.black.cgColor
            btnSignIn.layer.shadowOffset =  CGSize.zero
            btnSignIn.layer.shadowOpacity = 0.5
            btnSignIn.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var lbl_select_language_text:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btn_english.addTarget(self, action: #selector(english_click_method), for: .touchUpInside)
        self.btn_bangla.addTarget(self, action: #selector(bangla_click_method), for: .touchUpInside)
        
        self.btnSignIn.addTarget(self, action: #selector(sign_in_click_method), for: .touchUpInside)
        
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_notification_id") as! schedule_notification
        self.navigationController?.pushViewController(push, animated: true)*/
        
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
        }
    }
    
    @objc func sign_in_click_method() {
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "login_id") as! login
         self.navigationController?.pushViewController(push, animated: true)
    }
    
    @objc func english_click_method() {
        self.btn_english.setImage(UIImage(named: "check"), for: .normal)
        self.btn_bangla.setImage(UIImage(named: "un_check"), for: .normal)
        UserDefaults.standard.set("en", forKey: str_language_convert)
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                lbl_select_language_text.text = "Please select language that you would like us in app."
                view_navigation_title.text = "Select language"
                self.btnSignIn.setTitle("Continue", for: .normal)
            } else {
                lbl_select_language_text.text = "অ্যাপে আপনি যে ভাষাটি আমাদের চান তা নির্বাচন করুন।"
                view_navigation_title.text = "ভাষা নির্বাচন কর"
                self.btnSignIn.setTitle("চালিয়ে যান", for: .normal)
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
    }
    
    @objc func bangla_click_method() {
        self.btn_english.setImage(UIImage(named: "un_check"), for: .normal)
        self.btn_bangla.setImage(UIImage(named: "check"), for: .normal)
        UserDefaults.standard.set("bn", forKey: str_language_convert)
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                lbl_select_language_text.text = "Please select language that you would like us in app."
                view_navigation_title.text = "Select language"
                self.btnSignIn.setTitle("Continue", for: .normal)
            } else {
                lbl_select_language_text.text = "অ্যাপে আপনি যে ভাষাটি আমাদের চান তা নির্বাচন করুন।"
                view_navigation_title.text = "ভাষা নির্বাচন কর"
                self.btnSignIn.setTitle("চালিয়ে যান", for: .normal)
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
    }
    
}
