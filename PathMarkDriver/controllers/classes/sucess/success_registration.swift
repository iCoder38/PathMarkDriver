//
//  success_registration.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 11/10/23.
//

import UIKit

class success_registration: UIViewController {

    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var btn_back:UIButton! {
        didSet {
            btn_back.tintColor = .white
            btn_back.isHidden = true
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "Registration Done"
                } else {
                    view_navigation_title.text = "নিবন্ধন সম্পন্ন"
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
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.backgroundColor = .orange
            view_bg.layer.cornerRadius = 12
            view_bg.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btn_need_help:UIButton! {
        didSet {
            btn_need_help.backgroundColor = navigation_color
            btn_need_help.layer.cornerRadius = 12
            btn_need_help.clipsToBounds = true
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_need_help.setTitle("Need Help ? ", for: .normal)
                } else {
                    btn_need_help.setTitle("সাহায্য দরকার ?", for: .normal)
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
            btn_need_help.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var btn_home:UIButton!
    
    @IBOutlet weak var lbl_one:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_one.text = "Registration Complete"
                } else {
                    lbl_one.text = "নিবন্ধন সম্পন্ন"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_two:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_two.text = "Your registration has been successfully completed!"
                } else {
                    lbl_two.text = "আপনার নিবন্ধন সফলভাবে সম্পন্ন হয়েছে!"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_three:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_three.text = "You have to come Zarib Office with all the Document to verify your details."
                } else {
                    lbl_three.text = "আপনার বিবরণ যাচাই করার জন্য আপনাকে সমস্ত নথি নিয়ে জারিব অফিসে আসতে হবে।"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
    
    @IBOutlet weak var lbl_four:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_four.text = "Find our office address below:"
                } else {
                    lbl_four.text = "নীচে আমাদের অফিসের ঠিকানা খুঁজুন:"
                }
                
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
        }
    }
        
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                self.btn_home.setTitle("Home", for: .normal)
            } else {
                self.btn_home.setTitle("বাড়ি", for: .normal)
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        btn_home.addTarget(self, action: #selector(login_screen_clicked_method), for: .touchUpInside)
        
    }
    
    @objc func login_screen_clicked_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "login_id") as! login
        self.navigationController?.pushViewController(push, animated: true)
        
    }

}
