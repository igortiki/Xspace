//
//  APIServiceTests.swift
//  Xspace
//
//  Created by Igor Malasevschi on 6/12/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

import XCTest
@testable import Xspace

final class APIServiceTests: XCTestCase {
    
    var mockSession: MockURLSession = MockURLSession()
    var apiService: APIService!
    
    /// Recreates fresh mock and APIService instances before each test.
    override func setUpWithError() throws {
        try super.setUpWithError()
        

        guard let baseURL = URL(string: "https://api.spacexdata.com/v4") else {
            throw URLError(.badURL)
        }
        
        apiService = try APIService(baseURL: baseURL, session: mockSession)
    }
    
    func testFetchCompanyInfo_success() async throws {
        // Given
        let json = """
        {
            "name": "SpaceX",
            "founder": "Elon Musk",
            "founded": 2002,
            "employees": 8000,
            "launchSites": 3,
            "valuation": 74000000000
        }
        """
        mockSession.nextData = json.data(using: .utf8)
        
        guard let url = URL(string: "https://api.spacexdata.com/v4/company") else {
            return XCTFail("Invalid URL")
        }
        
        mockSession.nextResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // When
        let result = try await apiService.fetchCompanyInfo(url: url, method: .get)
        
        // Then
        XCTAssertEqual(result.name, "SpaceX")
        XCTAssertEqual(result.founder, "Elon Musk")
    }
    
    func testFetchCompanyInfo_failure_badStatusCode() async throws {
        // assign some Data()
        mockSession.nextData = Data()
        
        guard let url = URL(string: "https://api.spacexdata.com/v4/company") else {
            return XCTFail("Invalid URL")
        }
        
        mockSession.nextResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        // fake api call
        do {
            _ = try await apiService.fetchCompanyInfo(url: url, method: .get)
            XCTFail("Expected APIError.badStatusCode to be thrown")
        } catch {
            guard case APIError.badStatusCode(let code) = error else {
                return XCTFail("Expected badStatusCode, got \(error)")
            }
            XCTAssertEqual(code, 404)
        }
    }
    
    func testFetchCompanyInfo_failure_decoding() async throws {
        // assign some Data()
        mockSession.nextData = Data("bad json".utf8)

        guard let url = URL(string: "https://api.spacexdata.com/v4/company") else {
            return XCTFail("Invalid URL")
        }

        mockSession.nextResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        // fake api call
        do {
            _ = try await apiService.fetchCompanyInfo(url: url, method: .get)
            XCTFail("Expected APIError.decodingFailed to be thrown")
        } catch {
            guard case APIError.decodingFailed = error else {
                return XCTFail("Expected decodingFailed, got \(error)")
            }
        }
    }

}
