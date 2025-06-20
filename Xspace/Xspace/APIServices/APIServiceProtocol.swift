//
//  APIServiceProtocol.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/7/25.
//  Copyright © 2025 XSpace. All rights reserved.
//

import Foundation
import UIKit

/// Defines the contract for an API service responsible for making network requests.
protocol APIServiceProtocol: Sendable {
    var baseURL: URL { get }
    func requestRawString(url: URL, method: HTTPMethod, bodyData: Data?) async throws -> String
    func fetchCompanyInfo(url: URL, method: HTTPMethod) async throws -> CompanyInfo
    func fetchAllLaunches(url: URL, method: HTTPMethod, bodyData: Data) async throws -> LaunchesResponse
    func fetchRockets(url: URL, method: HTTPMethod, bodyData: Data) async throws -> RocketResponse
    func asyncImage(from url: URL) async throws -> UIImage
}
