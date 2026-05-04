//
//  GetCurrentUserUseCase.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 20/04/2026.
//

import Foundation
import Combine

final class GetCurrentUserUseCase {

    private let repository: AuthRepository

    private let sessionValidator: SessionValidator

    private let analytics: AnalyticsTracker

    init(repository: AuthRepository, sessionValidator: SessionValidator, analytics: AnalyticsTracker) {
        self.repository = repository
        self.sessionValidator = sessionValidator
        self.analytics = analytics

    }
}

extension GetCurrentUserUseCase {

    func execute() -> User? {

        analytics.track(event: "check_current_user")

        // Step 1 — Check token

        guard sessionValidator.hasValidSession() else {

            analytics.track(event: "no_session_found")

            return nil

        }

        // Step 2 — Fetch cached user

        let user = repository.getCurrentUser()

        // Step 3 — Track result

        if let _ = user {

            analytics.track(event: "auto_login_success")

        }

        else {

            analytics.track(event: "user_cache_missing")

        }

        return user

    }
}
