//
//  schedule_ride_details.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 11/08/23.
//

import UIKit

class schedule_ride_details: UIViewController {

    @IBOutlet weak var view_navigation:UIView! {
        didSet {
            view_navigation.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var view_profile_name:UIView! {
        didSet {
            view_profile_name.backgroundColor = .white
            
            // shadow
            view_profile_name.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_profile_name.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_profile_name.layer.shadowOpacity = 1.0
            view_profile_name.layer.shadowRadius = 10.0
            view_profile_name.layer.masksToBounds = false
            view_profile_name.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.backgroundColor = .gray
            img_profile.layer.cornerRadius = 30
            img_profile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_name:UILabel!
    @IBOutlet weak var lbl_phone:UILabel!
    
    @IBOutlet weak var lbl_total_fare:UILabel! {
        didSet {
            lbl_total_fare.text = "₴12"
            lbl_total_fare.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_total_distance:UILabel! {
        didSet {
            lbl_total_distance.text = "12 km"
            lbl_total_distance.textColor = .white
        }
    }
    
    @IBOutlet weak var view_from_to:UIView! {
        didSet {
            view_from_to.backgroundColor = .white
            
            // shadow
            view_from_to.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_from_to.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_from_to.layer.shadowOpacity = 1.0
            view_from_to.layer.shadowRadius = 10.0
            view_from_to.layer.masksToBounds = false
            view_from_to.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var view_date:UIView! {
        didSet {
            view_date.backgroundColor = .white
            
            // shadow
            view_date.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_date.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_date.layer.shadowOpacity = 1.0
            view_date.layer.shadowRadius = 10.0
            view_date.layer.masksToBounds = false
            view_date.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var view_time:UIView! {
        didSet {
            view_time.backgroundColor = .white
            
            // shadow
            view_time.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_time.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_time.layer.shadowOpacity = 1.0
            view_time.layer.shadowRadius = 10.0
            view_time.layer.masksToBounds = false
            view_time.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var view_booking:UIView! {
        didSet {
            view_booking.backgroundColor = .white
            
            // shadow
            view_booking.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_booking.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_booking.layer.shadowOpacity = 1.0
            view_booking.layer.shadowRadius = 10.0
            view_booking.layer.masksToBounds = false
            view_booking.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var btn_pickup:UIButton! {
        didSet {
            btn_pickup.setTitle("PICKUP", for: .normal)
            btn_pickup.setTitleColor(.white, for: .normal)
            btn_pickup.layer.cornerRadius = 6
            btn_pickup.clipsToBounds = true
            btn_pickup.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
        }
    }
    @IBOutlet weak var btn_decline:UIButton! {
        didSet {
            btn_decline.setTitle("DECLINE", for: .normal)
            btn_decline.setTitleColor(.systemPink, for: .normal)
            btn_decline.layer.cornerRadius = 6
            btn_decline.clipsToBounds = true
            btn_decline.backgroundColor = .white
            btn_decline.layer.borderColor = UIColor.systemPink.cgColor
            btn_decline.layer.borderWidth = 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
