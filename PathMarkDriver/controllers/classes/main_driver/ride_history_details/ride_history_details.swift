//
//  ride_history_details.swift
//  PathMark
//
//  Created by Dishant Rajput on 30/08/23.
//

import UIKit
import SDWebImage
import Alamofire

class ride_history_details: UIViewController {
    
    var dict_get_booking_details:NSDictionary!
    
    @IBOutlet weak var view_driver_info:UIView! {
        didSet {
            view_driver_info.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var lbl_price:UILabel! {
        didSet {
            lbl_price.textColor = .white
        }
    }
    @IBOutlet weak var lbl_distance:UILabel! {
        didSet {
            lbl_distance.textColor = .white
        }
    }
    
   
    
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
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    view_navigation_title.text = "Details"
                } else {
                    view_navigation_title.text = "বিস্তারিত"
                }
                
                view_navigation_title.textColor = .white
            }
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    var str_starrating:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbleView.separatorColor = .clear
        
        print("===================================")
        print("===================================")
        print(self.dict_get_booking_details as Any)
        print("===================================")
        print("===================================")
         
        let formattedString = roundToTwoDecimalPlaces(Double("\(self.dict_get_booking_details["FinalFare"]!)")!)
        
        self.lbl_price.text = formattedString
        self.lbl_distance.text = "\(self.dict_get_booking_details["totalDistance"]!)"
        
        self.btn_back.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.booking_history_details_WB(str_show_loader: "yes")
    }
    
    @objc func booking_history_details_WB(str_show_loader:String) {
        
        if (str_show_loader == "yes") {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
                } else {
                    ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "অপেক্ষা করুন")
                }
            }
        }
        
        
        self.view.endEditing(true)
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
             let x : Int = person["userId"] as! Int
             let myString = String(x)
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
                var lan:String!
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        lan = "en"
                    } else {
                        lan = "bn"
                    }
                    
                     
                }
                
                parameters = [
                    "action"        : "bookingdetail",
                    "bookingId"     : "\(self.dict_get_booking_details["bookingId"]!)",
                    "userId"        : String(myString),
                    "language"      : String(lan),
                ]
                
                print(parameters as Any)
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON { [self]
                    response in
                    // debugPrint(response.result)
                    
                    switch response.result {
                    case let .success(value):
                        
                        let JSON = value as! NSDictionary
                        print(JSON as Any)
                        
                        var strSuccess : String!
                        strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                        
                        var message : String!
                        message = (JSON["msg"] as? String)
                        
                        print(strSuccess as Any)
                        if strSuccess == String("success") {
                            print("yes")
                            
                            let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                            // self.dict_get_booking_details = JSON
                            self.str_starrating = "\(dict["bookingrating"]!)"
                            
                            
                            // dict = self.dict_get_booking_details as! [AnyHashable : Any]
                            
                            
                            
                            
                            
                            
                            
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb()
                            
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
            }
        }
    }
    
    @objc func login_refresh_token_wb() {
        
        var parameters:Dictionary<AnyHashable, Any>!
        if let get_login_details = UserDefaults.standard.value(forKey: str_save_email_password) as? [String:Any] {
            print(get_login_details as Any)
            
            if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                
                let x : Int = person["userId"] as! Int
                let myString = String(x)
                
                parameters = [
                    "action"    : "gettoken",
                    "userId"    : String(myString),
                    "email"     : (get_login_details["email"] as! String),
                    "role"      : (person["role"] as! String)
                ]
            }
            
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
                            
                            self.booking_history_details_WB(str_show_loader: "no")
                            
                        } else {
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

extension ride_history_details: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ride_history_details_table_cell = tableView.dequeueReusableCell(withIdentifier: "ride_history_details_table_cell") as! ride_history_details_table_cell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.lbl_car_driver_name.text = (self.dict_get_booking_details["fullName"] as! String)
        
        cell.lbl_from.text = (self.dict_get_booking_details["RequestPickupAddress"] as! String)
        cell.lbl_to.text = (self.dict_get_booking_details["RequestDropAddress"] as! String)
        
        let formattedStringfare = roundToTwoDecimalPlaces(Double("\(self.dict_get_booking_details["FinalFare"]!)")!)
        // cell.lbl_fare.text = "\(str_bangladesh_currency_symbol) \(formattedStringfare)"
        // cell.lbl_tip.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["TIP"]!)"
        // cell.lbl_promotion.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["discountAmount"]!)"
        
        //
        print(self.str_starrating as Any)
        // btn_payment_status
       
        
        /*// tip
        let i_am_tip:String!
        if "\(self.dict_get_booking_details["TIP"]!)" == "" {
            i_am_tip = "0.0"
        } else {
            i_am_tip = "\(self.dict_get_booking_details["TIP"]!)"
        }*/
        
        // promotion
        let i_am_promotion:String!
        if "\(self.dict_get_booking_details["discountAmount"]!)" == "" {
            i_am_promotion = "0.0"
        } else {
            i_am_promotion = "\(self.dict_get_booking_details["discountAmount"]!)"
        }
        
        let double_fare = Double("\(self.dict_get_booking_details["FinalFare"]!)")
        // let double_tip = Double(i_am_tip)
        let double_promotion = Double(i_am_promotion)
        
        //let add_all = double_fare!+double_tip!-double_promotion!
        let add_all = double_fare!-double_promotion!
        
        let formattedStringFF = roundToTwoDecimalPlaces(add_all)
        // cell.lbl_total_amount.text = "\(str_bangladesh_currency_symbol) \(formattedStringFF)"
        
        cell.lbl_car_number.text = "\(self.dict_get_booking_details["CarName"]!)"+" "+"\(self.dict_get_booking_details["vehicleNumber"]!)"
        cell.lbl_car_color.text = "\(self.dict_get_booking_details["VehicleColor"]!)"
        
        cell.img_car_image.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_car_image.sd_setImage(with: URL(string: (self.dict_get_booking_details["carImage"] as! String)), placeholderImage: UIImage(named: "logo33"))
        
        cell.img_driver_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_driver_profile.sd_setImage(with: URL(string: (self.dict_get_booking_details["image"] as! String)), placeholderImage: UIImage(named: "logo33"))
        
        cell.lbl_rating.text = "\(self.dict_get_booking_details["AVGRating"]!)"
        
        if "\(self.dict_get_booking_details["rideStatus"]!)" == "5" {
            
            if "\(self.dict_get_booking_details["paymentStatus"]!)" != "" {
                cell.img_gif.isHidden = false
                cell.img_gif.image = UIImage.gif(name: "double-check")
                
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        cell.btn_payment_status.setTitle("Payment Done", for: .normal)
                        
                    } else {
                        cell.btn_payment_status.setTitle("পেমেন্ট সম্পন্ন", for: .normal)
                    }
                    
                } else {
                    print("=============================")
                    print("LOGIN : Select language error")
                    print("=============================")
                    UserDefaults.standard.set("en", forKey: str_language_convert)
                }
                cell.btn_payment_status.backgroundColor = .systemGreen
                cell.btn_payment_status.setTitleColor(.white, for: .normal)
                
            } else {
                cell.img_gif.isHidden = true
            }
            
        } else {
            cell.img_gif.isHidden = true
        }
        
        // star manage
        if "\(self.dict_get_booking_details["AVGRating"]!)" == "0" {
            
            cell.img_star_one.image = UIImage(systemName: "star")
            cell.img_star_two.image = UIImage(systemName: "star")
            cell.img_star_three.image = UIImage(systemName: "star")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(self.dict_get_booking_details["AVGRating"]!)" > "1" &&
                    "\(self.dict_get_booking_details["AVGRating"]!)" < "2" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.img_star_three.image = UIImage(systemName: "star")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(self.dict_get_booking_details["AVGRating"]!)" == "2" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(self.dict_get_booking_details["AVGRating"]!)" > "2" &&
                    "\(self.dict_get_booking_details["AVGRating"]!)" < "3" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(self.dict_get_booking_details["AVGRating"]!)" == "3" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star.fill")
            cell.img_star_four.image = UIImage(systemName: "star")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(self.dict_get_booking_details["AVGRating"]!)" > "3" &&
                    "\(self.dict_get_booking_details["AVGRating"]!)" < "4" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star.fill")
            cell.img_star_four.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.img_star_five.image = UIImage(systemName: "star")
            
        } else if "\(self.dict_get_booking_details["AVGRating"]!)" == "5" {
            
            cell.img_star_one.image = UIImage(systemName: "star.fill")
            cell.img_star_two.image = UIImage(systemName: "star.fill")
            cell.img_star_three.image = UIImage(systemName: "star.fill")
            cell.img_star_four.image = UIImage(systemName: "star.fill")
            cell.img_star_five.image = UIImage(systemName: "star.fill")
            
        }
        
        /*
         @IBOutlet weak var lbl_total_fare_text:UILabel!
         @IBOutlet weak var lbl_distance_text:UILabel!
         @IBOutlet weak var lbl_total_fare_text_two:UILabel!
         @IBOutlet weak var lbl_tip_text:UILabel!
         @IBOutlet weak var lblpromotion_text:UILabel!
         @IBOutlet weak var lbl_total_amount_text:UILabel!
         */
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                cell.lbl_total_fare_text.text = "Fare"
                cell.lbl_distance_text.text = "Distance"
                cell.lbl_total_fare_text_two.text = "TOTAL FARE"
                // cell.lbl_tip_text.text = "Tip"
                // cell.lblpromotion_text.text = "Promotion"
                cell.lbl_total_amount_text.text = "Total Amount"
                
            } else {
                cell.lbl_total_fare_text.text = "ভাড়া"
                cell.lbl_distance_text.text = "দূরত্ব"
                cell.lbl_total_fare_text_two.text = "মোট ভাড়া"
                // cell.lbl_tip_text.text = "টিপ"
                // cell.lblpromotion_text.text = "পদোন্নতি"
                cell.lbl_total_amount_text.text = "সর্বমোট পরিমাণ"
            }
            
        } else {
            print("=============================")
            print("LOGIN : Select language error")
            print("=============================")
            UserDefaults.standard.set("en", forKey: str_language_convert)
        }
        
        cell.backgroundColor = .clear
        
        if String(self.str_starrating) == "0" {
            cell.btn_payment_status.backgroundColor = .systemOrange
            
            cell.btn_payment_status.isUserInteractionEnabled = true

            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    cell.btn_payment_status.setTitle("Send review", for: .normal)
                } else {
                    cell.btn_payment_status.setTitle("পর্যালোচনা পাঠান", for: .normal)
                }
                
                
            }
            
            cell.btn_payment_status.addTarget(self, action: #selector(review_send), for: .touchUpInside)
            // success_payment
            
        } else {
            cell.btn_payment_status.backgroundColor = .systemGreen
            
            cell.btn_payment_status.isUserInteractionEnabled = false
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    cell.btn_payment_status.setTitle("Payment done", for: .normal)
                } else {
                    cell.btn_payment_status.setTitle("পেমেন্ট সম্পন্ন", for: .normal)
                }
                
                
            }
        }
        
        
        cell.lbl_booking_fee.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["bookingFee"]!)"
        cell.lbl_previuos_can_fee.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["last_cancel_amount"]!)"
        
        let cancellationFees:Double!
        let discountAmount:Double!
        let complete_cal:Double!
        
        if let amount = convertToDouble("\(self.dict_get_booking_details["FinalFare"]!)"),
           let bookingFees = convertToDouble("\(self.dict_get_booking_details["bookingFee"]!)") {
            
            if "\(self.dict_get_booking_details["last_cancel_amount"]!)" == "" {
                 cancellationFees = convertToDouble("0.0")
            } else if "\(self.dict_get_booking_details["last_cancel_amount"]!)" == "0" {
                cancellationFees = convertToDouble("0.0")
           } else {
                 cancellationFees = convertToDouble("\(self.dict_get_booking_details["last_cancel_amount"]!)")
            }
            
            if "\(self.dict_get_booking_details["discountAmount"]!)" == "" {
                discountAmount = convertToDouble("0.0")
            } else if "\(self.dict_get_booking_details["discountAmount"]!)" == "0" {
                discountAmount = convertToDouble("0.0")
            } else {
                discountAmount = convertToDouble("\(self.dict_get_booking_details["discountAmount"]!)")
            }
             
            let totalAmount =  amount + bookingFees + cancellationFees! - discountAmount!
            
            if "\(self.dict_get_booking_details["promotional_discount"]!)" != "" {
                let pro_dis = convertToDouble("\(self.dict_get_booking_details["promotional_discount"]!)")
                print(pro_dis as Any)
                complete_cal = totalAmount - pro_dis!
                print("Complete cal: \(complete_cal!)")
                
                let final_fare = convertToDouble("\(self.dict_get_booking_details["FinalFare"]!)")
                print("Final fare: \(final_fare!)")
                
                let f_f_total = final_fare! - pro_dis!
                print("total: \(f_f_total)")
                // self.lbl_trip_fare.text = "\(str_bangladesh_currency_symbol) \(f_f_total)"
                
                
                
                let doublePrice1 = Double("\(complete_cal!)")
                let formattedNumber = String(format: "%.2f", doublePrice1!)
                self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(formattedNumber)"
                
                
                
                
                
                let doublePrice2 = Double("\(f_f_total)")
                let formattedNumber2 = String(format: "%.2f", doublePrice2!)
                cell.lbl_fare.text = "\(str_bangladesh_currency_symbol) \(formattedNumber2)"
                
                
                
                let doublePrice3 = Double("\(complete_cal!)")
                let formattedNumber3 = String(format: "%.2f", doublePrice3!)
                cell.lbl_total_amount.text = "\(str_bangladesh_currency_symbol) \(formattedNumber3)"
                
                
                
                
                if "\(self.dict_get_booking_details["discountAmount"]!)" == "" {
                    cell.lbl_discount.text = "\(str_bangladesh_currency_symbol) 0"
                } else if "\(self.dict_get_booking_details["discountAmount"]!)" == "0" {
                    cell.lbl_discount.text = "\(str_bangladesh_currency_symbol) 0"
                } else {
                    cell.lbl_discount.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["discountAmount"]!)"
                }
                
            } else {
                print("NO promotional_discount")
                
                self.lbl_price.text = "\(str_bangladesh_currency_symbol) \(totalAmount)"
                
                
                let doublePrice2 = Double("\(totalAmount)")
                let formattedNumber2 = String(format: "%.2f", doublePrice2!)
                cell.lbl_fare.text = "\(str_bangladesh_currency_symbol) \(formattedNumber2)"
                // cell.lbl_fare.text = "\(str_bangladesh_currency_symbol) \(totalAmount)"
                
                
                
                
                cell.lbl_total_amount.text = "\(str_bangladesh_currency_symbol) \(formattedNumber2)"
                
                if "\(self.dict_get_booking_details["discountAmount"]!)" == "" {
                    cell.lbl_discount.text = "\(str_bangladesh_currency_symbol) 0"
                } else if "\(self.dict_get_booking_details["discountAmount"]!)" == "0" {
                    cell.lbl_discount.text = "\(str_bangladesh_currency_symbol) 0"
                } else {
                    cell.lbl_discount.text = "\(str_bangladesh_currency_symbol) \(self.dict_get_booking_details["discountAmount"]!)"
                }
                
                
            }
            
        } else {
            print("Invalid number format in one of the strings.")
        }
        
        
        return cell
        
    }
    
    @objc func review_send() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "success_payment_id") as! success_payment
        push.str_show_total_price = "\(self.dict_get_booking_details["totalAmount"]!)"
        push.get_booking_details = self.dict_get_booking_details
        push.str_from = "yes"
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           
        return 388
    }
    
}

class ride_history_details_table_cell: UITableViewCell {
    
    @IBOutlet weak var lbl_total_fare_text:UILabel!
    @IBOutlet weak var lbl_distance_text:UILabel!
    @IBOutlet weak var lbl_total_fare_text_two:UILabel!
    @IBOutlet weak var lbl_tip_text:UILabel!
    @IBOutlet weak var lblpromotion_text:UILabel!
    @IBOutlet weak var lbl_total_amount_text:UILabel!
    
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
    
    @IBOutlet weak var lbl_from:UILabel!
    @IBOutlet weak var lbl_to:UILabel!
    
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
    
    @IBOutlet weak var lbl_fare:UILabel!
    @IBOutlet weak var lbl_tip:UILabel!
    @IBOutlet weak var lbl_promotion:UILabel!
    @IBOutlet weak var lbl_total_amount:UILabel!
    
    @IBOutlet weak var view_star:UIView! {
        didSet {
            view_star.backgroundColor = .white
            
            // shadow
            view_star.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_star.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_star.layer.shadowOpacity = 1.0
            view_star.layer.shadowRadius = 10.0
            view_star.layer.masksToBounds = false
            view_star.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var view_driver_info:UIView! {
        didSet {
            view_driver_info.backgroundColor = .white
            
            // shadow
            view_driver_info.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_driver_info.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_driver_info.layer.shadowOpacity = 1.0
            view_driver_info.layer.shadowRadius = 10.0
            view_driver_info.layer.masksToBounds = false
            view_driver_info.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var lbl_car_driver_name:UILabel!
    @IBOutlet weak var lbl_car_number:UILabel!
    @IBOutlet weak var lbl_car_color:UILabel!
    
    @IBOutlet weak var img_car_image:UIImageView! {
        didSet {
            img_car_image.layer.cornerRadius = 20
            img_car_image.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var img_driver_profile:UIImageView! {
        didSet {
            img_car_image.layer.cornerRadius = 25
            img_car_image.clipsToBounds = true
        }
    }
 
    @IBOutlet weak var img_gif:UIImageView!
    
    @IBOutlet weak var lbl_rating:UILabel!

    @IBOutlet weak var img_star_one:UIImageView!
    @IBOutlet weak var img_star_two:UIImageView!
    @IBOutlet weak var img_star_three:UIImageView!
    @IBOutlet weak var img_star_four:UIImageView!
    @IBOutlet weak var img_star_five:UIImageView!
    
    // for review
    @IBOutlet weak var lbl_star_count:UILabel! {
        didSet {
            lbl_star_count.text = "1"
        }
    }
    
    @IBOutlet weak var btn_star_one:UIButton!
    @IBOutlet weak var btn_star_two:UIButton!
    @IBOutlet weak var btn_star_three:UIButton!
    @IBOutlet weak var btn_star_four:UIButton!
    @IBOutlet weak var btn_star_five:UIButton!
    
    @IBOutlet weak var view_star_rating:UIView!
    
    @IBOutlet weak var txt_view:UITextView! {
        didSet {
            txt_view.backgroundColor = .clear
            txt_view.text = ""
        }
    }
    
    @IBOutlet weak var btn_payment_status:UIButton! {
        didSet {
             
            Utils.buttonStyle(button: btn_payment_status,
                              bCornerRadius: 12,
                              bBackgroundColor: UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1),
                              bTitle: "Submit",
                              bTitleColor: .black)
            
            btn_payment_status.layer.masksToBounds = false
            btn_payment_status.layer.shadowColor = UIColor.black.cgColor
            btn_payment_status.layer.shadowOffset =  CGSize.zero
            btn_payment_status.layer.shadowOpacity = 0.5
            btn_payment_status.layer.shadowRadius = 2
            
        }
    }
    
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
             
            Utils.buttonStyle(button: btn_submit,
                              bCornerRadius: 12,
                              bBackgroundColor: UIColor(red: 246.0/255.0, green: 200.0/255.0, blue: 68.0/255.0, alpha: 1),
                              bTitle: "Submit",
                              bTitleColor: .black)
            
            btn_submit.layer.masksToBounds = false
            btn_submit.layer.shadowColor = UIColor.black.cgColor
            btn_submit.layer.shadowOffset =  CGSize.zero
            btn_submit.layer.shadowOpacity = 0.5
            btn_submit.layer.shadowRadius = 2
            
        }
    }
    @IBOutlet weak var lbl_booking_fee:UILabel! {
        didSet {
            lbl_booking_fee.textColor = .black
        }
    }
    @IBOutlet weak var lbl_booking_fee_text:UILabel! {
        didSet {
            lbl_booking_fee_text.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_discount:UILabel! {
        didSet {
            lbl_discount.textColor = .black
        }
    }
    @IBOutlet weak var lbl_discount_text:UILabel! {
        didSet {
            lbl_discount_text.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_previuos_can_fee:UILabel! {
        didSet {
            lbl_previuos_can_fee.textColor = .black
        }
    }
    @IBOutlet weak var lbl_previuos_can_fee_text:UILabel! {
        didSet {
            lbl_previuos_can_fee_text.textColor = .black
        }
    }
}
