//
//  FirebaseAuthService.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 02/05/2026.
//

import Foundation
import Combine
import FirebaseAuth

// MARK: - Firebase Auth Service

protocol FirebaseAuthService {
    
    func login(email: String, password: String) -> AnyPublisher<FirebaseAuthUser, Error>
    func signup(email: String, password: String) -> AnyPublisher<FirebaseAuthUser, Error>
    func logout() throws
    func getCurrentUser() -> FirebaseAuthUser?
    func sendPasswordReset(email: String) -> AnyPublisher<Void, Error>
}

// MARK: - Firebase Auth User

struct FirebaseAuthUser {
    
    let uid: String
    let email: String?
}

// MARK: - Default Firebase Auth Service

final class DefaultFirebaseAuthService: FirebaseAuthService {
    
    func login(email: String, password: String) -> AnyPublisher<FirebaseAuthUser, Error> {
        
        Future { promise in
            Auth.auth().signIn(
                withEmail: email,
                password: password
            ) { result, error in
                
                if let error {
                    promise(.failure(error))
                    return
                }
                
                guard let user = result?.user else {
                    promise(.failure(NSError(domain: "FirebaseAuth", code: -1)))
                    return
                }
                
                promise(.success(
                    FirebaseAuthUser(
                        uid: user.uid,
                        email: user.email
                    )
                ))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signup(email: String, password: String) -> AnyPublisher<FirebaseAuthUser, Error> {
        
        Future { promise in
            Auth.auth().createUser(
                withEmail: email,
                password: password
            ) { result, error in
                
                if let error {
                    promise(.failure(error))
                    return
                }
                
                guard let user = result?.user else {
                    promise(.failure(NSError(domain: "FirebaseAuth", code: -1)))
                    return
                }
                
                promise(.success(
                    FirebaseAuthUser(
                        uid: user.uid,
                        email: user.email
                    )
                ))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    func getCurrentUser() -> FirebaseAuthUser? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        
        return FirebaseAuthUser(
            uid: user.uid,
            email: user.email
        )
    }
    
    func sendPasswordReset(email: String) -> AnyPublisher<Void, Error> {
        
        Future { promise in
            Auth.auth().sendPasswordReset(
                withEmail: email
            ) { error in
                
                if let error {
                    promise(.failure(error))
                    return
                }
                
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
}
