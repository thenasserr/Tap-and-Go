//
//  LogoutLogger.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 20/04/2026.
//

import Foundation

protocol LogoutLogger {
    
    func logLogout()
    
}

final class DefaultLogoutLogger:
    LogoutLogger {
    
    func logLogout() {
        
        print("User logged out")
        
    }
    
}
