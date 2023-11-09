//
//  start_ride_now.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 10/08/23.
//

import UIKit
import Alamofire
import Firebase

// MARK:- LOCATION -
import CoreLocation
import MapKit

class start_ride_now: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate {

    var str_from_direct_notification_start_ride:String!
    
    var firestore_id:String!
    
    var str_driver_lat:String!
    var str_driver_long:String!
    
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
    
    @IBOutlet weak var view_big:UIView! {
        didSet {
            view_big.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var btn_start_ride_now:UIButton! {
        didSet {
            btn_start_ride_now.setTitle("START RIDE NOW", for: .normal)
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
    
    @IBOutlet weak var mapView:MKMapView!
    
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
        
        // print(self.firestore_id as Any)
        // print(self.str_driver_lat as Any)
        // print(self.str_driver_long as Any)
        
        print("==================================================")
        print(self.str_from_direct_notification_start_ride as Any)
        print(self.get_booking_data_for_start_ride as Any)
        print("==================================================")
        
        
        self.lbl_passenger_name.text = (self.get_booking_data_for_start_ride["fullName"] as! String)
        self.lbl_passenger_number.text = (self.get_booking_data_for_start_ride["contactNumber"] as! String)
        
        
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
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.systemOrange
        renderer.lineWidth = 4.0
        return renderer
    }
    
    @objc func get_and_parse_UI() {
        self.lbl_from.text = (self.get_booking_data_for_start_ride["RequestPickupAddress"] as! String)
        self.lbl_to.text = (self.get_booking_data_for_start_ride["RequestDropAddress"] as! String)
    }
    
    @objc func validation_before_accept_booking() {
        self.accept_booking_WB(str_show_loader: "yes")
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
    
    @objc func pick_up_a_customer_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ride_complete_id") as! ride_complete
        
        push.get_booking_data_for_end_ride = get_booking_data_for_start_ride
        
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
}
