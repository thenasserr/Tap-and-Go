//
//  UserDTO.swift
//  Meal Time
//
//  Created by Ibrahim Nasser Ibrahim on 17/04/2026.
//

import Foundation

// MARK: - User DTO

struct UserDTO: Codable {
    
    let id: String
    let name: String
    let email: String
    let phoneNumber: String?
    let defaultAddress: AddressDTO?
    let profileImagePath: String?
    let createdAt: String
}
