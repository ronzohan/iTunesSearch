//
//  AppDelegate.swift
//  iTunesSearch
//
//  Created by Ron Daryl Magno on 16/08/2019.
//  Copyright © 2019 Ron Daryl Magno. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window, authManager: AuthManager.shared)
        appCoordinator?.start()
        window.makeKeyAndVisible()

        self.window = window
        //Sample.fetchRequest()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate.
        // See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataManager.shared.saveContext()
    }
}
