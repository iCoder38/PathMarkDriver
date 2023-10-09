//
//  ride_invoice_details.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 10/08/23.
//

import UIKit

class ride_invoice_details: UIViewController {

    @IBOutlet weak var view_navigation:UIView! {
        didSet {
            view_navigation.backgroundColor = navigation_color
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
    
    @IBOutlet weak var view_fare:UIView! {
        didSet {
            view_fare.backgroundColor = .white
            
            // shadow
            view_fare.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_fare.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_fare.layer.shadowOpacity = 1.0
            view_fare.layer.shadowRadius = 10.0
            view_fare.layer.masksToBounds = false
            view_fare.layer.cornerRadius = 12
        }
    }
    
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
    
    @IBOutlet weak var lbl_invoice_trip_fare:UILabel! {
        didSet {
            lbl_invoice_trip_fare.text = "12.00"
            lbl_invoice_trip_fare.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_invoice_tip:UILabel! {
        didSet {
            lbl_invoice_tip.text = "5.00"
            lbl_invoice_tip.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_invoice_total:UILabel! {
        didSet {
            lbl_invoice_total.text = "17.00"
            lbl_invoice_total.textColor = .black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
