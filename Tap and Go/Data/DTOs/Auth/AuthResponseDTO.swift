//
//  AuthResponseDTO.swift
//  Meal Time
//
//  Created by Ibrahim Nasser Ibrahim on 17/04/2026.
//

import Foundation

struct AuthResponseDTO: Codable {

    let token: String

    let user: UserDTO

}
