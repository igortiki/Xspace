//
//  CompanyViewModel.swift
//  Xspace
//
//  Created by Igor Malasevschi on 6/7/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

import Foundation

final class CompanyViewModel: CompanyViewModelProtocol {
    private let apiService: APIServiceProtocol
    
    var companyName: String {
        "SpaceX"
    }
    
    var topHeaderSection: String {
        "Company"
    }
    
    // Output
    var onViewStateChange: ((LoadState<String>) -> Void)?
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchCompanyInfo() async {
        
        await MainActor.run {
            onViewStateChange?(.loading)
        }
        
        do {
            let companyURL = apiService.baseURL.appendingPathComponent("company")
            let companyInfo = try await apiService.fetchCompanyInfo(url: companyURL, method: .get)
            
            let formatted = makeDisplayText(from: companyInfo)
            
            await MainActor.run {
                onViewStateChange?(.loaded(formatted))
            }
        } catch {
            let apiError = (error as? APIError) ?? .underlying(error)
            
            await MainActor.run {
                onViewStateChange?(.error(apiError.userMessage))
            }
        }
    }
}

private func makeDisplayText(from info: CompanyInfo) -> String {
    return "\(info.name) was founded by \(info.founder) in \(info.founded). It has now \(info.employees) employees, \(info.launchSites) launch sites, and is valuated at USD \(FormatterHelper.formattedValuation(info.valuation))"
}

