//
//  NavigationManager.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 13.04.2023.
//

import UIKit

class NavigationManager {
    
    private static let storyboard = UIStoryboard(name: "Main", bundle: nil)

    //MARK: - WindowScene
    private static func windowScene(controller: UIViewController?, navigation: UINavigationController?) {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        if controller == nil {
            sceneDelegate?.window?.rootViewController = navigation
        } else {
            sceneDelegate?.window?.rootViewController = controller
        }
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    //MARK: - NavigateToTimerViewController
    public static func navigateToTimer() {

        let timerVC = storyboard.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
        let navController = UINavigationController(rootViewController: timerVC)
        navController.modalPresentationStyle = .fullScreen
        
        windowScene(controller: nil, navigation: navController)
    }
            
    //MARK: - NavigateToLoginViewController
    public static func navigateToLogin() {
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        
        windowScene(controller: loginVC, navigation: nil)
    }

    //MARK: - NavigateToReAuthViewController

    public static func navigateToRegister() {
        let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController

        windowScene(controller: authViewController, navigation: nil)
    }
}
