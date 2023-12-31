//
//  after_accept_request.swift
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

class after_accept_request: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate {

    var store_firestore_id:String!
    
    var get_booking_data_for_pickup:NSDictionary!
    
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
    
    @IBOutlet weak var btn_accept:UIButton! {
        didSet {
            btn_accept.setTitle("PICKUP", for: .normal)
            btn_accept.setTitleColor(.white, for: .normal)
            btn_accept.layer.cornerRadius = 6
            btn_accept.clipsToBounds = true
            btn_accept.backgroundColor = UIColor.init(red: 104.0/255.0, green: 218.0/255.0, blue: 134.0/255.0, alpha: 1)
        }
    }
    @IBOutlet weak var btn_decline:UIButton! {
        didSet {
            btn_decline.setTitle("DECLINE", for: .normal)
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
    
    // @IBOutlet weak var lbl_customer_name:UILabel!
    // @IBOutlet weak var lbl_customer_name:UILabel!
    @IBOutlet weak var mapView:MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.get_and_parse_UI()
        
        self.btn_accept.addTarget(self, action: #selector(validation_before_accept_booking), for: .touchUpInside)
    }
    
    @objc func get_and_parse_UI() {
        self.lbl_from.text = (self.get_booking_data_for_pickup["RequestPickupAddress"] as! String)
        self.lbl_to.text = (self.get_booking_data_for_pickup["RequestDropAddress"] as! String)
        
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
        let customer_lat_long = "\(self.get_booking_data_for_pickup["RequestPickupLatLong"]!)".components(separatedBy: ",")
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
        
        self.locationManager.startUpdatingLocation()
        
        print("=================================")
        print("LOCATION UPDATE")
        print("=================================")
        
        self.refresh_location_in_firebase()
    }
  
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.systemBrown
        renderer.lineWidth = 4.0
        return renderer
    }
    
    @objc func refresh_location_in_firebase() {
        
        if let person = UserDefaults.standard.value(forKey: str_save_login_user_data) as? [String:Any] {
            print(person)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            // let db = Firestore.firestore()
                   
            let tracking_id_is = "\(self.get_booking_data_for_pickup["bookingId"]!)+\(String(myString))"
            print(tracking_id_is as String)
            
            self.get_document_id(tracking_id: tracking_id_is)
            
      
        }
    }
    
    @objc func get_document_id(tracking_id:String) {
        // self.locationManager.stopUpdatingLocation()
        
        let db = Firestore.firestore()
        
        let friendsCollection = db
            
            .collection(send_tracking_path_to_real_time)
        
        //self.db points to my firebase
            let query = friendsCollection.whereField("trackingId", isEqualTo: String(tracking_id))
                                         // .whereField("requests", arrayContains: "uid_0")
            query.getDocuments(completion: { snapshot, error in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }

                guard let docs = snapshot?.documents else { return }

                for doc in docs {
                    let docId = doc.documentID
                    print(docId)
                    
                    self.store_firestore_id = String(docId)
                    
                    self.update_tracking_id_after_get_doc_id(tracking_id_after_doc_id: docId)
                }
            })
    }
    
    @objc func update_tracking_id_after_get_doc_id(tracking_id_after_doc_id:String) {
        
        let db = Firestore.firestore()

        let updateReference = db.collection(send_tracking_path_to_real_time)
            .document(String(tracking_id_after_doc_id))
        
        updateReference.getDocument { (document, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            else {
                document?.reference.updateData([
                    "driverLats": String(self.strSaveLatitude),
                    "driverLngs": String(self.strSaveLongitude)
                ])
               
            }
        }
        
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
                
                parameters = [
                    "action"    : "driverarrived",
                    "driverId"  : String(myString),
                    "bookingId" : "\(self.get_booking_data_for_pickup["bookingId"]!)",
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
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "start_ride_now_id") as! start_ride_now
        
        push.str_driver_lat = String(self.strSaveLatitude)
        push.str_driver_long = String(self.strSaveLongitude)
        
        push.firestore_id = String(self.store_firestore_id)
        push.get_booking_data_for_start_ride = get_booking_data_for_pickup
        
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
}
