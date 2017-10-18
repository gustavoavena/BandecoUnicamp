
//  AppDelegate.swift
//  BandecoUnicamp
//
//  Created by Gustavo Avena on 135//17.
//  Copyright © 2017 Gustavo Avena. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
        
        
        
        if let token = UserDefaults.standard.object(forKey: "deviceToken") as? String {
            print("\n\nDevice Token: \(token)\n\n\n")
            
            CardapioServices.shared.registerDeviceToken(token: token)
        }
        

        #if RELEASE
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        self.setupGoogleAnalytics()
        #endif
        
		return true
	}
    
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)\n")
        
        UserDefaults.standard.set(token, forKey: "deviceToken")
        
        CardapioServices.shared.registerDeviceToken(token: token)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
    
    func setupGoogleAnalytics() {
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError? = nil
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")

        if let gai = GAI.sharedInstance() {
            gai.tracker(withTrackingId: ("UA-103784746-1"))
            gai.trackUncaughtExceptions = true  // report uncaught exceptions
            gai.logger.logLevel = GAILogLevel.none
            gai.defaultTracker.allowIDFACollection = true
            gai.defaultTracker.send(GAIDictionaryBuilder.createEvent(withCategory: "ui_action", action: "app_launched",label:"launch",value:nil).build() as! [AnyHashable : Any]!)
        }
    }

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

