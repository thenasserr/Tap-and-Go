//
//  CrashReportingService.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 02/05/2026.
//

import Foundation
import FirebaseCrashlytics

protocol CrashReportingService {
    
    func setUserID(_ userID: String?)
    func log(_ message: String)
    func record(error: Error)
}

final class FirebaseCrashReportingService: CrashReportingService {
    
    func setUserID(_ userID: String?) {
        Crashlytics.crashlytics().setUserID(userID ?? "")
    }
    
    func log(_ message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    func record(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}
