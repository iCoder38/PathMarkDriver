//
//  AppDelegate.swift
//  PathMarkDriver
//
//  Created by Dishant Rajput on 17/07/23.
//
// 0=send, 1=accepted, 2=PickupArrived, 3=RideStart,4=dropStatus,5=PaymentDone,6=Driver Not available

import UIKit
import Firebase

import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        self.fetchDeviceToken()
        
        return true
    }
    
    // MARK:- FIREBASE NOTIFICATION -
    @objc func fetchDeviceToken() {
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                // self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
                
                let defaults = UserDefaults.standard
                defaults.set("\(token)", forKey: "key_my_device_token")
                
                
            }
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error = ",error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    /*func registerForRemoteNotification() {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
    }*/

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        let defaults = UserDefaults.standard
        
        // deviceToken
        // defaults.set("\(token)", forKey: "deviceToken")
        
        defaults.set("\(fcmToken!)", forKey: "key_my_device_token")
        
        print("\(fcmToken!)")
        
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    
    // MARK:- WHEN APP IS IN FOREGROUND - ( after click popup ) -
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //print("User Info = ",notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound,.banner])
        
        print("User Info dishu = ",notification.request.content.userInfo)
        
        let dict = notification.request.content.userInfo
        print(dict as Any)
        
        /*
         User Info dishu =  [AnyHashable("RequestPickupLatLong"): 28.5849492,77.05828439999999, AnyHashable("distance"): 21.9, AnyHashable("estimateAmount"): 21.9, AnyHashable("deviceToken"): fxAsM18HlUdQi_KqGt508b:APA91bF7gVb0tUqkJi3DP9B6capyIJ22MmI3QFl3oCUEuMvonKKXubjqhRENpVn17jDx4nNRNUjx7CbYyF_D8jucJFd2esI-NRpDSCbL9Tq4w376rDNzreB2gBALE3ohM6L4npRG3yvr, AnyHashable("bookingId"): 83, AnyHashable("duration"): 1 hour 3 mins, AnyHashable("google.c.sender.id"): 750959835757, AnyHashable("type"): request, AnyHashable("google.c.a.e"): 1, AnyHashable("RequestDropAddress"): 290, Patparganj Industrial Area, Patparganj, Delhi, 110092, India , AnyHashable("RequestDropLatLong"): 28.643166852250797,77.31291197240353, AnyHashable("CustomerPhone"): 6867675443, AnyHashable("gcm.message_id"): 1699543611604198, AnyHashable("google.c.fid"): fxAsM18HlUdQi_KqGt508b, AnyHashable("CustomerImage"): , AnyHashable("message"): New booking request for Confir or Cancel., AnyHashable("device"): iOS, AnyHashable("CustomerName"): p driver 128, AnyHashable("aps"): {
             alert = "New booking request for Confir or Cancel.";
         }, AnyHashable("RequestPickupAddress"): Sector 10 Dwarka, Dwarka, Delhi, 110075, India]
         */
        
        // if user send request
        if (dict["type"] == nil) {
            print("NOTIFICATION FROM SOMEWHERE ELSE")
        } else if (dict["type"] as! String) == "request" {
            
            if (dict["bookingTime"] == nil) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
                let destinationController = storyboard.instantiateViewController(withIdentifier:"instant_booking_accept_decline_id") as? instant_booking_accept_decline
                    
                destinationController?.dict_get_all_data_from_notification = dict as NSDictionary
                
                let frontNavigationController = UINavigationController(rootViewController: destinationController!)

                let rearViewController = storyboard.instantiateViewController(withIdentifier:"MenuControllerVCId") as? MenuControllerVC

                let mainRevealController = SWRevealViewController()

                mainRevealController.rearViewController = rearViewController
                mainRevealController.frontViewController = frontNavigationController
                
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController = mainRevealController
                }
                
                window?.makeKeyAndVisible()
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
      
                let destinationController = storyboard.instantiateViewController(withIdentifier:"schedule_notification_id") as? schedule_notification
                    
                destinationController?.dict_get_all_data_from_notification = dict as NSDictionary
                 
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
                
            
            
        } else if (dict["type"] as! String) == "Payment" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
  
            let destinationController = storyboard.instantiateViewController(withIdentifier:"success_id") as? success
                
             destinationController?.get_done_payment_details_from_notificaion = dict as NSDictionary
            // destinationController?.str_from_noti = "yes"
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
        
    }
    
    
    // MARK:- WHEN APP IS IN BACKGROUND - ( after click popup ) -
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User Info = ",response.notification.request.content.userInfo)
        
        let dict = response.notification.request.content.userInfo
        print(dict as Any)
        
        
        
        
    }
    
    
    
    
    
    
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

/*
 
 [action] => driverconfirm
     [bookingId] => 273
     [driverId] => 123
 
 [action] => driverarrived
     [bookingId] => 273
     [driverId] => 123
 
 [action] => ridestart
     [bookingId] => 273
     [driverId] => 123
     [Actual_Pickup_Lat_Long] => 28.6634489,77.3239817
     [Actual_PickupAddress] => 9/1, Block C, Yojna Vihar, Anand Vihar, Ghaziabad, Uttar Pradesh 110092, India
 
 [action] => rideend
     [bookingId] => 273
     [driverId] => 123
     [Actual_Drop_Lat_Long] => 28.6634489,77.3239817
     [Actual_Drop_Address] => 9/1, Block C, Yojna Vihar, Anand Vihar, Ghaziabad, Uttar Pradesh 110092, India
 
 */
