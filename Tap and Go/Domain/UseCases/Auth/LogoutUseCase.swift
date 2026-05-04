//
//  LogoutUseCase.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 17/04/2026.
//

import Foundation
import Combine

final class LogoutUseCase {
    
    private let sessionManager: SessionManager
    private let logger: LogoutLogger
    private let analytics: AnalyticsTracker
    private let cacheCleaner: CacheCleaner
    
    init(
        sessionManager: SessionManager,
        logger: LogoutLogger,
        analytics: AnalyticsTracker,
        cacheCleaner: CacheCleaner
    ) {
        
        self.sessionManager = sessionManager
        self.logger = logger
        self.analytics = analytics
        self.cacheCleaner = cacheCleaner
    }
}

// MARK: - Execute

extension LogoutUseCase {
    
    func execute() {
        
        sessionManager.clearSession()
        cacheCleaner.clearUserCache()
        analytics.track(event: "logout")
        logger.logLogout()
        print(sessionManager.getToken() as Any)
        print(sessionManager.getCurrentUser() as Any)
    }
}
