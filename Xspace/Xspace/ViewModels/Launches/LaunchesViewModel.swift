//
//  LaunchesViewModel.swift
//  Xspace
//
//  Created by Igor Malasevschi on 6/7/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

import Foundation

final class LaunchesViewModel: LaunchesViewModelProtocol {
    

    // MARK: - Properties
    private(set) var apiService: APIServiceProtocol
    
    private var currentPage = 1
    private let limit = 10
    private var hasNextPage = true
    private(set) var isLoading = false
    
    private(set) var currentFilters: LaunchFiltersModel = .empty
    
    var onViewStateChange: ((LoadState<Bool>) -> Void)?
    
    var launchesSectionTitle: String {
        "Launches"
    }
    
    var emptyLaunchesText: String {
        "No launches found."
    }
    
    var retryButtonText: String {
        "Retry"
    }
    
    private var cellViewModels: [LaunchCellViewModel] = []
    
    
    var enrichedLaunchesCount: Int {
        return cellViewModels.count
    }
    
    // MARK: - Initialization
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    // MARK: - Public Methods
    func loadNextPage() async {
        await fetchPage(reset: false, filters: currentFilters)
    }
    
    private func resetAndFetchFirstPage(with filters: LaunchFiltersModel) async {
        await fetchPage(reset: true, filters: filters)
    }
    
    func cellViewModel(atIndex index: Int) -> LaunchCellViewModel {
        return cellViewModels[index]
    }
    
    func applyFilters(_ filters: LaunchFiltersModel) async {
        guard filters != currentFilters else { return }
        currentFilters = filters
        await resetAndFetchFirstPage(with: filters)
    }
    
    // MARK: - Fetching
    private func fetchPage(reset: Bool = false, filters: LaunchFiltersModel) async {
        guard !isLoading, hasNextPage || reset else { return }
        
        isLoading = true
        
        await MainActor.run {
            onViewStateChange?(.loading)
        }
        
        
        do {
            let launchResponse = try await fetchLaunchesPage(reset: reset, filters: filters)
            
            let rocketIDs = Set(launchResponse.docs.compactMap { $0.rocket })
            let rockets = try await fetchRockets(for: rocketIDs)
            
            let rocketMap = Dictionary(uniqueKeysWithValues: rockets.map { ($0.id, $0) })
            
            let enriched = launchResponse.docs.map { launch in
                EnrichedLaunch(launch: launch, rocket: rocketMap[launch.rocket])
            }
            
            handleNewPage(enriched, response: launchResponse)
            
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                onViewStateChange?(.loaded(self.cellViewModels.isEmpty))
            }
        } catch {
            
            let apiError = (error as? APIError) ?? .underlying(error)
            
            await MainActor.run {
                onViewStateChange?(.error(apiError.userMessage))
            }
        }
        
        isLoading = false
    }
    
    private func fetchLaunchesPage(reset: Bool = false, filters: LaunchFiltersModel) async throws -> LaunchesResponse {
        if reset {
            currentPage = 1
            hasNextPage = true
            cellViewModels = []
        }
        
        let query = buildQuery(for: filters)
        let options = buildOptions(for: filters)
        let body = try makeQueryBody(query: query, options: options)
        
        let url = apiService.baseURL.appendingPathComponent("launches/query")
        return try await apiService.fetchAllLaunches(url: url, method: .post, bodyData: body)
    }
    
    private func fetchRockets(for rocketIDs: Set<String>) async throws -> [Rocket] {
        guard !rocketIDs.isEmpty else { return [] }
        
        let url = apiService.baseURL.appendingPathComponent("rockets/query")
        let body = try makeQueryBody(query: ["_id": ["$in": Array(rocketIDs)]], options: [:])
        let response: RocketResponse = try await apiService.fetchRockets(url: url, method: .post, bodyData: body)
        return response.docs
    }
    
    private func handleNewPage(_ newLaunches: [EnrichedLaunch], response: LaunchesResponse) {
        let newViewModels = newLaunches.map {
            LaunchCellViewModel(enrichedLaunch: $0, apiService: apiService)
        }
        cellViewModels += newViewModels
        hasNextPage = response.hasNextPage
        currentPage += 1
    }
}

// MARK: - Helpers
extension LaunchesViewModel {
    private func makeQueryBody(query: [String: Any] = [:], options: [String: Any]) throws -> Data {
        let queryBody: [String: Any] = [
            "query": query,
            "options": options
        ]
        return try JSONSerialization.data(withJSONObject: queryBody, options: [])
    }
    
    private func buildOptions(for filters: LaunchFiltersModel) -> [String: Any] {
        [
            "limit": limit,
            "page": currentPage,
            "sort": ["date_unix": filters.sortOrderAscending ? "asc" : "desc"]
        ]
    }
    
    private func buildQuery(for filters: LaunchFiltersModel) -> [String: Any] {
        var query: [String: Any] = [:]
        
        if filters.successOnly {
            query["success"] = filters.successOnly
        }
        
        
        if !filters.selectedYears.isEmpty {
            let yearConditions = filters.selectedYears.map { unixRange(forYear: $0) }
            query["$or"] = yearConditions
        }
        
        return query
    }
    
    private func unixRange(forYear year: Int) -> [String: Any] {
        let calendar = Calendar(identifier: .gregorian)
        let start = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
        let end = calendar.date(from: DateComponents(year: year + 1, month: 1, day: 1))!
        
        return [
            "date_unix": [
                "$gte": Int(start.timeIntervalSince1970),
                "$lt": Int(end.timeIntervalSince1970)
            ]
        ]
    }
}
