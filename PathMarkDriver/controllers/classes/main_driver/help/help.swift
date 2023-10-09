//
//  help.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 11/08/23.
//

import UIKit

class help: UIViewController {

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
            view_navigation_title.text = "HELP"
            view_navigation_title.textColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
