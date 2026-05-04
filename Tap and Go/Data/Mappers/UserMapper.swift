//
//  UserMapper.swift
//  Meal Time
//
//  Created by Ibrahim Nasser Ibrahim on 18/04/2026.
//

import Foundation

struct UserMapper {
    
    static func map(dto: UserDTO) -> User {
        
        let date = ISO8601DateFormatter.shared.date(from: dto.createdAt) ?? Date()
        
        return User(id: dto.id,
                    name: dto.name,
                    email: dto.email,
                    phoneNumber: dto.phoneNumber ?? "",
                    defaultAddress: dto.defaultAddress.map({
            AddressMapper.map(dto: $0)
        }), profileImagePath: dto.profileImagePath,
                    createdAt: date)
    }
}
