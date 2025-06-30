//
//  DependencyContainer.swift
//  XSpace
//
//  Created by Malasevschi, Igor (Cognizant) on 28.06.2025.
//


import SwiftUI

@MainActor
final class DependencyContainer {
    
    private let apiService: APIServiceProtocol
    
    
    lazy var launchesViewModel: LaunchesViewModel = {
        LaunchesViewModel(apiService: apiService)
    }()

    lazy var companyViewModel: CompanyViewModel = {
        CompanyViewModel(apiService: apiService)
    }()
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
        
        self.launchesViewModel = LaunchesViewModel(apiService: apiService)
        self.companyViewModel = CompanyViewModel(apiService: apiService)
        
    }
    
    func makeFiltersViewModel(from filters: LaunchFiltersModel) -> FiltersViewModel {
        FiltersViewModel(filterModel: filters)
    }
}

