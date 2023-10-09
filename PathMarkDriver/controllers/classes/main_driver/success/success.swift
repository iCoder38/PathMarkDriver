//
//  success.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 06/09/23.
//

import UIKit

class success: UIViewController {

    var get_done_payment_details_from_notificaion:NSDictionary!
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.backgroundColor = .lightGray
            view_bg.layer.cornerRadius = 6
            view_bg.clipsToBounds = true
        }
    }
    @IBOutlet weak var btn_amount:UIButton! {
        didSet {
            btn_amount.backgroundColor = navigation_color
            btn_amount.setTitleColor(.white, for: .normal)
        }
    }
    @IBOutlet weak var btn_mode:UIButton! {
        didSet {
            btn_mode.backgroundColor = navigation_color
            btn_mode.setTitleColor(.white, for: .normal)
        }
    }
    @IBOutlet weak var lbl_cash_text:UILabel! {
        didSet {
            lbl_cash_text.backgroundColor = .white
        }
    }
    @IBOutlet weak var lbl_cash:UILabel! {
        didSet {
            lbl_cash.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btn_received_payment:UIButton! {
        didSet {
            btn_received_payment.setTitle("RECEIVED PAYMENT", for: .normal)
            btn_received_payment.setTitleColor(.white, for: .normal)
            btn_received_payment.layer.cornerRadius = 6
            btn_received_payment.clipsToBounds = true
            btn_received_payment.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
            
            // shadow
            btn_received_payment.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_received_payment.layer.shadowOffset = CGSize(width: 0, height: 3)
            btn_received_payment.layer.shadowOpacity = 1.0
            btn_received_payment.layer.shadowRadius = 10.0
            btn_received_payment.layer.masksToBounds = false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btn_received_payment.addTarget(self, action: #selector(push_to_dashboard_click_method), for: .touchUpInside)
        
        self.lbl_cash.text = "\(self.get_done_payment_details_from_notificaion["totalAmount"]!)"
        self.lbl_cash_text.text = "\(self.get_done_payment_details_from_notificaion["paymentMethod"]!)"
    }
    
    @objc func push_to_dashboard_click_method() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "driver_dashboard_id") as! driver_dashboard
        self.navigationController?.pushViewController(push, animated: true)
    }
    
}
