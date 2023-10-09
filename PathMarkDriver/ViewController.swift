//
//  ViewController.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 17/07/23.
//

import UIKit
import SwiftGifOrigin


class ViewController: UIViewController {

    @IBOutlet weak var img_loader:UIImageView! {
        didSet {
            img_loader.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.img_loader.image = UIImage.gif(name: "loading_gif")
        
    }


}

