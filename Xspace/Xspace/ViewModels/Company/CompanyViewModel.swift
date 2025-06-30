//
//  CompanyViewModel.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/7/25.
//  Copyright © 2025 XSpace. All rights reserved.
//

import Foundation

@MainActor
final class CompanyViewModel: ObservableObject {
    private let apiService: APIServiceProtocol

    // MARK: - Public Properties
    @Published var formattedText: String = "Loading..."

    var companyName: String {
        "SpaceX"
    }

    var topHeaderSection: String {
        "Company"
    }

    // MARK: - Init
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    // MARK: - Fetch
    func fetchCompanyInfo() async {
        do {
            let companyURL = apiService.baseURL.appendingPathComponent("company")
            let companyInfo = try await apiService.fetchCompanyInfo(url: companyURL, method: .get)

            self.formattedText = makeDisplayText(from: companyInfo)
        } catch {
            let apiError = (error as? APIError) ?? .underlying(error)
            self.formattedText = apiError.userMessage
        }
    }

    private func makeDisplayText(from info: CompanyInfo) -> String {
        return "\(info.name) was founded by \(info.founder) in \(info.founded). It has now \(info.employees) employees, \(info.launchSites) launch sites, and is valuated at USD \(FormatterHelper.formattedValuation(info.valuation))"
    }
}
