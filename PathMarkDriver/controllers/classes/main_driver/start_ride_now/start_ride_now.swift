//
//  start_ride_now.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 10/08/23.
//

import UIKit
import Alamofire
import Firebase
import SDWebImage

// MARK:- LOCATION -
import CoreLocation
import MapKit
import GoogleMaps

class start_ride_now: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate {

    var str_from_direct_notification_start_ride:String!

    var str_check_otp:String!
    
    var firestore_id:String!
    
    var str_driver_lat:String!
    var str_driver_long:String!
    
    var str_otp_status = "0"
    var get_booking_data_for_start_ride:NSDictionary!
    
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
    
    var str_phone_number:String!
    
    //
    // google maps
    var mapView: GMSMapView!
    var doublePlaceStartLat:Double!
    var doublePlaceStartLong:Double!
    
    var doublePlaceFinalLat:Double!
    var doublePlaceFinalLong:Double!
    
    var updateTimer: Timer?
    var mapViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnShowBigView:UIButton! {
        didSet {
            btnShowBigView.tag = 0
            btnShowBigView.isHidden = true
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
                    view_navigation_title.text = "DRIVER HAS ARRIVED"
                } else {
                    view_navigation_title.text = "ড্রাইভার এসেছে"
                }
                
                 
            }
            
            view_navigation_title.textColor = .white
        }
    }
    
    @IBOutlet weak var view_big:UIView! {
        didSet {
            view_big.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btn_start_ride_now:UIButton! {
        didSet {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_start_ride_now.setTitle("START RIDE", for: .normal)
                } else {
                    btn_start_ride_now.setTitle("যাত্রা শুরু করুন", for: .normal)
                }
                
                 
            }
            
            
            btn_start_ride_now.setTitleColor(.white, for: .normal)
            btn_start_ride_now.layer.cornerRadius = 6
            btn_start_ride_now.clipsToBounds = true
            btn_start_ride_now.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
            
            // shadow
            btn_start_ride_now.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_start_ride_now.layer.shadowOffset = CGSize(width: 0, height: 3)
            btn_start_ride_now.layer.shadowOpacity = 1.0
            btn_start_ride_now.layer.shadowRadius = 10.0
            btn_start_ride_now.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var btn_decline:UIButton! {
        didSet {
            
            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                print(language as Any)
                
                if (language == "en") {
                    btn_decline.setTitle("CANCEL", for: .normal)
                } else {
                    btn_decline.setTitle("বাতিল করুন", for: .normal)
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
    
    @IBOutlet weak var lbl_from:UILabel!
    @IBOutlet weak var lbl_to:UILabel!
    
    @IBOutlet weak var btn_call:UIButton! {
        didSet {
            btn_call.layer.cornerRadius = 20
            btn_call.clipsToBounds = true
            btn_call.backgroundColor = UIColor.init(red: 210.0/255.0, green: 214.0/255.0, blue: 240.0/255.0, alpha: 1)
        }
    }
    @IBOutlet weak var btn_message:UIButton! {
        didSet {
            btn_message.layer.cornerRadius = 20
            btn_message.clipsToBounds = true
            btn_message.backgroundColor = UIColor.init(red: 210.0/255.0, green: 214.0/255.0, blue: 240.0/255.0, alpha: 1)
        }
    }
    
    // @IBOutlet weak var mapView:MKMapView!
    
    @IBOutlet weak var img_passenger_profile:UIImageView! {
        didSet {
            img_passenger_profile.layer.cornerRadius = 15
            img_passenger_profile.clipsToBounds = true
        }
    }
    @IBOutlet weak var lbl_passenger_name:UILabel!
    @IBOutlet weak var lbl_passenger_number:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.get_and_parse_UI()
        
        self.btn_start_ride_now.addTarget(self, action: #selector(validation_before_accept_booking), for: .touchUpInside)
        
        self.btn_call.addTarget(self, action: #selector(dialNumber), for: .touchUpInside)
        self.btn_message.addTarget(self, action: #selector(chat_click), for: .touchUpInside)
        
        // print(self.firestore_id as Any)
        // print(self.str_driver_lat as Any)
        // print(self.str_driver_long as Any)
        
        print("==================================================")
        print(self.str_from_direct_notification_start_ride as Any)
        print(self.get_booking_data_for_start_ride as Any)
        print("==================================================")
        
        
        if (self.get_booking_data_for_start_ride["fullName"]) == nil {
            self.lbl_passenger_name.text = (self.get_booking_data_for_start_ride["CustomerName"] as! String)
            self.lbl_passenger_number.text = (self.get_booking_data_for_start_ride["CustomerPhone"] as! String)
            self.str_phone_number = (self.get_booking_data_for_start_ride["CustomerPhone"] as! String)
            
            self.img_passenger_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.img_passenger_profile.sd_setImage(with: URL(string: (self.get_booking_data_for_start_ride!["CustomerImage"] as! String)), placeholderImage: UIImage(named: "1024"))
            
        } else {
            self.lbl_passenger_name.text = (self.get_booking_data_for_start_ride["fullName"] as! String)
            self.lbl_passenger_number.text = (self.get_booking_data_for_start_ride["contactNumber"] as! String)
            self.str_phone_number = (self.get_booking_data_for_start_ride["contactNumber"] as! String)
            
            self.img_passenger_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            self.img_passenger_profile.sd_setImage(with: URL(string: (self.get_booking_data_for_start_ride!["image"] as! String)), placeholderImage: UIImage(named: "1024"))
        }
        
        
        self.btn_decline.addTarget(self, action: #selector(cancancel_ride_click_method), for: .touchUpInside)
        
        // self.setupMap()
        // self.current_location_click_method()
    }
    
    @objc func dialNumber() {

        let url: NSURL = URL(string: "tel://\(self.str_phone_number!)")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    @objc func chat_click() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BooCheckChatId") as? BooCheckChat
                  //        push!.str_get_user_id = "\(self.get_booking_data_for_start_ride["userId"]!)"
        
        // push!.str_driver_id = "\(self.get_booking_data_for_start_ride["userId"]!)"
        push!.get_all_data = self.get_booking_data_for_start_ride
        push!.str_booking_id = "\(self.get_booking_data_for_start_ride["bookingId"]!)"
        
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func cancancel_ride_click_method() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "decline_request_id") as? decline_request
        myAlert!.dict_booking_details = self.get_booking_data_for_start_ride
        myAlert!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(myAlert!, animated: true, completion: nil)
    }
    
    /*func setupMap() {
        // Set the initial camera position (optional)
        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 10.0)
        mapViewGoogle.camera = camera
        
        // Add markers for customer and driver locations
        let customerLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let driverLocation = CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094)
        
        addMarker(at: customerLocation, title: "Customer")
        addMarker(at: driverLocation, title: "Driver")
        
        // Draw the path between customer and driver
        drawPath(from: customerLocation, to: driverLocation)
    }*/
        
        /*func addMarker(at location: CLLocationCoordinate2D, title: String) {
            let marker = GMSMarker()
            marker.position = location
            marker.title = title
            marker.map = mapViewGoogle
        }*/
        
        /*func drawPath(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
            let path = GMSMutablePath()
            path.add(source)
            path.add(destination)
            
            let polyline = GMSPolyline(path: path)
            polyline.strokeColor = .blue
            polyline.strokeWidth = 4.0
            polyline.map = mapViewGoogle
        }*/
    
    /*@objc func current_location_click_method() {
        
         self.iAmHereForLocationPermission()
    }*/
    
    /*@objc func iAmHereForLocationPermission() {
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
    }*/
    
    // MARK:- GET CUSTOMER LOCATION -
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        print(location)
        
        self.strSaveLatitude = "\(locValue.latitude)"
        self.strSaveLongitude = "\(locValue.longitude)"
        
        print("**********************")
        let customer_lat_long = "\(self.get_booking_data_for_start_ride["RequestPickupLatLong"]!)".components(separatedBy: ",")
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
    }*/
    
    /*func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.systemOrange
        renderer.lineWidth = 4.0
        return renderer
    }*/
    
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
                //
                print(self.get_booking_data_for_start_ride as Any)
                
                if (self.get_booking_data_for_start_ride["vehicleType"] == nil) {
                    annotationView.image = UIImage(systemName: "car")
                } else {
                    if ("\(self.get_booking_data_for_start_ride["vehicleType"]!)" == "2") {
                        annotationView.image = UIImage(systemName: "bicycle")
                    } else {
                        annotationView.image = UIImage(systemName: "car")
                    }
                }
                
                
            } else {
                annotationView.image = UIImage(systemName: "person")
            }
            
            
            annotationView.tintColor = .systemBlue
            
            
        }

        return annotationView
    }*/
    
    @objc func get_and_parse_UI() {
        self.btnShowBigView.addTarget(self, action: #selector(showHideBigViewClick), for: .touchUpInside)
        
        self.lbl_from.text = (self.get_booking_data_for_start_ride["RequestPickupAddress"] as! String)
        self.lbl_to.text = (self.get_booking_data_for_start_ride["RequestDropAddress"] as! String)
        
        
        // GOOGLE MAPS IMPLEMENTED
        self.setupLocationManager()
        self.initializeMap()
        self.initializeViewBig()
    }
    
    @objc func validation_before_accept_booking() {
        // self.accept_booking_WB(str_show_loader: "yes")
        self.check_and_verify_otp(str_show_loader: "yes")
    }
    
    @objc func check_and_verify_otp(str_show_loader:String) {
        // print(self.get_booking_data_for_start_ride as Any)
        
        self.verify_this(str_show_loader: "yes")
        
        /*if ("\(self.get_booking_data_for_start_ride["RideCode"]!)" == "0") {
            self.accept_booking_WB(str_show_loader: "yes")
        } else if ("\(self.get_booking_data_for_start_ride["RideCode"]!)" == "") {
            self.accept_booking_WB(str_show_loader: "yes")
        } else {
            
            if (self.str_otp_status == "0") {
                
                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                    print(language as Any)
                    
                    if (language == "en") {
                        let alert = UIAlertController(title: "Zarib Driver", message: "Please enter OTP", preferredStyle: .alert)
                        
                        //2. Add the text field. You can configure it however you need.
                        alert.addTextField { (textField) in
                            textField.placeholder = "otp..."
                            textField.keyboardType = .numberPad
                        }
                        
                        // 3. Grab the value from the text field, and print it when the user clicks OK.
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                            let textField = alert?.textFields![0]
                            print("Text field: \(textField!.text!)")
                            
                            if ("\(textField!.text!)" == "") {
                                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                    print(language as Any)
                                    
                                    if (language == "en") {
                                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter OTP"), style: .alert)
                                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                                        alert.addButtons([cancel])
                                        self.present(alert, animated: true)
                                    } else {
                                        let alert = NewYorkAlertController(title: String("সতর্কতা").uppercased(), message: String("ওটিপি দিন"), style: .alert)
                                        let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .cancel)
                                        alert.addButtons([cancel])
                                        self.present(alert, animated: true)
                                    }
                                    
                                    
                                }
                            } else {
                                self.str_check_otp = "\(textField!.text!)"
                                self.verify_this(str_show_loader: "yes")
                            }
                            
                            
                            
                        }))
                        
                        // 4. Present the alert.
                        self.present(alert, animated: true, completion: nil)
                        
                    } else {
                        let alert = UIAlertController(title: nil, message: "ওটিপি দিন", preferredStyle: .alert)
                        
                        //2. Add the text field. You can configure it however you need.
                        alert.addTextField { (textField) in
                            textField.placeholder = "otp..."
                            textField.keyboardType = .numberPad
                        }
                        
                        // 3. Grab the value from the text field, and print it when the user clicks OK.
                        alert.addAction(UIAlertAction(title: "ঠিক আছে", style: .default, handler: { [weak alert] (_) in
                            let textField = alert?.textFields![0]
                            print("Text field: \(textField!.text!)")
                            
                            if ("\(textField!.text!)" == "") {
                                if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                    print(language as Any)
                                    
                                    if (language == "en") {
                                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String("Please enter OTP"), style: .alert)
                                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                                        alert.addButtons([cancel])
                                        self.present(alert, animated: true)
                                    } else {
                                        let alert = NewYorkAlertController(title: String("সতর্কতা").uppercased(), message: String("ওটিপি দিন"), style: .alert)
                                        let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .cancel)
                                        alert.addButtons([cancel])
                                        self.present(alert, animated: true)
                                    }
                                    
                                    
                                }
                            } else {
                                self.str_check_otp = "\(textField!.text!)"
                                self.verify_this(str_show_loader: "yes")
                            }
                            
                            
                            
                        }))
                        
                        // 4. Present the alert.
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            } else {
                self.accept_booking_WB(str_show_loader: "yes")
            }
        }*/
    }
    
    @objc func verify_this(str_show_loader:String) {
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
                
                /*
                 [action] => bookingverify
                     [driverId] => 204
                     [bookingId] => 619
                     [RideCode] => 848549
                     [language] => en
                 */
                
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
                    "action"    : "bookingverify",
                    "driverId"  : String(myString),
                    "bookingId" : "\(self.get_booking_data_for_start_ride["bookingId"]!)",
                    "RideCode"  : "\(self.get_booking_data_for_start_ride["RideCode"]!)",
                    "language"  : String(lan)
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
                            
                            self.accept_booking_WB(str_show_loader: "no")
                            
                            /*ERProgressHud.sharedInstance.hide()
                            self.dismiss(animated: true)
                            
                            self.str_otp_status = "1"
                            
                            if let language = UserDefaults.standard.string(forKey: str_language_convert) {
                                print(language as Any)
                                
                                if (language == "en") {
                                    let alert = NewYorkAlertController(title: String("Success").uppercased(), message: String(message), style: .alert)
                                    let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                                    alert.addButtons([cancel])
                                    self.present(alert, animated: true)
                                } else {
                                    let alert = NewYorkAlertController(title: String("সফলতা").uppercased(), message: String(message), style: .alert)
                                    let cancel = NewYorkButton(title: "বরখাস্ত করা", style: .cancel)
                                    alert.addButtons([cancel])
                                    self.present(alert, animated: true)
                                }
                                
                                 
                            }*/
                            
                            
                            
                            // self.str_ride_code_status = "1"
                            
                        } else if message == String(not_authorize_api) {
                            self.login_refresh_token_wb()
                            
                        } else {
                            
                            // self.str_ride_code_status = "0"
                            
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
/*
 action:ridestart
 bookingId:
 driverId:
 Actual_PickupAddress:
 Actual_Pickup_Lat_Long:
 */

                parameters = [
                    "action"        : "ridestart",
                    "driverId"      : String(myString),
                    "bookingId"     : "\(self.get_booking_data_for_start_ride["bookingId"]!)",
                    "Actual_PickupAddress"  : (self.get_booking_data_for_start_ride["RequestPickupAddress"] as! String),
                    "Actual_Pickup_Lat_Long" : (self.get_booking_data_for_start_ride["RequestPickupLatLong"] as! String),
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
                            
                            self.pick_up_a_customer_click_method()
                            
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
    
    @objc func pick_up_a_customer_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ride_complete_id") as! ride_complete
        
        push.get_booking_data_for_end_ride = get_booking_data_for_start_ride
        
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    func initializeMap() {
        
        print("=====================================")
        print("=====================================")
        print(self.str_from_direct_notification_start_ride as Any)
        print(self.get_booking_data_for_start_ride as Any)
        print("=====================================")
        print("=====================================")
        
        let separateDropLocation    = (self.get_booking_data_for_start_ride["RequestDropLatLong"] as! String)
        let separateRequestLocation    = (self.get_booking_data_for_start_ride["RequestPickupLatLong"] as! String)
        
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
        
        mapViewBottomConstraint = mapView.bottomAnchor.constraint(equalTo: view_big.topAnchor)
                
                NSLayoutConstraint.activate([
                    mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
                    mapViewBottomConstraint
                ])
        
        // Ensure overlayView is added after mapView so it's on top
        view.bringSubviewToFront(view_navigation_bar)
        // view.bringSubviewToFront(view_set_name)
        
        let placeACoordinate = CLLocationCoordinate2D(latitude: doublePlaceStartLat!, longitude: doublePlaceStartLong!)
        let placeBCoordinate = CLLocationCoordinate2D(latitude: doublePlaceFinalLat!, longitude: doublePlaceFinalLong!)
        
        addMarker(at: placeACoordinate, title: "Origin", snippet: (self.get_booking_data_for_start_ride["RequestPickupAddress"] as! String), color: .green)
        addMarker(at: placeBCoordinate, title: "Destination", snippet: (self.get_booking_data_for_start_ride["RequestDropAddress"] as! String), color: .yellow)
        
        fetchRoute(from: placeACoordinate, to: placeBCoordinate)
    }
    
    func initializeViewBig() {
        view_big.translatesAutoresizingMaskIntoConstraints = false
                view_big.backgroundColor = .white
                view.addSubview(view_big)
                
                // Set up constraints for view_big
                NSLayoutConstraint.activate([
                    view_big.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    view_big.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    view_big.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    view_big.heightAnchor.constraint(equalToConstant: 300)
                ])
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
        
        self.view.bringSubviewToFront(self.view_big)
        
        // 400 milliseconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            ERProgressHud.sharedInstance.hide()
           
        }
        
        
        
        // self.refresh_location_in_firebase()
    }
    
    
    func startLocationUpdates() {
        // Start a timer to fetch the location every 10 seconds
        updateTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
    }
    
    @objc func updateLocation() {
            // Request location updates
            locationManager.requestLocation()
        }
    
    deinit {
            // Invalidate the timer when the view controller is deinitialized
            updateTimer?.invalidate()
        }
    
    // for current location
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let currentLatitude = location.coordinate.latitude
        let currentLongitude = location.coordinate.longitude
        
        print("Current Location: Latitude \(currentLatitude), Longitude \(currentLongitude)")
        
        self.strSaveLatitude = "\(currentLatitude)"
        self.strSaveLongitude = "\(currentLongitude)"
        
        locationManager.stopUpdatingLocation()
        // self.refresh_location_in_firebase()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
    }
    
    @objc func showHideBigViewClick() {
        if (self.btnShowBigView.tag == 0) {
            // Hide the view with animation
            UIView.animate(withDuration: 0.5, animations: {
                // Slide view_big back into place
                self.view_big.transform = CGAffineTransform(translationX: 0, y: self.view_big.frame.height)
                
                // Update the mapView's bottom constraint to leave space for view_big
                self.mapViewBottomConstraint.constant = self.view_big.frame.height
                self.view.layoutIfNeeded()
            })
            self.btnShowBigView.tag = 1
        } else {
            // Show the view with animation
            self.view_big.isHidden = false
            self.view_big.transform = CGAffineTransform(translationX: 0, y: self.view_big.frame.height) // Set initial position off-screen
            UIView.animate(withDuration: 0.5, animations: {
                // Slide view_big out of the screen
                self.view_big.transform = .identity
                
                
                // Update the mapView's bottom constraint to make it fill the space
                self.mapViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) { _ in
                self.view_big.isHidden = false
            }
            
            self.btnShowBigView.tag = 0
        }
        debugPrint("\(self.btnShowBigView.tag)")
        
    }

}
