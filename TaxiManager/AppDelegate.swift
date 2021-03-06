
//
//  AppDelegate.swift
//  TaxiManager
//
//  Created by Esdras Martins on 06/10/17.
//  Copyright © 2017 Taxi Manager. Al}l rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
//            if (error == nil){
//                print("Successful Authorization")
//            }
//        }
//    application.registerForRemoteNotifications()
//
//
//
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshToken(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        GMSServices.provideAPIKey("AIzaSyDOebYw-atZqhQxDKX-D5Ps5Dje0f29RSo")
        GMSPlacesClient.provideAPIKey("AIzaSyDOebYw-atZqhQxDKX-D5Ps5Dje0f29RSo")
        
        let statusBar = application.value(forKey: "statusBar") as? UIView
        statusBar?.backgroundColor = UIColor(red: 36/255.0, green: 36/255.0, blue: 36/255.0, alpha: 1.0)
        
        let currentUser = UserDefaults.standard.value(forKey: "user")
        if let currentUser = currentUser as? Data{
            
            print("TEM USUARIO LOGADO")
            MBUser.currentUser = try? JSONDecoder().decode(MBUser.self, from: currentUser) as MBUser
            let user = MBUser.currentUser
            
            if (user?.statusID == 2){
                print("usuario com status 2")
                MBUser.logout()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier :"MBLoginViewController")
                self.window?.rootViewController = viewController
                
            }else if (user?.statusID == 3){
                print("usuario com status 3")
                MBUser.logout()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier :"MBLoginViewController")
                self.window?.rootViewController = viewController
                
            } else if let _ = MBUser.currentUser?.firstAccessAt{
                MBUser.update()
                print("NÃO TEM USUARIO")

                Analytics.setUserProperty(MBUser.currentUser!.fullName, forName: "name")
                Analytics.setUserID("\(MBUser.currentUser!.id)")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier :"NavigationInicial") as! UINavigationController
                self.window?.rootViewController = viewController
                
            }
            

        }

        return true
    }
    
    @objc func refreshToken(notification : NSNotification){
        let refreshToken = InstanceID.instanceID().token()
        print("--------\(refreshToken)--------")
        FBHandler()
    }
    func FBHandler (){
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        //*** APP LINK
        print("Continue User Activity called: ")
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            print("----------------------------------------------------------------------------------------------------------------")
            print("----------------------------------------------------------------------------------------------------------------")
            print("----------------------------------------------------------------------------------------------------------------")
            print(url.absoluteString)
            print("----------------------------------------------------------------------------------------------------------------")
            print("----------------------------------------------------------------------------------------------------------------")
            print("----------------------------------------------------------------------------------------------------------------")

            //handle url and open whatever page you want to open.
        }        //*** APP LINK
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBHandler()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
}

