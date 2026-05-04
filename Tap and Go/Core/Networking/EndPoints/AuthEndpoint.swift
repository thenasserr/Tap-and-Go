//
//  AuthEndpoint.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 18/04/2026.
//

import Foundation

enum AuthEndpoint: Endpoint {
    case login(email: String, password: String)
    case signup(name: String, email: String, password: String)
    case updateUser(user: User)
    case firebaseAuth(FirebaseAuthRequest)
}

// MARK: - Endpoint

extension AuthEndpoint {
    
    var path: String {
        
        switch self {
            
        case .login:
            return "/auth/login"
            
        case .signup:
            return "/auth/signup"
            
        case .updateUser(let user):
            return "/users/\(user.id)"
                
            case .firebaseAuth:
                return "/auth/firebase"
        }
    }
    
    var method: HTTPMethod {
        
        switch self {
            
            case .login, .signup, .firebaseAuth:
            return .post
            
        case .updateUser:
            return .patch
        }
    }
    
    var headers: [String : String]? {
        
        [
            "Content-Type": "application/json"
        ]
    }
    
    var queryItems: [URLQueryItem]? {
        
        nil
    }
    
    var bodyData: Data? {
        
        switch self {
            
        case .login(let email, let password):
            return try? JSONSerialization.data(
                withJSONObject: [
                    "email": email,
                    "password": password
                ]
            )
            
        case .signup(let name, let email, let password):
            return try? JSONSerialization.data(
                withJSONObject: [
                    "name": name,
                    "email": email,
                    "password": password
                ]
            )
            
        case .updateUser(let user):
            return try? JSONSerialization.data(
                withJSONObject: [
                    "name": user.name,
                    "email": user.email,
                    "phoneNumber": user.phoneNumber,
                    "profileImagePath": user.profileImagePath ?? ""
                ]
            )
                
            case .firebaseAuth(let request):
                return try? JSONEncoder().encode(request)
        }
    }
}
