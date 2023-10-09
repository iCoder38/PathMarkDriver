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
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            view_navigation_title.text = "Select Vehicle Type"
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
    
    @IBOutlet weak var btn_select:UIButton! {
        didSet {
             
            Utils.buttonStyle(button: btn_select,
                              bCornerRadius: 12,
                              bBackgroundColor: UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1),
                              bTitle: "Select",
                              bTitleColor: .black)
            
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
        self.str_select_vehicle = "BIKE"
    }
    
    @objc func car_click_method() {
        
        self.btn_car.setBackgroundImage(UIImage(named: "check"), for: .normal)
        self.btn_bike.setBackgroundImage(UIImage(named: "un_check"), for: .normal)
        self.str_select_vehicle = "CAR"
    }
    
    @objc func select_click_method() {
        
        if (self.str_select_vehicle == "0") {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message:"Please select atleast one vehicle.", style: .alert)
            let cancel = NewYorkButton(title: "Ok", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            
        } else {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "vehicle_list_id") as? vehicle_list
            push!.str_get_vehicle_type = String(str_select_vehicle)
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    

}
