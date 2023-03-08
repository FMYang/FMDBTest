//
//  AppDelegate.swift
//  SwiftFMDB
//
//  Created by yfm on 2023/2/21.
//

import UIKit
import DatabaseVisual

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DatabaseManager.sharedInstance().dbDocumentPath = DBManager.documentDir
        DBManager.create(tables: [Person.self])
        DBManager.upgrade(tables: [Person.self])

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let vc = ViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isTranslucent = false
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
//
//        DBManager.shared.dbVersion = DBManager.lastestVersion
        
        return true
    }
}

