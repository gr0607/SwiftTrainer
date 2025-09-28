//
//  AppDelegate.swift
//  SwiftTrainer
//
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       // CoreDataManager.shared.seedDataIfNeeded()
        
        let context = CoreDataManager.shared.context

        if let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let dbURL = url.appendingPathComponent("SwiftTrainer.sqlite")
            print("Путь к базе: \(dbURL.path)")
        }
        
      
//        if let subCategory = CoreDataManager.shared.fetchSubCategory(name: "Timer & RunLoop", context: context) {
//            seedQuestions(timerRunLoopQuestions, for: subCategory, context: context)
//
//            print("Вопросы добавлены в подкатегорию \(subCategory.name)")
//        } else {
//            print("Подкатегория не найдена")
//        }
       
        
        return true
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

