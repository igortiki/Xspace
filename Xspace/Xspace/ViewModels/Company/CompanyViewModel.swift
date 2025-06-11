//
//  CompanyViewModel.swift
//  Devskiller
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
    var onCompanyInfoUpdated: ((String) -> Void)?
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    @MainActor
    func fetchCompanyInfo() async {
        do {
            let companyURL = apiService.baseURL.appendingPathComponent("company")
            let companyInfo = try await apiService.fetchCompanyInfo(url: companyURL, method: .get)
            // let companyInfo = try await apiService.requestRawString(url: companyURL, method: .get, bodyData: nil)
            //print(companyInfo)
            
            let formatted = makeDisplayText(from: companyInfo)
            onCompanyInfoUpdated?(formatted)
            
        } catch {
            print("Error fetching company info: \(error)")
        }
    }
    
    private func makeDisplayText(from info: CompanyInfo) -> String {
        return "\(info.name) was founded by \(info.founder) in \(info.founded). It has now \(info.employees) employees, \(info.launchSites) launch sites, and is valuated at USD \(formattedValuation(info.valuation))"
    }
    
    private func formattedValuation(_ valuation: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: valuation)) ?? "\(valuation)"
    }
}
