//
//  LoginLogger.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 20/04/2026.
//

import Foundation

protocol LoginLogger {
    
    func loginAttempt(email: String)
}

final class DefaultLoginLogger: LoginLogger {
    func loginAttempt(email: String) {
        
        print("Login attempt: \(email)")
    }
}
