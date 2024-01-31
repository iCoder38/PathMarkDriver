//
//  select_vehicle_type.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 17/07/23.
//

import UIKit

class select_vehicle_type: UIViewController {

    var str_select_vehicle:String!
    
    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var lbl_message:UILabel! {
        didSet {
            
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_message.text = "PLEASE CHOOSE YOUR VEHICLE TYPE TO CONTINUE"
                } else {
                    lbl_message.text = "চালিয়ে যেতে আপনার গাড়ির ধরন বেছে নিন"
                }
                
             
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            // view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "Select Vehicle Type"
                } else {
                    view_navigation_title.text = "যানবাহনের ধরন নির্বাচন করুন"
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
    
    @IBOutlet weak var view_motor_bike:UIView! {
        didSet {
            view_motor_bike.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_motor_bike.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_motor_bike.layer.shadowOpacity = 1.0
            view_motor_bike.layer.shadowRadius = 15.0
            view_motor_bike.layer.masksToBounds = false
            
            view_motor_bike.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var view_car:UIView! {
        didSet {
            view_car.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_car.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_car.layer.shadowOpacity = 1.0
            view_car.layer.shadowRadius = 15.0
            view_car.layer.masksToBounds = false
            
            view_car.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var btn_bike:UIButton!
    @IBOutlet weak var btn_car:UIButton!
    
    @IBOutlet weak var lbl_bike_text:UILabel! {
        didSet {
             
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_bike_text.text = "Bike"
                } else {
                    lbl_bike_text.text = "বাইক"
                }
                
             
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
            
            
            
        }
    }
    @IBOutlet weak var lbl_car_text:UILabel! {
        didSet {
             
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_car_text.text = "Car"
                } else {
                    lbl_car_text.text = "গাড়ি"
                }
                
             
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
            
            
            
        }
    }
    @IBOutlet weak var btn_select:UIButton! {
        didSet {
             
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    Utils.buttonStyle(button: btn_select,
                                      bCornerRadius: 12,
                                      bBackgroundColor: UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1),
                                      bTitle: "Select",
                                      bTitleColor: .black)
                } else {
                    Utils.buttonStyle(button: btn_select,
                                      bCornerRadius: 12,
                                      bBackgroundColor: UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1),
                                      bTitle: "নির্বাচন করুন",
                                      bTitleColor: .black)
                }
                
             
            } else {
                print("=============================")
                print("LOGIN : Select language error")
                print("=============================")
                UserDefaults.standard.set("en", forKey: str_language_convert)
            }
            
            
            
            btn_select.layer.masksToBounds = false
            btn_select.layer.shadowColor = UIColor.black.cgColor
            btn_select.layer.shadowOffset =  CGSize.zero
            btn_select.layer.shadowOpacity = 0.5
            btn_select.layer.shadowRadius = 2
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.str_select_vehicle = "0"
        
        self.btn_bike.addTarget(self, action: #selector(bike_click_method), for: .touchUpInside)
        self.btn_car.addTarget(self, action: #selector(car_click_method), for: .touchUpInside)
        self.btn_select.addTarget(self, action: #selector(select_click_method), for: .touchUpInside)
    }
    
    @objc func bike_click_method() {
        
        self.btn_bike.setBackgroundImage(UIImage(named: "check"), for: .normal)
        self.btn_car.setBackgroundImage(UIImage(named: "un_check"), for: .normal)
        
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            
                self.str_select_vehicle = "BIKE"
            
            
         
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        
    }
    
    @objc func car_click_method() {
        
        self.btn_car.setBackgroundImage(UIImage(named: "check"), for: .normal)
        self.btn_bike.setBackgroundImage(UIImage(named: "un_check"), for: .normal)
        self.str_select_vehicle = "CAR"
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            
                self.str_select_vehicle = "CAR"
            
            
         
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        
    }
    
    @objc func select_click_method() {
        
        if (self.str_select_vehicle == "0") {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    let alert = NewYorkAlertController(title: String("Alert").uppercased(), message:"Please select atleast one vehicle.", style: .alert)
                    let cancel = NewYorkButton(title: "Ok", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                } else {
                    let alert = NewYorkAlertController(title: String("সতর্কতা").uppercased(), message:"অনুগ্রহ করে অন্তত একটি গাড়ি নির্বাচন করুন।", style: .alert)
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
            
            
            
        } else {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "vehicle_list_id") as? vehicle_list
            push!.str_get_vehicle_type = String(str_select_vehicle)
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    

}
