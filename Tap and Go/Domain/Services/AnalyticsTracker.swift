//
//  AnalyticsTracker.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 20/04/2026.
//

import Foundation

protocol AnalyticsTracker {
    
    func track(event: String)
}

final class DefaultAnalyticsTracker: AnalyticsTracker {
    
    func track(event: String) {
        print("Analytics Tracker: \(event)")
    }
}
