//
//  vehicle_list.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 17/07/23.
//

import UIKit
import Alamofire
import SDWebImage

import CryptoKit
import JWTDecode

class vehicle_list: UIViewController {

    var str_get_vehicle_type:String!
    
    var ar : NSArray!
    var arr_mut_list_of_category:NSMutableArray! = []
    
    var str_category_id:String!
    
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
            view_navigation_title.text = "Select"
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
            Utils.buttonStyle(button: btn_submit,
                              bCornerRadius: 12,
                              bBackgroundColor: UIColor(red: 108.0/255.0, green: 216.0/255.0, blue: 134.0/255.0, alpha: 1),
                              bTitle: "Submit",
                              bTitleColor: .white)
            
            btn_submit.layer.masksToBounds = false
            btn_submit.layer.shadowColor = UIColor.black.cgColor
            btn_submit.layer.shadowOffset =  CGSize.zero
            btn_submit.layer.shadowOpacity = 0.5
            btn_submit.layer.shadowRadius = 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.list_of_all_category_WB(str_show_loader: "yes")
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.btn_submit.addTarget(self, action: #selector(add_vehicle_details_click_method), for: .touchUpInside)
    }
    
//    @objc override func back_click_method() {
//        self.navigationController?.popViewController(animated: true)
//    }
     
    @objc func add_vehicle_details_click_method() {
        
        print(self.arr_mut_list_of_category as Any)
        
        var get_category_id:String!
        
        for indexx in 0..<self.arr_mut_list_of_category.count {
            
            let item = self.arr_mut_list_of_category[indexx] as! [String:Any]
            
            if (item["status"] as! String) == "yes" {
                
                get_category_id = (item["id"] as! String)
                
            }
            
        }
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_vehicle_details_id") as? add_vehicle_details
        
        push!.str_vehicle_category_id = String(get_category_id)
        
        self.navigationController?.pushViewController(push!, animated: true)
        
        
    }
    
    /*@objc func convert_country_list_params_into_encode() {
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.show_gif_loader()
        
        let params = payload_vehicle_list(action: "category",
                                          TYPE: String(str_get_vehicle_type))
        
        
        let secret = sha_token_api_key
        let privateKey = SymmetricKey(data: Data(secret.utf8))

        let headerJSONData = try! JSONEncoder().encode(Header())
        let headerBase64String = headerJSONData.urlSafeBase64EncodedString()

        let payloadJSONData = try! JSONEncoder().encode(params)
        let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()

        let toSign = Data((headerBase64String + "." + payloadBase64String).utf8)

        let signature = HMAC<SHA512>.authenticationCode(for: toSign, using: privateKey)
        let signatureBase64String = Data(signature).urlSafeBase64EncodedString()
        // print(signatureBase64String)
        
        let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")
        print(token)
        // ERProgressHud.sharedInstance.hide()
        
        // send this token to server
        
        
        // decode
        do {
            let jwt = try JWTDecode.decode(jwt: token)
            print(jwt)

            // print(type(of: jwt))


            print(jwt["body"])
            } catch {
                print("The file could not be loaded")
         }
        
        // send this token to server
        list_of_all_category_WB(get_encrpyt_token: token)
        
        
    }*/
    
    @objc func list_of_all_category_WB(str_show_loader:String) {
        
        self.view.endEditing(true)
        self.show_gif_loader()
        
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = payload_vehicle_list(action: "category",
                                          TYPE: String(str_get_vehicle_type))
        
        print(params as Any)
        
        AF.request(application_base_url,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default).responseJSON {  response in
             debugPrint(response.result)
            
            switch response.result {
            case let .success(value):
                
                let JSON = value as! NSDictionary
                print(JSON as Any)
                // print(JSON["body"] as Any)
                
                var strSuccess : String!
                strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                
                print(strSuccess as Any)
                if strSuccess == String("success") {
                    print("yes")
                    
                    self.hide_loading_UI()
                    ERProgressHud.sharedInstance.hide()
                    
                    self.ar = (JSON["data"] as! Array<Any>) as NSArray
                    
                    for indexx in 0..<self.ar.count {
                        
                        let item = self.ar[indexx] as? [String:Any]
                        
                        let custom_dict = ["id":"\(item!["id"]!)",
                                           "name":(item!["name"] as! String),
                                           "image":(item!["image"] as! String),
                                           "status":"no",
                                           "perMile":"\(item!["perMile"]!)",
                                           "TYPE":(item!["TYPE"] as! String)]
                        
                        self.arr_mut_list_of_category.add(custom_dict)
                        
                    }
                    
                    // self.arr_mut_list_of_category.addObjects(from: ar as! [Any])
                    
                    self.dismiss(animated: true)
                    
                    self.tbleView.dataSource = self
                    self.tbleView.delegate = self
                    self.tbleView.reloadData()
                    
                    // decode data
                    /*do {
                        let jwt = try JWTDecode.decode(jwt: (JSON["body"] as! String) )
                        // print(jwt)
                        // print(jwt.body["data"])
                         
                        self.ar = (jwt.body["data"] as! Array<Any>) as NSArray
                        
                        for indexx in 0..<self.ar.count {
                            
                            let item = self.ar[indexx] as? [String:Any]
                            
                            let custom_dict = ["id":"\(item!["id"]!)",
                                               "name":(item!["name"] as! String),
                                               "image":(item!["image"] as! String),
                                               "status":"no",
                                               "perMile":"\(item!["perMile"]!)",
                                               "TYPE":(item!["TYPE"] as! String)]
                            
                            self.arr_mut_list_of_category.add(custom_dict)
                            
                        }
                        
                        // self.arr_mut_list_of_category.addObjects(from: ar as! [Any])
                        
                        self.dismiss(animated: true)
                        
                        self.tbleView.dataSource = self
                        self.tbleView.delegate = self
                        self.tbleView.reloadData()

                        
                        } catch {
                            print("SOME PROBLEM IN YOUR ENCRYPT CODE")
                     }*/
                    
                } else {
                    
                    print("no")
                    ERProgressHud.sharedInstance.hide()
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                    
                    let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(strSuccess2), style: .alert)
                    let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                    
                }
                
            case let .failure(error):
                print(error)
                ERProgressHud.sharedInstance.hide()
                
                self.please_check_your_internet_connection()
                
            }
        }
        // }
    }
    
    @objc func login_refresh_token_wb() {
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let get_login_details = UserDefaults.standard.value(forKey: str_save_email_password) as? [String:Any] {
            print(get_login_details as Any)
            
            parameters = [
                "action"    : "login",
                "email"     : (get_login_details["email"] as! String),
                "password"  : (get_login_details["password"] as! String),
            ]
            //        }
            
            print("parameters-------\(String(describing: parameters))")
            
            AF.request(application_base_url, method: .post, parameters: parameters as? Parameters).responseJSON {
                response in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.value {
                        
                        let JSON = data as! NSDictionary
                        print(JSON)
                        
                        var strSuccess : String!
                        strSuccess = JSON["status"] as? String
                        
                        if strSuccess.lowercased() == "success" {
                            
                            let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            
                            
                            self.list_of_all_category_WB(str_show_loader: "no")
                            
                            
                        }
                        else {
                            ERProgressHud.sharedInstance.hide()
                        }
                        
                    }
                    
                case .failure(_):
                    print("Error message:\(String(describing: response.error))")
                    ERProgressHud.sharedInstance.hide()
                    self.please_check_your_internet_connection()
                    
                    break
                }
            }
        }
        
    }

}


extension vehicle_list: UITableViewDataSource  , UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_list_of_category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:vehicle_list_table_cell = tableView.dequeueReusableCell(withIdentifier: "vehicle_list_table_cell") as! vehicle_list_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arr_mut_list_of_category[indexPath.row] as? [String:Any]

        // cell.imgCarType.image = UIImage(named: "foodPlaceholder")
        cell.lblCarType.text = (item!["name"] as! String)
        
        cell.layer.cornerRadius = 22
        cell.clipsToBounds = true
        
        cell.imgCarType.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.imgCarType.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo33"))
        
        if (item!["status"] as! String) == "no" {
            
            // cell.img_purple.isHidden = true
            cell.btn_select.isHidden = true
            cell.imgCarType.layer.cornerRadius = 0
            cell.imgCarType.clipsToBounds = true
            cell.imgCarType.layer.borderWidth = 0
            // cell.layer.borderWidth = 1
            // cell.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
            
        } else {
            
            // cell.img_purple.isHidden = false
            cell.btn_select.isHidden = false
            cell.btn_select.setImage(UIImage(named: "rem"), for: .normal)
            cell.btn_select.tintColor = .systemGreen
            cell.imgCarType.layer.cornerRadius = 0
            cell.imgCarType.clipsToBounds = true
            cell.imgCarType.layer.borderWidth = 0
            // cell.layer.borderWidth = 1
            // cell.layer.borderColor = UIColor.orange.cgColor
            
        }
        
        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.arr_mut_list_of_category.removeAllObjects()
        
        for indexx in 0..<self.ar.count {
            
            let item = self.ar[indexx] as? [String:Any]

            let custom_dict = ["id":"\(item!["id"]!)",
                               "name":(item!["name"] as! String),
                               "image":(item!["image"] as! String),
                               "status":"no",
                               "perMile":"\(item!["perMile"]!)",
                               "TYPE":(item!["TYPE"] as! String)]
            
            self.arr_mut_list_of_category.add(custom_dict)
            
        }
        
        let item = self.arr_mut_list_of_category[indexPath.row] as? [String:Any]
        self.str_category_id = (item!["id"] as! String)
        
        self.arr_mut_list_of_category.removeObject(at: indexPath.row)
        
        let custom_dict = ["id":(item!["id"] as! String),
                           "name":(item!["name"] as! String),
                           "image":(item!["image"] as! String),
                           "status":"yes",
                           "perMile":"\(item!["perMile"]!)",
                           "TYPE":(item!["TYPE"] as! String)]
        
        self.arr_mut_list_of_category.insert(custom_dict, at: indexPath.row)
        
        print(self.str_category_id as Any)
        
        // self.str_category_id = "\(item!["id"]!)"
        
        self.tbleView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
}

class vehicle_list_table_cell: UITableViewCell {

    @IBOutlet weak var imgCarType:UIImageView! {
        didSet {
            imgCarType.layer.cornerRadius = 25
            imgCarType.clipsToBounds = true
            imgCarType.layer.borderWidth = 5
            imgCarType.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var img_purple:UIImageView!
    
    @IBOutlet weak var lblCarType:UILabel!
    @IBOutlet weak var lblExtimatedTime:UILabel!
    
    @IBOutlet weak var btn_select:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

