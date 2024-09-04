//
//  instant_booking_accept_decline.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 10/08/23.
//

import UIKit
import Alamofire
import Firebase
import AVFoundation

// MARK:- LOCATION -
import CoreLocation
import MapKit

import GoogleMaps

// google maps
// NEW
var getLoginUserLatitudeTo:String!
var getLoginUserLongitudeTo:String!
var getLoginUserAddressTo:String!
var getLoginUserLatitudeFrom:String!
var getLoginUserLongitudeFrom:String!
var getLoginUserAddressFrom:String!
var mapView: GMSMapView!

var doublePlaceStartLat:Double!
var doublePlaceStartLong:Double!
        
var doublePlaceFinalLat:Double!
var doublePlaceFinalLong:Double!

class instant_booking_accept_decline: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate {

    var dict_get_all_data_from_notification:NSDictionary!
    
    let locationManager = CLLocationManager()
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String! = "0.0"
    var strSaveLongitude:String! = "0.0"
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    // google maps
    // NEW
    var getLoginUserLatitudeTo:String!
    var getLoginUserLongitudeTo:String!
    var getLoginUserAddressTo:String!
    var getLoginUserLatitudeFrom:String!
    var getLoginUserLongitudeFrom:String!
    var getLoginUserAddressFrom:String!
    var mapView: GMSMapView!
    
    var doublePlaceStartLat:Double!
    var doublePlaceStartLong:Double!
            
    var doublePlaceFinalLat:Double!
    var doublePlaceFinalLong:Double!
    
    var timer: Timer?
    
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
                
                 
            }
            
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var lbl_distance_text:UILabel! {
        didSet {
            
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_distance_text.text = "Distance"
                } else {
                    lbl_distance_text.text = "দূরত্ব"
                }
                
                 
            }
            
            
        }
    }

    @IBOutlet weak var lbl_est_earn_text:UILabel! {
        didSet {
            
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_est_earn_text.text = "Est. earn"
                } else {
                    lbl_est_earn_text.text = "অনুমান উপার্জন"
                }
                
                 
            }
            
            // view_navigation_title.textColor = .white
        }
    }

    
    
    
    
    
    @IBOutlet weak var view_big:UIView! {
        didSet {
            view_big.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btn_accept:UIButton! {
        didSet {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_accept.setTitle("ACCEPT", for: .normal)
                } else {
                    btn_accept.setTitle("স্বীকার করুন", for: .normal)
                }
                
                 
            }
            
            
            
            btn_accept.setTitleColor(.white, for: .normal)
            btn_accept.layer.cornerRadius = 6
            btn_accept.clipsToBounds = true
            btn_accept.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
        }
    }
    @IBOutlet weak var btn_decline:UIButton! {
        didSet {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_decline.setTitle("DECLINE", for: .normal)
                } else {
                    btn_decline.setTitle("অস্বীকার করুন", for: .normal)
                }
                
                 
            }
            
            
            
            btn_decline.setTitleColor(.systemPink, for: .normal)
            btn_decline.layer.cornerRadius = 6
            btn_decline.clipsToBounds = true
            btn_decline.backgroundColor = .white
            btn_decline.layer.borderColor = UIColor.systemPink.cgColor
            btn_decline.layer.borderWidth = 2
        }
    }
    
    @IBOutlet weak var btn_distance:UIButton! {
        didSet {
            btn_distance.setTitleColor(.white, for: .normal)
            btn_distance.layer.cornerRadius = 14
            btn_distance.clipsToBounds = true
            btn_distance.backgroundColor = UIColor.init(red: 227.0/255.0, green: 230.0/255.0, blue: 244.0/255.0, alpha: 1)
        }
    }
    @IBOutlet weak var btn_est_earn:UIButton! {
        didSet {
            btn_est_earn.setTitleColor(.white, for: .normal)
            btn_est_earn.layer.cornerRadius = 14
            btn_est_earn.clipsToBounds = true
            btn_est_earn.backgroundColor = UIColor.init(red: 227.0/255.0, green: 230.0/255.0, blue: 244.0/255.0, alpha: 1)
        }
    }
    
    // @IBOutlet weak var mapView:MKMapView!
    
    @IBOutlet weak var lbl_from:UILabel!
    @IBOutlet weak var lbl_to:UILabel!
    
    @IBOutlet weak var lbl_est_earn:UILabel!
    @IBOutlet weak var lbl_distance:UILabel!
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        startTimer()
        
        print("==============================================")
        print(self.dict_get_all_data_from_notification as Any)
        print("==============================================")
        
        // booking time 
        
        // self.playNotificationSound()
        
        self.parse_all_data_and_show_UI()
        
        self.btn_accept.addTarget(self, action: #selector(validation_before_accept_booking), for: .touchUpInside)
        self.btn_decline.addTarget(self, action: #selector(cancancel_ride_click_method), for: .touchUpInside)
    }
    
    func startTimer() {
        // Invalidate any existing timer to avoid multiple timers running at the same time
        timer?.invalidate()
        
        // Create and start a new timer
        timer = Timer.scheduledTimer(withTimeInterval: 35.0, repeats: true) { [weak self] _ in
            self?.timerAction()
        }
    }

    func timerAction() {
        // This method will be called every 35 seconds
        print("Timer triggered!")
        cancancel_ride_click_method()
    }

    deinit {
        // Invalidate the timer when the view controller is deallocated to prevent memory leaks
        timer?.invalidate()
    }
    
    func playNotificationSound() {
        guard let soundURL = Bundle.main.url(forResource: "custom_not", withExtension: "wav") else {
            print("Notification sound file not found")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: soundURL)
            player?.play()
            print("PLAY NOTIFICATION")
        } catch {
            print("Error playing notification sound: \(error.localizedDescription)")
        }
    }
    
    @objc func cancancel_ride_click_method() {
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "decline_request_id") as? decline_request
        myAlert!.dict_booking_details = self.dict_get_all_data_from_notification
        myAlert!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(myAlert!, animated: true, completion: nil)*/
        
        self.timer?.invalidate()
        
        var window: UIWindow?
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let destinationController = storyboard.instantiateViewController(withIdentifier:"driver_dashboard_id") as? driver_dashboard
        let frontNavigationController = UINavigationController(rootViewController: destinationController!)
        let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC
        let mainRevealController = SWRevealViewController()
        mainRevealController.rearViewController = rearViewController
        mainRevealController.frontViewController = frontNavigationController
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController = mainRevealController
        }
        window?.makeKeyAndVisible()
        
    }
    
    @objc func parse_all_data_and_show_UI() {
        
        self.lbl_from.text = (self.dict_get_all_data_from_notification["RequestPickupAddress"] as! String)
        self.lbl_to.text = (self.dict_get_all_data_from_notification["RequestDropAddress"] as! String)
        
        let doublePrice1 = Double("\(self.dict_get_all_data_from_notification["estimateAmount"]!)")
        let formattedNumber1 = String(format: "%.2f", doublePrice1!)
        self.lbl_est_earn.text = String(formattedNumber1)
        
        self.lbl_distance.text = "\(self.dict_get_all_data_from_notification["distance"]!)"
        
        self.btn_distance.setTitle("", for: .normal)
        self.btn_est_earn.setTitle("", for: .normal)
        
        self.handleEveythingFromGoogleMapInit()
        
        // self.current_location_click_method()
        
    }

    /*@objc func current_location_click_method() {
        
         self.iAmHereForLocationPermission()
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        print(location)
        
        self.strSaveLatitude = "\(locValue.latitude)"
        self.strSaveLongitude = "\(locValue.longitude)"
        
        print("**********************")
        let customer_lat_long = "\(self.dict_get_all_data_from_notification["RequestPickupLatLong"]!)".components(separatedBy: ",")
        print(customer_lat_long)
        
        let restaurantLatitudeDouble    = Double(String(customer_lat_long[0]))
        let restaurantLongitudeDouble   = Double(String(customer_lat_long[1]))
        let driverLatitudeDouble        = Double(String(self.strSaveLatitude))
        let driverLongitudeDouble       = Double(String(self.strSaveLongitude))
        
        print(restaurantLatitudeDouble as Any)
        print(restaurantLongitudeDouble as Any)
        print(driverLatitudeDouble as Any)
        print(driverLongitudeDouble as Any)
        
        let coordinate₀ = CLLocation(latitude: restaurantLatitudeDouble!, longitude: restaurantLongitudeDouble!)
        let coordinate₁ = CLLocation(latitude: driverLatitudeDouble!, longitude: driverLongitudeDouble!)
        
        /************************************** CUSTOMER LATITUTDE AND LONGITUDE  ********************************/
        // first location
        let sourceLocation = CLLocationCoordinate2D(latitude: restaurantLatitudeDouble!, longitude: restaurantLongitudeDouble!)
        /********************************************************************************************************************/
        
        
        /************************************* DRIVER LATITUTDE AND LONGITUDE ******************************************/
        // second location
        let destinationLocation = CLLocationCoordinate2D(latitude: driverLatitudeDouble!, longitude: driverLongitudeDouble!)
        /********************************************************************************************************************/
        
        print(sourceLocation)
        print(destinationLocation)
        
        let sourcePin = customPin(pinTitle: "Drop Location", pinSubTitle: "", location: sourceLocation)
        
        let destinationPin = customPin(pinTitle: "Pick Location", pinSubTitle: "", location: destinationLocation)
        
        /***************** REMOVE PREVIUOS ANNOTATION TO GENERATE NEW ANNOTATION *******************************************/
        self.mapView.removeAnnotations(self.mapView.annotations)
        /********************************************************************************************************************/
        
        self.mapView.addAnnotation(sourcePin)
        self.mapView.addAnnotation(destinationPin)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            /***************** REMOVE PREVIUOS POLYLINE TO GENERATE NEW POLYLINE *******************************/
            let overlays = self.mapView.overlays
            self.mapView.removeOverlays(overlays)
            /************************************************************************************/
            
            
            /***************** GET DISTANCE BETWEEN TWO CORDINATES *******************************/
            
            let distanceInMeters = coordinate₀.distance(from: coordinate₁)
            // print(distanceInMeters as Any)
            
            // remove decimal
            let distanceFloat: Double = (distanceInMeters as Any as! Double)
            
            //            cell.lbl_distance.text = (String(format: "%.0f Miles away", distanceFloat/1609.344))
            
            print(String(format: "%.0f", distanceFloat/1000))
            // cell.lbl_distance.text = (String(format: "%.0f", distanceFloat/1000))
            
            print(String(format: "Distance : %.0f KM away", distanceFloat/1000))
            print(String(format: "Distance : %.0f Miles away", distanceFloat/1609.344))
            
            /************************************************************************/
            
            /***************** GENERATE NEW POLYLINE *******************************/
            
            let route = directionResonse.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            
            /***********************************************************************/
            
        }
        
        self.mapView.delegate = self
        
        self.locationManager.stopUpdatingLocation()
        
        print("=================================")
        print("LOCATION UPDATE")
        print("=================================")
        
        // self.tbleView.reloadData()
        
        // speed = distance / time
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"

        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }

        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            
            if(annotation.title == "Drop Location") {
                annotationView.image = UIImage(systemName: "car")
            } else {
                annotationView.image = UIImage(systemName: "person")
            }
            annotationView.tintColor = .systemBlue
            
            
        }

        return annotationView
    }*/
    
    @objc func validation_before_accept_booking() {
        
        self.timer?.invalidate()
        self.accept_booking_WB(str_show_loader: "yes")
    }
    
    @objc func accept_booking_WB(str_show_loader:String) {
        
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
                    "action"        : "driverconfirm",
                    "driverId"      : String(myString),
                    "bookingId"     : "\(self.dict_get_all_data_from_notification["bookingId"]!)",
                    "language"      : String(lan)
                ]
                
                print(parameters as Any)
                
                AF.request(application_base_url, method: .post, parameters: parameters as? Parameters,headers: headers).responseJSON { [self]
                    response in
                    // debugPrint(response.result)
                    
                    switch response.result {
                    case let .success(value):
                        
                        let JSON = value as! NSDictionary
                        print(JSON as Any)
                        
                        /*
                         AuthToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2OTI5Nzk1MDYsImlzcyI6ImV2aXJ0dWFsc2VydmljZXMuY29tIiwibmJmIjoxNjkyOTc5NTA2LCJleHAiOjE2OTI5ODA1MDZ9.EBgepSazmmX13i2PNyUjZynh0fCyefwgpGKw_sNz9aRyLy-dCo1-bpPjxiLj6xjRNunNrjWDvAx__XlUDsTlng";
                         RequestDropAddress = "MOD Apartment MOD Apartment";
                         RequestDropLatLong = "28.597894,77.318949";
                         RequestPickupAddress = "Sector 10 Dwarka South West Delhi New Delhi,New Delhi,India";
                         RequestPickupLatLong = "28.5823,77.05";
                         UserContactNumber = 8786878586;
                         UserName = dishu1;
                         msg = "Confirmed successfully.";
                         status = success;
                         userImage = "";
                         */
                        var strSuccess : String!
                        strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                        
                        var message : String!
                        message = (JSON["msg"] as? String)
                        
                        print(strSuccess as Any)
                        if strSuccess == String("success") {
                            print("yes")
                            
                            if (JSON["AuthToken"] == nil) {
                                print("TOKEN NOT RETURN IN THIS ACTION = driverconfirm")
                            } else {
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            }
                            
                            let db = Firestore.firestore()
                            
                            db.collection("mode/driver/tracking/India/private_track").addDocument(data: [
                                
                                "bookingId"     : "\(self.dict_get_all_data_from_notification["bookingId"]!)",
                                "driverId"      : String(myString),
                                "driverLats"    : String(self.strSaveLatitude),
                                "driverLngs"    : String(self.strSaveLongitude),
                                "time_stamp"    : 987654321,//NSDate().timeIntervalSince1970,
                                "trackingId"    : "\(self.dict_get_all_data_from_notification["bookingId"]!)+\(String(myString))",
                                
                            ]) {
                                err in
                                
                                if let err = err {
                                    print("\(err)")
                                } else {
                                    // print("\()")
                                    print("successfully registered in firebase")
                                    
                                    if (self.dict_get_all_data_from_notification["bookingTime"] == nil || self.dict_get_all_data_from_notification["bookingTime"] as! String == "") {
                                        // instant
                                        print("NORMAL BOOKING OPEN")
                                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "after_accept_request_id") as! after_accept_request
                                        push.str_from_direct_notification = "yes"
                                        push.get_booking_data_for_pickup = self.dict_get_all_data_from_notification
                                        self.navigationController?.pushViewController(push, animated: true)
                                        
                                        ERProgressHud.sharedInstance.hide()
                                        self.dismiss(animated: true)
                                    } else {
                                        // schedule
                                        print("OPEN SCHEDULE DETAILS SCREEN")
                                        
                                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "schedule_ride_details_id") as? schedule_ride_details
                                        
                                        push!.dict_get_upcoming_ride_details = self.dict_get_all_data_from_notification
                                        push!.str_from_noti = "yes"
                                        
                                        
                                        self.navigationController?.pushViewController(push!, animated: true)
                                    }
                                    
                                    
                                    
                                }
                            }
                            
                            
                            
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
                            
                            self.accept_booking_WB(str_show_loader: "no")
                            
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
    
    
    // decline
    @objc func validation_before_decline_booking() {

         // self.accept_booking_WB(str_show_loader: "yes")
    }
    
    @objc func decline_booking_WB(str_show_loader:String) {
        
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

                parameters = [
                    "action"        : "driverconfirm",
                    "driverId"      : String(myString),
                    "bookingId"     : "\(self.dict_get_all_data_from_notification["bookingId"]!)"
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
                            
                            if (JSON["AuthToken"] == nil) {
                                print("TOKEN NOT RETURN IN THIS ACTION = driverconfirm")
                            } else {
                                let str_token = (JSON["AuthToken"] as! String)
                                UserDefaults.standard.set("", forKey: str_save_last_api_token)
                                UserDefaults.standard.set(str_token, forKey: str_save_last_api_token)
                            }
                            
                            /*let db = Firestore.firestore()
                            
                            db.collection("mode/driver/tracking/India/private_track").addDocument(data: [
                                
                                "bookingId"     : "\(self.dict_get_all_data_from_notification["bookingId"]!)",
                                "driverId"      : String(myString),
                                "driverLats"    : String(self.strSaveLatitude),
                                "driverLngs"    : String(self.strSaveLongitude),
                                "time_stamp"    : "",
                                "trackingId"    : "\(self.dict_get_all_data_from_notification["bookingId"]!)+\(String(myString))",
                                
                            ]) {
                                err in
                                
                                if let err = err {
                                    print("\(err)")
                                } else {
                                    // print("\()")
                                    print("successfully registered in firebase")
                                    
                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "after_accept_request_id") as! after_accept_request
                                    push.str_from_direct_notification = "yes"
                                    push.get_booking_data_for_pickup = self.dict_get_all_data_from_notification
                                    self.navigationController?.pushViewController(push, animated: true)
                                    
                                    ERProgressHud.sharedInstance.hide()
                                    self.dismiss(animated: true)
                                }
                            }*/
                            
                            
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_for_decline_wb()
                            
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
     
    
    @objc func login_refresh_token_for_decline_wb() {
        
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
                            
                            self.decline_booking_WB(str_show_loader: "no")
                            
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
    
    
    
    
    
    @objc func handleEveythingFromGoogleMapInit() {
        
        
        /*print(self.getLoginUserLatitudeTo as Any)
        print(self.getLoginUserLongitudeTo as Any)
        print(self.getLoginUserAddressTo as Any)
        
        print(self.getLoginUserLatitudeFrom as Any)
        print(self.getLoginUserLongitudeFrom as Any)
        print(self.getLoginUserAddressFrom as Any)
        
        UserDefaults.standard.set("", forKey: "key_map_view_lat_long")
        UserDefaults.standard.set(nil, forKey: "key_map_view_lat_long")
        
        UserDefaults.standard.set("", forKey: "key_map_view_address")
        UserDefaults.standard.set(nil, forKey: "key_map_view_address")
        
        UserDefaults.standard.set("", forKey: "keyUserSelectWhichProfile")
        UserDefaults.standard.set(nil, forKey: "keyUserSelectWhichProfile")
        */
        self.initializeMap()
    }
    
    func initializeMap() {
        
        print("==============================================")
        print(self.dict_get_all_data_from_notification as Any)
        print("==============================================")
       
        let separateDropLocation    = (self.dict_get_all_data_from_notification["RequestDropLatLong"] as! String)
        let separateRequestLocation    = (self.dict_get_all_data_from_notification["RequestPickupLatLong"] as! String)
        
        let separateDropLocationArr = separateDropLocation.components(separatedBy: ",")
        let separateRequestLocationArr = separateRequestLocation.components(separatedBy: ",")
        
        let dropLatitude    = separateDropLocationArr[0]
        let dropLongitude   = separateDropLocationArr[1]
        
        let requestLatitude    = separateRequestLocationArr[0]
        let requestLongitude   = separateRequestLocationArr[1]
        
        self.doublePlaceStartLat = Double(requestLatitude)
        self.doublePlaceStartLong = Double(requestLongitude)
        
        self.doublePlaceFinalLat = Double(dropLatitude)
        self.doublePlaceFinalLong = Double(dropLongitude)
        
        debugPrint(doublePlaceStartLat as Any)
        debugPrint(doublePlaceStartLong as Any)
        debugPrint(doublePlaceFinalLat as Any)
        debugPrint(doublePlaceFinalLong as Any)
        
        let camera = GMSCameraPosition.camera(withLatitude: doublePlaceStartLat!, longitude: doublePlaceStartLong!, zoom: 10.0)
        mapView = GMSMapView(frame: .zero)
        mapView.camera = camera
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        // Set up constraints for mapView
        NSLayoutConstraint.activate([
            // Set mapView's leading and trailing constraints to the view's leading and trailing edges
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Set mapView's top constraint to 220 points from the top of the view
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            
            // Set mapView's bottom constraint to be equal to the view's bottom anchor to make it extend to the bottom
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Ensure overlayView is added after mapView so it's on top
        // view.bringSubviewToFront(view_navigation_bar)
         view.bringSubviewToFront(view_big)
        
        let placeACoordinate = CLLocationCoordinate2D(latitude: doublePlaceStartLat!, longitude: doublePlaceStartLong!)
        let placeBCoordinate = CLLocationCoordinate2D(latitude: doublePlaceFinalLat!, longitude: doublePlaceFinalLong!)
        
        addMarker(at: placeACoordinate, title: "Origin", snippet: (self.dict_get_all_data_from_notification["RequestPickupAddress"] as! String), color: .green)
        addMarker(at: placeBCoordinate, title: "Destination", snippet: (self.dict_get_all_data_from_notification["RequestDropAddress"] as! String), color: .yellow)
        
        fetchRoute(from: placeACoordinate, to: placeBCoordinate)
    }
    
    func addMarker(at position: CLLocationCoordinate2D, title: String, snippet: String,color: UIColor) {
        let marker = GMSMarker()
        marker.position = position
        marker.title = title
        marker.snippet = snippet
        
        // Set marker icon color
            marker.icon = GMSMarker.markerImage(with: color)
        
        marker.map = mapView
    }
    
    func fetchRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
        let origin = "\(self.doublePlaceStartLat!),\(self.doublePlaceStartLong!)"
        let destination = "\(self.doublePlaceFinalLat!),\(self.doublePlaceFinalLong!)"
        let apiKey = GOOGLE_MAP_API
        
        debugPrint(origin)
        debugPrint(destination)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let routes = json["routes"] as? [[String: Any]],
                   let route = routes.first,
                   let overviewPolyline = route["overview_polyline"] as? [String: Any],
                   let points = overviewPolyline["points"] as? String {
                    
                    DispatchQueue.main.async {
                        self.drawPath(fromEncodedPath: points)
                    }
                }
            } catch {
                print("JSON parsing error")
            }
        }
        
        task.resume()
    }
    
    func drawPath(fromEncodedPath encodedPath: String) {
        guard let path = GMSPath(fromEncodedPath: encodedPath) else {
            print("Failed to decode path")
            return
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 5.0
        polyline.map = mapView
        
        // Call zoom function
        zoomToFitRoute(withPath: path)
    }
    
    func zoomToFitRoute(withPath path: GMSPath) {
        let bounds = GMSCoordinateBounds(path: path)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
        mapView.animate(with: update)
        
        
        ERProgressHud.sharedInstance.hide()
        
    }
    
}
