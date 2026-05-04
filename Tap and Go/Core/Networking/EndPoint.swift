//
//  EndPoint.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 17/04/2026.
//

import Foundation

// MARK: - Endpoint

protocol Endpoint {
    
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Encodable? { get }
    var bodyData: Data? { get }
}

// MARK: - Default Values

extension Endpoint {
    
    var body: Encodable? { nil }
    var bodyData: Data? { nil }
}
