//
//  driver_dashboard.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 25/07/23.
//

import UIKit
import Alamofire
import Firebase

// MARK:- LOCATION -
import CoreLocation
import MapKit

import GoogleMaps

class driver_dashboard: UIViewController, CLLocationManagerDelegate  {
    
    var mapViewGoogle: GMSMapView! // google map
    let locationManager = CLLocationManager()
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String!
    var strSaveLongitude:String!
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    var str_token_id:String!
    
    // var db = Firestore.firestore()
    
    @IBOutlet weak var lbl_offline_status:UILabel!
    @IBOutlet weak var view_offline:UIView!
    
    @IBOutlet weak var lbl_total_price:UILabel!
    
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
                    view_navigation_title.text = "Dashboard"
                } else {
                    view_navigation_title.text = "ড্যাশবোর্ড"
                }
                
                view_navigation_title.textColor = .white
            }
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var view_big:UIView! {
        didSet {
            view_big.backgroundColor = UIColor.init(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var view_sub_big:UIView! {
        didSet {
            view_sub_big.backgroundColor = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
            view_sub_big.layer.cornerRadius = 8
            view_sub_big.clipsToBounds = true
        }
    }
     @IBOutlet weak var mapView:MKMapView!
    
    var str_switch_value:String!
    
    @IBOutlet weak var switch_value:UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.sideBarMenu()
        
        // self.update_token_WB(str_show_loader: "yes")
        //self.iAmHereForLocationPermission()
        
        
        if let device_token = UserDefaults.standard.string(forKey: "key_my_device_token") {
            
            self.str_token_id = String(device_token)
            
        }
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            if ("\(person["DriverOn"]!)" == "0") {
                // false
                self.str_switch_value = "0"
                switch_value.isOn = false
                self.lbl_offline_status.text = "You are offline"
                self.view_offline.backgroundColor = .systemOrange
            } else {
                // true
                self.str_switch_value = "1"
                switch_value.isOn = true
                self.lbl_offline_status.text = "You are online"
                self.view_offline.backgroundColor = .systemGreen
            }
        }
        
        self.switch_value.addTarget(self, action: #selector(switch_click_method), for: .valueChanged)
        
        self.mapView.isHidden = true
        
        // Initialize the location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // self.custom_google_map()
        
        //
        // self.ride_end(str_show_loader: "yes")
        
    }
    // CLLocationManagerDelegate method to receive location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            // Parse latitude and longitude
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            self.strSaveLatitude = "\(latitude)"
            self.strSaveLongitude = "\(longitude)"
            
            // Initialize the map view with the current location
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
            
            let mapViewFrame = CGRect(x: 0, y: 128, width: self.view.frame.width, height: self.view.frame.height)
            mapViewGoogle = GMSMapView(frame: mapViewFrame)
            
            mapViewGoogle.camera = camera
            mapViewGoogle.isMyLocationEnabled = true
            self.view.addSubview(mapViewGoogle)
            
            /*// Show 20 km radius
            let radiusInMeters: Double = 200000
            let circle = GMSCircle(position: mapViewGoogle.camera.target, radius: radiusInMeters)
            circle.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.1) // Adjust circle fill color
            circle.strokeColor = UIColor.blue // Adjust circle border color
            circle.strokeWidth = 2 // Adjust circle border width
            circle.map = mapViewGoogle
            
            // Adjust camera to fit the circle
            let bounds = GMSCoordinateBounds(coordinate: circle.position, coordinate: circle.position)
            let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
            mapViewGoogle.animate(with: update)*/
            
            // Create a marker at the user's location
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            marker.title = "You are here"
            // Set custom image as marker icon
            if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                print(person)
                
                var ar : NSArray!
                ar = (person["carinfromation"] as! Array<Any>) as NSArray
                
                let arr_mut_order_history:NSMutableArray! = []
                arr_mut_order_history.addObjects(from: ar as! [Any])
                print(arr_mut_order_history as Any)
                
                let item = arr_mut_order_history[0] as? [String:Any]
                print(item as Any)
                
                // noOfPassagenger
                if ("\(item!["vehicleType"]!)" == "2") {
                    marker.icon = UIImage(named: "map_bike")
                } else {
                    marker.icon = UIImage(named: "map_car")
                }
                
                
            }
            
            marker.map = mapViewGoogle
            
            self.update_token_WB(str_show_loader: "yes")
            
            //                "latitude"      : String(self.strSaveLatitude),
            //                "longitude"     : String(self.strSaveLongitude),
            //
            //                self.update_token_WB(str_show_loader: "yes")
        }
    }

        // CLLocationManagerDelegate method to handle authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // Handle the case where the user denied location permissions
            print("Location access denied")
        case .notDetermined:
            // Handle the case where location permission is not determined
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError()
        }
    }
    /*@objc func custom_google_map() {
        // Create a GMSCameraPosition that tells the map to display the coordinate at zoom level 10.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    // CLLocationManagerDelegate method to receive location updates
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
                mapViewGoogle.animate(to: camera)

                // Create a marker at the user's location
                let marker = GMSMarker()
                marker.position = location.coordinate
                marker.title = "You are here"
                marker.map = mapViewGoogle

                // Stop updating location to save battery life
                locationManager.stopUpdatingLocation()
            }
        }

        // CLLocationManagerDelegate method to handle authorization changes
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            case .denied, .restricted:
                // Handle the case where the user denied location permissions
                print("Location access denied")
            case .notDetermined:
                // Handle the case where location permission is not determined
                locationManager.requestWhenInUseAuthorization()
            @unknown default:
                fatalError()
            }
        }*/
    
    
    @objc func switch_click_method() {
        print(self.switch_value.isOn)
        
        self.update_switch(str_show_loader: "yes")
    }
    
    @objc func iAmHereForLocationPermission() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
              
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.strSaveLatitude = "0"
                self.strSaveLongitude = "0"
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                          
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                      
            @unknown default:
                break
            }
        }
    }
    
    // MARK:- GET CUSTOMER LOCATION -
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! PDBagPurchaseTableCell
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        location.fetchCityAndCountry { city, country, zipcode,localAddress,localAddressMini,locality, error in
            guard let city = city, let country = country,let zipcode = zipcode,let localAddress = localAddress,let localAddressMini = localAddressMini,let locality = locality, error == nil else { return }
            
            self.strSaveCountryName     = country
            self.strSaveStateName       = city
            self.strSaveZipcodeName     = zipcode
            
            self.strSaveLocalAddress     = localAddress
            self.strSaveLocality         = locality
            self.strSaveLocalAddressMini = localAddressMini
            
            let doubleLat = locValue.latitude
            let doubleStringLat = String(doubleLat)
            
            let doubleLong = locValue.longitude
            let doubleStringLong = String(doubleLong)
            
            self.strSaveLatitude = String(doubleStringLat)
            self.strSaveLongitude = String(doubleStringLong)
            
            print("local address ==> "+localAddress as Any) // south west delhi
            print("local address mini ==> "+localAddressMini as Any) // new delhi
            print("locality ==> "+locality as Any) // sector 10 dwarka
            
            print(self.strSaveCountryName as Any) // india
            print(self.strSaveStateName as Any) // new delhi
            print(self.strSaveZipcodeName as Any) // 110075
            
            //MARK:- STOP LOCATION -
            self.locationManager.stopUpdatingLocation()
            
            print(self.strSaveLatitude as Any)
            print(self.strSaveLongitude as Any)

            let newYorkLocation = CLLocationCoordinate2DMake(locValue.latitude, locValue.longitude)
            // Drop a pin
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = newYorkLocation
            dropPin.title = "My Current Location"
            self.mapView.addAnnotation(dropPin)
            
            UserDefaults.standard.set(self.strSaveLatitude, forKey: "key_current_latitude")
            UserDefaults.standard.set(self.strSaveLongitude, forKey: "key_current_latitude")
            UserDefaults.standard.set(locality+","+localAddress+","+localAddressMini, forKey: "key_current_address")
            
            self.update_token_WB(str_show_loader: "yes")
        }
    }*/
    
    @objc func sideBarMenu() {
        
        if revealViewController() != nil {
            
            self.btn_back.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
    }
    
    @objc func update_token_WB(str_show_loader:String) {
        
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
            
            var ar : NSArray!
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            let arr_mut_order_history:NSMutableArray! = []
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
                parameters = [
                    "action"        : "editprofile",
                    "userId"        : String(myString),
                    "deviceToken"   : String(self.str_token_id),
//                     "latitude"      : "28.663360225298394", // String(self.strSaveLatitude),
//                     "longitude"     : "77.32386478305855", // String(self.strSaveLongitude),
                    "latitude"      : String(self.strSaveLatitude),
                    "longitude"     : String(self.strSaveLongitude),
                    "device"        : String("iOS")
                ]
                
                print(parameters as Any)
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON {
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
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(JSON["data"], forKey: str_save_login_user_data)
                            
                            let str_token = (JSON["AuthToken"] as! String)
                            UserDefaults.standard.set("", forKey: str_save_last_api_token)
                            UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            
                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
                            if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                                print(person)
                                
                                if ("\(person["DriverOn"]!)" == "0") {
                                    // false
                                    self.str_switch_value = "0"
                                    self.switch_value.isOn = false
                                    
                                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                        print(language as Any)
                                        
                                        if (language == "en") {
                                            self.lbl_offline_status.text = "You are offline"
                                        } else {
                                            self.lbl_offline_status.text = "আপনি অফলাইনে আছেন"
                                        }
                                    }
                                    
                                    
                                    self.view_offline.backgroundColor = .systemOrange
                                } else {
                                    // true
                                    self.str_switch_value = "1"
                                    self.switch_value.isOn = true
                                    
                                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                        print(language as Any)
                                        
                                        if (language == "en") {
                                            self.lbl_offline_status.text = "You are online"
                                        } else {
                                            self.lbl_offline_status.text = "আপনি অনলাইনে আছেন"
                                        }
                                    }
                                    
                                    
                                    self.view_offline.backgroundColor = .systemGreen
                                }
                            }
                            // self.get_todays_earning_WB(str_show_loader: "no")
                            
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
                            
                            self.update_token_WB(str_show_loader: "no")
                            
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
    

    
    
    // today's earning
    @objc func get_todays_earning_WB(str_show_loader:String) {
        
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
            
            var ar : NSArray!
            ar = (person["carinfromation"] as! Array<Any>) as NSArray
            
            let arr_mut_order_history:NSMutableArray! = []
            arr_mut_order_history.addObjects(from: ar as! [Any])
            
            if let token_id_is = UserDefaults.standard.string(forKey: str_save_last_api_token) {
                print(token_id_is as Any)
                
                let headers: HTTPHeaders = [
                    "token":String(token_id_is),
                ]
                
                parameters = [
                    "action"        : "earninghistory",
                    "userId"        : String(myString),
                    "usertype"      : String("Driver"),
                    "reportType"    : String("TODAY"),
                ]
                
                print(parameters as Any)
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON {
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
                            
                            self.lbl_total_price.text = "\(JSON["totalDriverAmount"]!)"
                            
                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_for_earning_wb()
                            
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
    
    @objc func login_refresh_token_for_earning_wb() {
        
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
                            
                            self.get_todays_earning_WB(str_show_loader: "no")
                            
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
    
    @objc func update_switch(str_show_loader:String) {
       
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
        
        if (self.switch_value.isOn == true) {
            self.str_switch_value = "1"
        } else {
            self.str_switch_value = "0"
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
                
                parameters = [
                    "action"    : "editprofile",
                    "userId"    : String(myString),
                    "DriverOn"  : String(self.str_switch_value),
                    
                ]
                
                print(parameters as Any)
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON {
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
                            
                            let defaults = UserDefaults.standard
                            defaults.setValue(JSON["data"], forKey: str_save_login_user_data)
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
                                print(person)
                                
                                if ("\(person["DriverOn"]!)" == "0") {
                                    // false
                                    self.str_switch_value = "0"
                                    self.switch_value.isOn = false
                                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                        print(language as Any)
                                        
                                        if (language == "en") {
                                            self.lbl_offline_status.text = "You are offline"
                                        } else {
                                            self.lbl_offline_status.text = "আপনি অফলাইনে আছেন"
                                        }
                                    }
                                    self.view_offline.backgroundColor = .systemOrange
                                } else {
                                    // true
                                    self.str_switch_value = "1"
                                    self.switch_value.isOn = true
                                    if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                        print(language as Any)
                                        
                                        if (language == "en") {
                                            self.lbl_offline_status.text = "You are online"
                                        } else {
                                            self.lbl_offline_status.text = "আপনি অনলাইনে আছেন"
                                        }
                                    }
                                    self.view_offline.backgroundColor = .systemGreen
                                }
                            }
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_for_update_switch_wb()
                            
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
            } else {
                self.login_refresh_token_wb()
            }
        }
    }
        
    
    @objc func login_refresh_token_for_update_switch_wb() {
        
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

                            self.update_switch(str_show_loader: "no")
                            
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
