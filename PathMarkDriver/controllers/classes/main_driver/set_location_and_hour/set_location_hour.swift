//
//  set_location_hour.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 11/08/23.
//

import UIKit

class set_location_hour: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var btn_back:UIButton! {
        didSet {
            btn_back.tintColor = .white
        }
    }
    
    @IBOutlet weak var view_navigation_bar:UIView! {
        didSet {
            view_navigation_bar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var view_navigation_title:UILabel! {
        didSet {
            view_navigation_title.text = "SET LOCATION & HOUR"
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbleView.separatorColor = .clear
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension set_location_hour: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:set_location_hour_table_cell = tableView.dequeueReusableCell(withIdentifier: "set_location_hour_table_cell") as! set_location_hour_table_cell
            
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.backgroundColor = .white
            
        cell.txt_from_location.delegate = self
        cell.txt_to_location.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 434
    }
    
}

class set_location_hour_table_cell: UITableViewCell {
    
    @IBOutlet weak var txt_from_location:UITextField! {
        didSet {
            // shadow
            txt_from_location.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_from_location.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_from_location.layer.shadowOpacity = 1.0
            txt_from_location.layer.shadowRadius = 10.0
            txt_from_location.layer.masksToBounds = false
            txt_from_location.layer.cornerRadius = 12
            txt_from_location.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_from_location.frame.height))
            txt_from_location.leftView = paddingView
            txt_from_location.leftViewMode = UITextField.ViewMode.always
        }
    }
    @IBOutlet weak var txt_to_location:UITextField! {
        didSet {
            // shadow
            txt_to_location.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_to_location.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_to_location.layer.shadowOpacity = 1.0
            txt_to_location.layer.shadowRadius = 10.0
            txt_to_location.layer.masksToBounds = false
            txt_to_location.layer.cornerRadius = 12
            txt_to_location.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_to_location.frame.height))
            txt_to_location.leftView = paddingView
            txt_to_location.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var btn_working_hour_from:UIButton!
    @IBOutlet weak var txt_working_hour_from:UITextField! {
        didSet {
            // shadow
            txt_working_hour_from.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_working_hour_from.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_working_hour_from.layer.shadowOpacity = 1.0
            txt_working_hour_from.layer.shadowRadius = 10.0
            txt_working_hour_from.layer.masksToBounds = false
            txt_working_hour_from.layer.cornerRadius = 12
            txt_working_hour_from.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_working_hour_from.frame.height))
            txt_working_hour_from.leftView = paddingView
            txt_working_hour_from.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var btn_working_hour_to:UIButton!
    @IBOutlet weak var txt_working_hour_to:UITextField! {
        didSet {
            // shadow
            txt_working_hour_to.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_working_hour_to.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_working_hour_to.layer.shadowOpacity = 1.0
            txt_working_hour_to.layer.shadowRadius = 10.0
            txt_working_hour_to.layer.masksToBounds = false
            txt_working_hour_to.layer.cornerRadius = 12
            txt_working_hour_to.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_working_hour_to.frame.height))
            txt_working_hour_to.leftView = paddingView
            txt_working_hour_to.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var btn_working_time_from:UIButton!
    @IBOutlet weak var txt_working_time_from:UITextField! {
        didSet {
            // shadow
            txt_working_time_from.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_working_time_from.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_working_time_from.layer.shadowOpacity = 1.0
            txt_working_time_from.layer.shadowRadius = 10.0
            txt_working_time_from.layer.masksToBounds = false
            txt_working_time_from.layer.cornerRadius = 12
            txt_working_time_from.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_working_time_from.frame.height))
            txt_working_time_from.leftView = paddingView
            txt_working_time_from.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var btn_working_time_to:UIButton!
    @IBOutlet weak var txt_working_time_to:UITextField! {
        didSet {
            // shadow
            txt_working_time_to.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_working_time_to.layer.shadowOffset = CGSize(width: 0, height: 3)
            txt_working_time_to.layer.shadowOpacity = 1.0
            txt_working_time_to.layer.shadowRadius = 10.0
            txt_working_time_to.layer.masksToBounds = false
            txt_working_time_to.layer.cornerRadius = 12
            txt_working_time_to.backgroundColor = .white
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20 , height: txt_working_time_to.frame.height))
            txt_working_time_to.leftView = paddingView
            txt_working_time_to.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    @IBOutlet weak var btn_save_details:UIButton! {
        didSet {
            btn_save_details.setTitle("SAVE DETAILS", for: .normal)
            btn_save_details.setTitleColor(.white, for: .normal)
            btn_save_details.layer.cornerRadius = 6
            btn_save_details.clipsToBounds = true
            btn_save_details.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
            
            // shadow
            btn_save_details.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_save_details.layer.shadowOffset = CGSize(width: 0, height: 3)
            btn_save_details.layer.shadowOpacity = 1.0
            btn_save_details.layer.shadowRadius = 10.0
            btn_save_details.layer.masksToBounds = false
            
        }
    }
    
}
