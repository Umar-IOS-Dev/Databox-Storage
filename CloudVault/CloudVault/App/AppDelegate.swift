//
//  AppDelegate.swift
//  CloudVault
//
//  Created by Appinators Technology on 08/07/2024.
//

import UIKit
import Firebase
import GoogleSignIn
import UserNotifications
import FirebaseMessaging
import StoreKit
import Amplify
import AWSCognitoAuthPlugin
//import AWSAPIPlugin
//import AWSCognitoAuthPlugin
//import AWSDataStorePlugin
//import AWSS3StoragePlugin

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            guard let self = self else { return }
            if granted {
                print("Permission granted")
                UNUserNotificationCenter.current().delegate = self
            } else if let error = error {
                print("Permission denied: \(error)")
            }
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        configureAmplify()
        // Observe payment transactions
        SKPaymentQueue.default().add(SubscriptionManager.shared)
        
        return true
    }
    
    func scheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification."
        if #available(iOS 15.2, *) {
            content.sound = .defaultRingtone
        } else {
            // Fallback on earlier versions
            content.sound = .default
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func configureAmplify() {
//        do {
//            try Amplify.add(plugin: AWSCognitoAuthPlugin())
//            try Amplify.add(plugin: AWSAPIPlugin())
//          //  try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels()))
//            try Amplify.add(plugin: AWSS3StoragePlugin())
//
//            try Amplify.configure()
//            print("Amplify configured successfully")
//        } catch {
//            print("An error occurred setting up Amplify: \(error)")
//        }
        
        do {
            // Automatically loads from amplifyconfiguration.json
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            Amplify.Logging.logLevel = .debug

            print("Amplify configured successfully")
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
        
        
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
    
    
    
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }


}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            print(token)
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.body
        print("Notification received with content: \(userInfo)")
        completionHandler()
    }
    
    
    // This method is called when APNS successfully registers the app and returns a device token.
       func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           // Set APNS token for FCM
           Messaging.messaging().apnsToken = deviceToken
           print("APNS Token: \(deviceToken)")
       }

       // Handle registration failure
       func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
           print("Failed to register for remote notifications: \(error.localizedDescription)")
       }
    
}


