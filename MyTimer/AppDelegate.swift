//
//  AppDelegate.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 24.03.2023.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Запрос разрешения на отправку уведомлений
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            // Handle the response from the user
        }
        
        // Настройка делегата уведомлений
        center.delegate = self

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // Реализация метода делегата для отображения баннеров уведомлений
    @objc func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Определяем тип отображения уведомления, в зависимости от состояния приложения
        let presentationOptions: UNNotificationPresentationOptions
        
        if UIApplication.shared.applicationState == .active {
            // Если приложение находится в активном состоянии, отображаем только баннер уведомления
            presentationOptions = [.banner]
        } else {
            // Если приложение находится в фоновом или свернутом состоянии, отображаем баннер уведомления и уведомление в центре уведомлений
            presentationOptions = [.banner, .list, .sound]
        }
        
        // Вызываем completionHandler с указанными параметрами
        completionHandler(presentationOptions)
    }
}
