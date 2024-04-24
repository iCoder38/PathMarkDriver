//
//  success_ride_done.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 25/08/23.
//

import UIKit
import SwiftGifOrigin

class success_ride_done: UIViewController {

    var str_final_price:String!
    var str_total_distance:String!
    
    var counter = 5
    var timer:Timer!
    
    @IBOutlet weak var lbl_price:UILabel!
    
    @IBOutlet weak var btn_home:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                self.lbl_price.text = "Waiting for customer to pay $\(self.str_final_price!)"
                self.btn_home.setTitle("Home", for: .normal)
            } else {
                self.lbl_price.text = "গ্রাহক অর্থ প্রদানের জন্য অপেক্ষা করছেন $\(self.str_final_price!)"
                self.btn_home.setTitle("বাড়ি", for: .normal)
            }
            
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        
        self.btn_home.addTarget(self, action: #selector(home_button_click), for: .touchUpInside)
    }
    
    @objc func home_button_click() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "driver_dashboard_id") as! driver_dashboard
        self.navigationController?.pushViewController(push, animated: true)
        
    }

}
