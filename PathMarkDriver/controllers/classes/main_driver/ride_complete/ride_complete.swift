//
//  ride_complete.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 10/08/23.
//

import UIKit
import Alamofire
import MapKit

class ride_complete: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate {

    var get_booking_data_for_end_ride:NSDictionary!

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
    
    @IBOutlet weak var view_big:UIView! {
        didSet {
            view_big.backgroundColor = .white
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
                    view_navigation_title.text = "ENJOY YOUR RIDE"
                    
                } else {
                    view_navigation_title.text = "আপনার রাইড উপভোগ করুন"
                     
                }
                
                 
            }
            
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var btn_ride_complete:UIButton! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_ride_complete.setTitle("END RIDE", for: .normal)
                } else {
                    btn_ride_complete.setTitle("শেষ রাইড", for: .normal)
                }
                
                 
            }
            
            btn_ride_complete.setTitleColor(.white, for: .normal)
            btn_ride_complete.layer.cornerRadius = 6
            btn_ride_complete.clipsToBounds = true
            btn_ride_complete.backgroundColor = .systemRed
            
            // shadow
            btn_ride_complete.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_ride_complete.layer.shadowOffset = CGSize(width: 0, height: 3)
            btn_ride_complete.layer.shadowOpacity = 1.0
            btn_ride_complete.layer.shadowRadius = 10.0
            btn_ride_complete.layer.masksToBounds = false
            
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
    
    @IBOutlet weak var view_destination:UIView! {
        didSet {
            view_destination.layer.cornerRadius = 14
            view_destination.clipsToBounds = true
            
            // shadow
            view_destination.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_destination.layer.shadowOffset = CGSize(width: 0, height: 3)
            view_destination.layer.shadowOpacity = 1.0
            view_destination.layer.shadowRadius = 10.0
            view_destination.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var lbl_drop_location:UILabel!
    
    @IBOutlet weak var lbl_distance:UILabel!
    @IBOutlet weak var lbl_duration:UILabel!
    
    @IBOutlet weak var mapView:MKMapView!
    
    @IBOutlet weak var lbl_avg_time_text:UILabel! {
        didSet {
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    lbl_avg_time_text.text = "Avg. Time"
                } else {
                    lbl_avg_time_text.text = "গড় সময়"
                }
                
                 
            }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // 
        
        self.get_and_parse_UI()
    }
    
    @objc func get_and_parse_UI() {
        
        
        print(self.get_booking_data_for_end_ride as Any)
        
        /*
         
         */
        /*
         Optional({
             CustomerImage = "https://demo4.evirtualservices.net/pathmark/img/uploads/users/1703176416PLUDIN_1703144035652.png";
             CustomerName = "biz@1";
             CustomerPhone = 9865325241;
             RequestDropAddress = "Dwarka Sector 10 Metro Station Dwarka Sector 10 Metro Station";
             RequestDropLatLong = "28.5811442,77.0574403";
             RequestPickupAddress = "Sector 10 Dwarka, South West Delhi New Delhi, India - 110075";
             RequestPickupLatLong = "28.58723476883466,77.06057780713161";
             RideCode = 632009;
             aps =     {
                 alert = "New booking request for Confir or Cancel.";
             };
             bookingDate = "12-31-1969";
             bookingId = 140;
             device = iOS;
             deviceToken = "c5gz-g9rUEqUs2qZ6PW93c:APA91bF9mr0vAtxGCzJr-_3bSVlPQUWFbfWxmOoUG0sp0VVC-oG4zPgZIT5Wdsy3UeaEwohqAAZbYgLy3R9nF640iEDIfDF4Htpe4CuZqPzdul-qPHCFl-zGeVBtmktw6aHswSrQNgOs";
             distance = "0.8";
             duration = "4 mins";
             estimateAmount = "54.6";
             "gcm.message_id" = 1707466258089135;
             "google.c.a.e" = 1;
             "google.c.fid" = "c5gz-g9rUEqUs2qZ6PW93c";
             "google.c.sender.id" = 750959835757;
             message = "New booking request for Confir or Cancel.";
             type = request;
         })
         */
        //
        UserDefaults.standard.set((self.get_booking_data_for_end_ride["RequestDropAddress"]!), forKey: "key_save_RequestDropAddress")
        UserDefaults.standard.set((self.get_booking_data_for_end_ride["RequestPickupAddress"]!), forKey: "key_save_RequestPickupAddress")
        
        if (self.get_booking_data_for_end_ride["distance"] == nil) {
            self.btn_distance.setTitle("\(self.get_booking_data_for_end_ride["totalDistance"]!)", for: .normal)
            self.lbl_distance.text = "\(self.get_booking_data_for_end_ride["totalDistance"]!)"
            
        } else {
            
            self.btn_distance.setTitle((self.get_booking_data_for_end_ride["distance"] as! String), for: .normal)
            self.lbl_distance.text = (self.get_booking_data_for_end_ride["distance"] as! String)
            
        }
        
        self.btn_est_earn.setTitle("n.a.", for: .normal)
        
        
        if (self.get_booking_data_for_end_ride["duration"] == nil ) {
            self.lbl_duration.text = "" // (self.get_booking_data_for_end_ride["duration"] as! String)
        } else {
            self.lbl_duration.text = (self.get_booking_data_for_end_ride["duration"] as! String)
        }
        
        
        self.lbl_drop_location.text = (self.get_booking_data_for_end_ride["RequestDropAddress"] as! String)
        
        self.btn_ride_complete.addTarget(self, action: #selector(validation_before_accept_booking), for: .touchUpInside)
        
        self.current_location_click_method()
        
    }
     
    
    @objc func current_location_click_method() {
        
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
        let customer_lat_long = "\(self.get_booking_data_for_end_ride["RequestDropLatLong"]!)".components(separatedBy: ",")
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
        
        // self.locManager.stopUpdatingLocation()
        
        self.locationManager.startUpdatingLocation()
        
        // self.locManager.stopUpdatingLocation()
        
        print("=================================")
        print("LOCATION UPDATE")
        print("=================================")
        
        // self.tbleView.reloadData()
        
        // speed = distance / time
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.systemPurple
        renderer.lineWidth = 4.0
        return renderer
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
    }
    
    
    @objc func validation_before_accept_booking() {
        
        
        
        if let language = UserDefaults.standard.string(forKey: str_language_convert) {
            print(language as Any)
            
            if (language == "en") {
                let alert = UIAlertController(title: String("Alert"), message: String("Are you sure you want to end your ride ?"), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "End ride", style: .default, handler: { action in
                    
                    self.locationManager.stopUpdatingLocation()
                    self.accept_booking_WB(str_show_loader: "yes")
                    
                }))
                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: String("সতর্কতা"), message: String("আপনি কি নিশ্চিত যে আপনি আপনার যাত্রা শেষ করতে চান?"), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "যাত্রা শেষ করুন", style: .default, handler: { action in
                    
                    self.locationManager.stopUpdatingLocation()
                    self.accept_booking_WB(str_show_loader: "yes")
                    
                }))
                alert.addAction(UIAlertAction(title: "খারিজ", style: .destructive, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
             
        }
        
        
        
        
        
        
        
    }
    @objc func accept_booking_WB(str_show_loader:String) {
        
        if (str_show_loader == "yes") {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
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
                    "action"        : "rideend",
                    "driverId"      : String(myString),
                    "bookingId"     : "\(self.get_booking_data_for_end_ride["bookingId"]!)",
                    "Actual_Drop_Address"  : (self.get_booking_data_for_end_ride["RequestDropAddress"] as! String),
                    "Actual_Drop_Lat_Long" : (self.get_booking_data_for_end_ride["RequestDropLatLong"] as! String),
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

                            ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
                            // self.pick_up_a_customer_click_method()
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "success_ride_done_id") as! success_ride_done
                            
                            push.str_final_price = "\(JSON["FinalFare"]!)"
                            
                            self.navigationController?.pushViewController(push, animated: true)
                            
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
            
            parameters = [
                "action"    : "login",
                "email"     : (get_login_details["email"] as! String),
                "password"  : (get_login_details["password"] as! String),
            ]
            
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
    
}
