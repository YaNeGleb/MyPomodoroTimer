//
//  AuthService.swift
//  MyTimer
//
//  Created by Gleb Zabroda on 09.04.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    public static let shared = AuthService()
    
    private init() {}
    
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping(Bool, Error?) -> Void) {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            if let result = result {
                print(result.user.uid)
                let database = Firestore.firestore()
                database.collection("users")
                    .document(result.user.uid)
                    .setData([
                        "username": username,
                        "email": email,
                        "password": password]) { error in
                            if let error = error {
                                completion(false, error)
                                return
                            }
                            completion(true, nil)
                            NavigationManager.navigateToLogin()
                        }
            }
        }
    }
    
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { (result, error) in
            if let error = error {
                // Если произошла ошибка, сообщить об этом пользователю
                completion(error)
                return
            }
            
            // Если пользователь успешно вошел, получить информацию о пользователе из Firebase
            guard let user = result?.user else {
                completion(NSError(domain: "Auth Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"]))
                return
            }
            
            let usersCollection = Firestore.firestore().collection("users")
            
            // Проверяем, есть ли информация о пользователе в Firestore
            usersCollection.document(user.uid).getDocument { (snapshot, error) in
                if let error = error {
                    // Если произошла ошибка, сообщить об этом пользователю
                    completion(error)
                    return
                }
                
                if let snapshot = snapshot, snapshot.exists {
                    // Если информация о пользователе уже есть в Firestore, сообщить об успешной авторизации
                    completion(nil)
                    
                    NavigationManager.navigateToTimer()
                    
                }
            }
        }
    }
    public func signOut(completion: @escaping (Error) -> Void) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            completion(error)
        }
    }
}


