//
//  MockLaunchesAPIService.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/13/25.
//  Copyright © 2025 XSpace. All rights reserved.
//


import UIKit
@testable import XSpace

final class MockLaunchesAPIService: APIServiceProtocol {

    // MARK: - Test Configuration
    let baseURL: URL = URL(string: "https://mock.api")!
    
    let launchResponse: XSpace.LaunchesResponse?
    let rocketResponse: XSpace.RocketResponse?
    let error: Error?
    let image: UIImage?
    
    // MARK: - Initialization
        init(
            launchResponse: XSpace.LaunchesResponse? = nil,
            rocketResponse: XSpace.RocketResponse? = nil,
            image: UIImage? = nil,
            error: Error? = nil
        ) {
            self.launchResponse = launchResponse
            self.rocketResponse = rocketResponse
            self.image = image
            self.error = error
        }

    // MARK: - Unused Methods in Launches Tests
    func requestRawString(url: URL, method: XSpace.HTTPMethod, bodyData: Data?) async throws -> String {
        fatalError("Not used in LaunchesViewModel tests")
    }

    func fetchCompanyInfo(url: URL, method: XSpace.HTTPMethod) async throws -> XSpace.CompanyInfo {
        fatalError("Not used in LaunchesViewModel tests")
    }

    // MARK: - Used Methods
    func fetchAllLaunches(url: URL, method: XSpace.HTTPMethod, bodyData: Data) async throws -> XSpace.LaunchesResponse {
        if let error = error {
            throw APIError.underlying(error)
        }
        guard let response = launchResponse else {
            throw APIError.decodingFailed(underlying: NSError(domain: "mock", code: -1))
        }
        return response
    }

    func fetchRockets(url: URL, method: XSpace.HTTPMethod, bodyData: Data) async throws -> XSpace.RocketResponse {
        if let error = error {
            throw APIError.underlying(error)
        }
        
        guard let response = rocketResponse else {
            throw APIError.decodingFailed(underlying: NSError(domain: "mock", code: -2))
        }
        return response
    }
    
    func asyncImage(from url: URL) async throws -> UIImage {
        if error != nil {
            throw APIError.imageDecodingFailed
        }
        return image ?? UIImage()
    }
}

