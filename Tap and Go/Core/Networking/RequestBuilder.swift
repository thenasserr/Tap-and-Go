//
//  RequestBuilder.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 17/04/2026.
//

import Foundation

// MARK: - Request Builder

struct RequestBuilder {
    
    static func build(from endpoint: Endpoint) throws -> URLRequest {
        guard var components = URLComponents(
            string: APIEnvironment.baseURL + endpoint.path
        ) else {
            throw NetworkError.invalidURL
        }
        
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.headers?.forEach {
            request.setValue($1, forHTTPHeaderField: $0)
        }
        
        if let bodyData = endpoint.bodyData {
            request.httpBody = bodyData
            
        } else if let body = endpoint.body {
            request.httpBody = try JSONEncoder().encode(
                AnyEncodable(body)
            )
        }
        
        return request
    }
}
