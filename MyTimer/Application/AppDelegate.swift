//
//  AppDelegate.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 24.03.2023.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseAuth




@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // обработка ошибки
                print("Error requesting authorization for notifications: \(error.localizedDescription)")
            }
            // действия, если пользователь разрешил или не разрешил отправку уведомлений
        }
        // Получаем текущее значение сохраненной темы
        let savedTheme = UserDefaults.standard.bool(forKey: "isDarkTheme")
        
        // Если темная тема сохранена, включаем ее
        if savedTheme, #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .dark
        }
        window?.makeKeyAndVisible()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    }
        

