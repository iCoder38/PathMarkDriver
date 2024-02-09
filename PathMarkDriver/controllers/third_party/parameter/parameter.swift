//
//  parameter.swift
//  PathMark
//
//  Created by Dishant Rajput on 12/07/23.
//

import UIKit

struct Header:Encodable {
    let alg = "HS512"
    let typ = "JWT"
}

struct main_token: Encodable {
    let body :String
}

struct main_token2: Encodable {
    let body :String
    let iat :String
    let exp :String
}

struct payload_profile: Encodable {
    let action :String
    let userId :String
}

struct payload_profile_one: Encodable {
    let action :String
    let userId :String
    let language :String
}


struct payload_login: Encodable {
    let action :String
      let email :String
      let password :String
}

struct payload_logout: Encodable {
    let action :String
    let userId :String
}

struct payload_registration: Encodable {
    let action :String
    let fullName:String
    let email:String
    let countryCode:String
    let contactNumber:String
    let password:String
    let role: String  //Member    Driver
    let INDNo:String
    let latitude:String
    let longitude:String
    let device:String
    let deviceToken:String
}

struct payload_edit_profile: Encodable {
    let action :String
    let fullName:String
    let email:String
    let countryCode:String
    let contactNumber:String
    let role: String  //Member    Driver
    let INDNo:String
    let latitude:String
    let longitude:String
    let device:String
    let deviceToken:String
}

struct payload_country_list: Encodable {
    let action :String
}

struct payload_country_list_two: Encodable {
    let action :String
    let language :String
}

struct payload_verify_OTP: Encodable {
    let action :String
    let userId :String
    let OTP :String
}

struct payload_vehicle_list: Encodable {
    let action :String
    let TYPE :String
    let language :String
}

// edit
struct payload_edit_vehicle_details: Encodable {
    let action :String
    let userId :String
    let carinformationId:String
    // let categoryId :String
    let carNumber :String
    let carModel :String
    let carYear :String
    let carColor :String
    let carBrand :String
}

// add
struct payload_add_vehicle_details: Encodable {
    let action :String
    let userId :String
    let categoryId :String
    let carNumber :String
    let carModel :String
    let carYear :String
    let carColor :String
    let carBrand :String
}

struct payload_upload_driving_license: Encodable {
    let action :String
    // let carinformationId :String
    let userId :String
    let drivingLicenceNo :String
    let LicenceExpiryDate :String
    let vechicleType :String
    let issueDate :String
}

struct payload_upload_vehicle_insurance: Encodable {
    let action :String
    let carinformationId :String
    let userId :String
    let carInsuranceNo :String
    let isurenceCompony:String
    let insurenceissueDate:String
    let policeholder:String
    let CarRegistrationNo:String
    let noOfPassagenger:String
    let expDate:String
}

struct payload_upload_vehicle_reg_permit: Encodable {
    let action :String
    let carinformationId :String
    let userId :String
    let drivingLicenceNo :String
    let CarRegistrationNo :String
    let vehiclePermitIsssuesDate :String
    let vehiclePermitIsssuesExpDate :String
    let vehicleType :String
    let registration_state :String
    
}

struct payload_dummy_create_car_info: Encodable {
    let action :String
    let userId :String
    // let carNumber:String 
}

class parameter: UIViewController {

//action:login
//mailto:email:raushan@mailinator.com
//password:123456
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
