//
//  AppAnalyticsService.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 02/05/2026.
//

import Foundation
import FirebaseAnalytics

protocol AppAnalyticsService {
    
    func track(event: String, parameters: [String: Any]?)
    func setUserID(_ userID: String?)
}

final class FirebaseAnalyticsService: AppAnalyticsService {
    
    func track(event: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(event, parameters: parameters)
    }
    
    func setUserID(_ userID: String?) {
        Analytics.setUserID(userID)
    }
}
