//
//  APIService.swift
//  Xspace
//
//  Created by Igor Malasevschi on 6/7/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

import Foundation

/// Service responsible for making network API calls.
final class APIService: APIServiceProtocol {
    
    // MARK: - Properties
    private(set) var baseURL: URL
    private(set) var session: any URLSessionProtocol
    
    // MARK: - Initialization
    init(baseURL: URL?, session: URLSessionProtocol) throws {
        guard let baseURL = baseURL else {
            throw APIError.invalidBaseURL
        }
        self.baseURL = baseURL
        self.session = session
    }
    
    // MARK: - Generic Request
    private func request<T: Decodable>(url: URL, method: HTTPMethod, bodyData: Data? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let bodyData = bodyData {
            request.httpBody = bodyData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.badStatusCode((response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(underlying: error)
        }
    }
    
    // MARK: - Public API Methods
    func fetchCompanyInfo(url: URL, method: HTTPMethod) async throws -> CompanyInfo {
        return try await request(url: url, method: method)
    }
    
    func fetchAllLaunches(url: URL, method: HTTPMethod, bodyData: Data) async throws -> LaunchesResponse {
        return try await request(url: url, method: method, bodyData: bodyData)
    }
    
    func fetchRockets(url: URL, method: HTTPMethod, bodyData: Data) async throws -> RocketResponse {
        return try await request(url: url, method: method, bodyData: bodyData)
    }
    
    // MARK: - Debugging
    /// Requests raw response string from the given URL.
    /// - Note: This method is intended for **debugging purposes only** to inspect raw API responses.
    func requestRawString(url: URL, method: HTTPMethod, bodyData: Data? = nil) async throws -> String {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let bodyData = bodyData {
            request.httpBody = bodyData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.badStatusCode((response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        guard let string = String(data: data, encoding: .utf8) else {
            throw APIError.stringDecodingFailed
        }
        
        return string
    }
}

/// Facade class that provides a centralized access point for API services.
final class APIEnvironment {
    
    // MARK: - Properties
    let apiService: APIServiceProtocol

    // MARK: - Static Configuration
    private static let baseURL: URL? = URL(string: "https://api.spacexdata.com/v4")

    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: config)
    }()

    // MARK: - Initialization
    init() throws {
        self.apiService = try APIService(baseURL: Self.baseURL, session: Self.session)
    }
}


