//
//  User.swift
//  Meal Time
//
//  Created by Ibrahim Nasser Ibrahim on 17/04/2026.
//

import UIKit

struct User: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let email: String
    let phoneNumber: String
    let defaultAddress: Address?
    let profileImagePath: String?
    let createdAt: Date
}
