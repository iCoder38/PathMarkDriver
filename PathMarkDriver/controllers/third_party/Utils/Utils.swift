
//

import UIKit
import CoreLocation
import SystemConfiguration
import MapKit

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
    }
}

// MARK:- BASE URL -
let application_base_url = "https://demo4.evirtualservices.net/pathmark/services/index"

// sh 512 token key
let sha_token_api_key = "68V0zWFrS72GbpPreidkQFLfj4v9m3Ti+DXc8OB0gcM="

// 207,231,244
let navigation_color = UIColor.init(red: 36.0/255.0, green: 22.0/255.0, blue: 93.0/255.0, alpha: 1)

let APP_BASIC_COLOR = UIColor.init(red: 50.0/255.0, green: 97.0/255.0, blue: 138.0/255.0, alpha: 1)

let BUTTON_DARK_APP_COLOR = UIColor.init(red: 169.0/255.0, green: 163.0/255.0, blue: 131.0/255.0, alpha: 1)

let APP_BUTTON_COLOR = UIColor.black// UIColor.init(red: 43.0/255.0, green: 100.0/255.0, blue: 191.0/255.0, alpha: 1)

let button_dark = UIColor.init(red: 64.0/255.0, green: 112.0/255.0, blue: 216.0/255.0, alpha: 1)
let button_light = UIColor.init(red: 200.0/255.0, green: 223.0/255.0, blue: 254.0/255.0, alpha: 1)

let NAVIGATION_TITLE_COLOR  = UIColor.white
let NAVIGATION_BACK_COLOR   = UIColor.white
let CART_COUNT_COLOR        = UIColor.black


// URLs
let URL_HARILOSS_SUPPORT_GROUP  = "https://www.google.co.in"



// key saved login user data
let str_save_login_user_data = "keyLoginFullData"
let str_save_email_password = "key_save_email_password"
let str_save_last_api_token = "key_last_api_token"


let not_authorize_api = "You are not authorize to access the API"

// order food fees
let delivery_fee = "2.5"
let service_fee = "1.5"
let membership_fee = "0.0"
let donation_fee = "0.0"
let taxes = "20.0"


let ALERT_MESSAGE       = "Alert!"

// SERVER ISSUE
let SERVER_ISSUE_TITLE          = "Server Issue."
let SERVER_ISSUE_MESSAGE        = "Server Not Responding. Please check your Internet Connection."
let SERVER_ISSUE_MESSAGE_TWO    = "Please contact to Server Admin."


// NAVIGATION TITLES
let WELCOME_PAGE_NAVIGATION_TITLE = "CONTINUE AS A"
let DISCLAIMER_PAGE_NAVIGATION_TITLE = "Disclaimer"
let REGISTRATION_PAGE_NAVIGATION_TITLE = "Registration"
let COMPLETE_ADDRESS_PAGE_NAVIGATION_TITLE = "Complete address"
let LOGIN_PAGE_NAVIGATION_TITLE = "Login"
let DASHBOARD_PAGE_NAVIGATION_TITLE = "Dashboard"
let ORDER_FOOD_PAGE_NAVIGATION_TITLE = "Order food"
let CART_LIST_NAVIGATION_TITLE = "CART"
let REVIEW_ORDER_NAVIGATION_TITLE = "REVIEW ORDER"
let DELIVERY_ADDRESS_NAVIGATION_TITLE = "DELIVERY ADDRESS"
let SUCCESS_NAVIGATION_TITLE = "SUCCESS"
let FOOD_ORDER_DETAILS_NAVIGATION_TITLE = "FOOD ORDER DETAILS"
let FORGOT_PASSWORD_NAVIGATION_TITLE = "FORGOT PASSWORD"
let CHANGE_PASSWORD_NAVIGATION_TITLE = "CHANGE PASSWORD"
let PAYMENT_NAVIGATION_TITLE = "PAYMENT"
let CASHAPP_NAVIGATION_TITLE = "CASHAPP"
let FOODVERIFICATION_NAVIGATION_TITLE = "VERIFICATION"
let VerificationNotification_NAVIGATION_TITLE = "ORDER PICKED UP CONFIRMED"
//let DELIVERY_NAVIGATION_TITLE = "ORDER PICKED UP CONFIRMED"
let ORDERHISTORY_NAVIGATION_TITLE = "ORDER HISTORY"
let ORDERHISTOR_Details_NAVIGATION_TITLE = "Details"
let JOBHISTORY_NAVIGATION_TITLE = "JOB HISTORY"
let booking_order_details = "Booking details"
// let driver_accept_request = "Booking details"


 
/******************************************/
let send_tracking_path_to_real_time = "mode/driver/tracking/India/private_track"
/******************************************/

class Utils: NSObject {
    
    
    
    // text field
    class func text_field_UI(text_field:UITextField) {
        text_field.layer.cornerRadius = 22
        text_field.clipsToBounds = true
        text_field.backgroundColor = button_light
        text_field.setLeftPaddingPoints(20)
        text_field.textColor = .black
        text_field.layer.borderColor = button_dark.cgColor
        text_field.layer.borderWidth = 1
        
        /*text_field.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
         text_field.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
         text_field.layer.shadowOpacity = 1.0
         text_field.layer.shadowRadius = 15.0
         text_field.layer.masksToBounds = false*/
    }
    
    class func showAlert(alerttitle :String, alertmessage: String,ButtonTitle: String, viewController: UIViewController) {
        
        let alertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle: .alert)
        let okButtonOnAlertAction = UIAlertAction(title: ButtonTitle, style: .default)
        { (action) -> Void in
            //what happens when "ok" is pressed
            
        }
        alertController.addAction(okButtonOnAlertAction)
        alertController.show(viewController, sender: self)
        
    }
    
    // button
    class func textFieldUI(textField:UITextField,tfName:String,tfCornerRadius:CGFloat,tfpadding:CGFloat,tfBorderWidth:CGFloat,tfBorderColor:UIColor,tfAppearance:UIKeyboardAppearance,tfKeyboardType:UIKeyboardType,tfBackgroundColor:UIColor,tfPlaceholderText:String) {
        textField.text = tfName
        textField.layer.cornerRadius = tfCornerRadius
        textField.clipsToBounds = true
        textField.setLeftPaddingPoints(tfpadding)
        textField.layer.borderWidth = tfBorderWidth
        textField.layer.borderColor = tfBorderColor.cgColor
        textField.keyboardAppearance = tfAppearance
        textField.keyboardType = tfKeyboardType
        textField.backgroundColor = tfBackgroundColor
        textField.placeholder = tfPlaceholderText
    }
    
    //MARK:- TEXT FIELD UI -
    class func setPaddingWithImage(textfield: UITextField,placeholder:String,bottomLineColor:UIColor) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1)
        bottomLine.backgroundColor = bottomLineColor.cgColor
        textfield.borderStyle = UITextField.BorderStyle.none
        textfield.layer.addSublayer(bottomLine)
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textfield.frame.height))
        textfield.placeholder = placeholder
        textfield.leftViewMode = .always
        
        textfield.backgroundColor = .clear
    }
    
    /*
     btnDriver.layer.cornerRadius = 8
     btnDriver.clipsToBounds = true
     btnDriver.backgroundColor = NAVIGATION_COLOR
     btnDriver.setTitleColor(.black, for: .normal)
     btnDriver.setTitle("Driver", for: .normal)
     */
    
    // button
    class func buttonStyle(button:UIButton,bCornerRadius:CGFloat,bBackgroundColor:UIColor,bTitle:String,bTitleColor:UIColor) {
        button.layer.cornerRadius = bCornerRadius
        button.clipsToBounds = true
        button.backgroundColor = bBackgroundColor
        button.setTitle(bTitle, for: .normal)
        button.setTitleColor(bTitleColor, for: .normal)
    }
    
    // text field
    class func textFieldStyle(textField:UITextField,tfCornerRadius:CGFloat,tfBackgroundColor:UIColor,tfTitle:String,tfTitleColor:UIColor,tfpadding:CGFloat) {
        textField.layer.cornerRadius = tfCornerRadius
        textField.clipsToBounds = true
        textField.backgroundColor = tfBackgroundColor
        textField.text = tfTitle
        textField.textColor = tfTitleColor
        textField.setLeftPaddingPoints(tfpadding)
    }
    
    
    // MARK:- SCREEN ( MEMBERSHIP ) -
    /*
     btnSelectFour.layer.borderWidth = 1
     btnSelectFour.layer.borderColor = UIColor.white.cgColor
     btnSelectFour.layer.cornerRadius = 15
     btnSelectFour.clipsToBounds = true
     */
    
    class func membershipButtonStyle(button:UIButton,bCornerRadius:CGFloat,bBackgroundColor:UIColor,bBorderWidth:CGFloat,bBorderColor:UIColor) {
        button.layer.cornerRadius = bCornerRadius
        button.clipsToBounds = true
        button.backgroundColor = bBackgroundColor
        button.layer.borderWidth = bBorderWidth
        button.layer.borderColor = bBorderColor.cgColor
    }
    
    
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func validpassword(mypassword : String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        // let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: mypassword)
        
        
    }
    
    
    
    
}


extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?,_ country: String?, _ zipcode:  String?, _ localAddress:  String?, _ locality:  String?, _ subLocality:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality,$0?.first?.country, $0?.first?.postalCode,$0?.first?.subAdministrativeArea,$0?.first?.locality,$0?.first?.subLocality, $1) }
    }
    
    func countryCode(completion: @escaping (_ countryCodeIs:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.isoCountryCode, $1) }
    }
    
    func fullAddressFull(completion: @escaping (_ city: String?,_ country: String?, _ zipcode:  String?, _ localAddress:  String?, _ locality:  String?, _ subLocality:  String?,_ countryCodeIs:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality,$0?.first?.country, $0?.first?.postalCode,$0?.first?.administrativeArea,$0?.first?.locality,$0?.first?.subLocality,$0?.first?.isoCountryCode, $1) }
    }
}

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}

extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}

extension String {
    
    func toAttributed(alignment: NSTextAlignment) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return toAttributed(attributes: [.paragraphStyle: paragraphStyle])
    }
    
    func toAttributed(attributes: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
    
}

extension UIViewController {
    
    @IBAction func showAlertButtonTapped(_ sender: UIButton) {

        // create the alert
        let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func scroll_to_top(table_view:UITableView) {
        
        let topRow = IndexPath(row: 0, section: 0)
        table_view.scrollToRow(at: topRow, at: .top, animated: true)
        
    }
    
    func show_gif_loader() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "ViewController_id")
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(myAlert, animated: true, completion: nil)
        
    }
    
    func show_custom_alert() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "custom_alert_show_id") as? custom_alert_show
        myAlert!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(myAlert!, animated: true, completion: nil)
        
    }
    
    func show_loading_UI() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "ViewController_id")
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(myAlert, animated: true, completion: nil)
        
    }
    
    func hide_loading_UI() {
        
        dismiss(animated: true)
        
    }
    
    @objc func scroll_to_bottom(table_view:UITableView) {
        
        let topRow = IndexPath(row: 0, section: 0)
        table_view.scrollToRow(at: topRow, at: .bottom, animated: true)
        
    }
    
    //    // MARK: - BACK CLICK -
        @objc func back_click_method() {
            self.navigationController?.popViewController(animated: true)
        }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        
    }
    
    @objc func please_check_your_internet_connection() {
        
        /*let alert = NewYorkAlertController(title: String("Error").uppercased(), message: String("Please check your internet connection."), style: .alert)
        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
        alert.addButtons([cancel])
        self.present(alert, animated: true)
         */
        
    }
    
    
    // For check Internet Connection
    class open func IsInternetAvailable () -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
        
    }
    
    
    // For Convert to JSON String
    class open func toJsonString(parameters:[String:AnyObject]) -> String
    {
        var jsonData: NSData?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: parameters, options:JSONSerialization.WritingOptions(rawValue: 0)) as NSData?
        } catch{
            print(error.localizedDescription)
            jsonData = nil
        }
        
        let jsonString = NSString(data: jsonData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return jsonString
    }
    
    // For Convert to Base64Encoded String
    class open func toBase64EncodedString(_ jsonString : String) -> String {
        let utf8str = jsonString.data(using: .utf8)
        let base64Encoded = utf8str?.base64EncodedString(options: [])
        return base64Encoded!
    }
    
    @objc func manage_profile(_ sender:UIButton) {
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                sender.setImage(UIImage(systemName: "list.dash"), for: .normal)
                self.side_bar_menu_click(sender)
            } else {
                // back
                sender.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
            }
        } else {
            // back
            sender.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            sender.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        }
        
    }
    
    // MARK: - SIDE BAR MENU -
    @objc func side_bar_menu_click(_ sender:UIButton) {
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keySetToBackOrMenu")
        defaults.setValue(nil, forKey: "keySetToBackOrMenu")
        
        self.view.endEditing(true)
        /*if revealViewController() != nil {
            sender.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }*/
    }
    
    // MARK: - BACK CLICK -
//    @objc func back_click_method() {
//        self.navigationController?.popViewController(animated: true)
//    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    func addDashBorder() {
        let color = UIColor.systemGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.name = "DashBorder"
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [2,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath
        
        self.layer.masksToBounds = false
        
        self.layer.addSublayer(shapeLayer)
    }
}

extension Data {
    func urlSafeBase64EncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

 
