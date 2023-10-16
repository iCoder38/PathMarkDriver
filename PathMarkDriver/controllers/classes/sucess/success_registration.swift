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
            view_navigation_title.text = "Registration Done"
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
            btn_need_help.setTitle("Need Help ? ", for: .normal)
            btn_need_help.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var btn_home:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_home.addTarget(self, action: #selector(login_screen_clicked_method), for: .touchUpInside)
        
    }
    
    @objc func login_screen_clicked_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "login_id") as! login
        self.navigationController?.pushViewController(push, animated: true)
        
    }

}
