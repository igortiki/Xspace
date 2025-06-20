//
//  LaunchesViewModelProtocol.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/9/25.
//  Copyright © 2025 XSpace. All rights reserved.
//

import Foundation

@MainActor
protocol LaunchesViewModelProtocol: AnyObject {
    var enrichedLaunchesCount: Int { get }
    var launchesSectionTitle: String { get }
    var apiService: APIServiceProtocol { get }
    var onViewStateChange: ((LoadState<Bool>) -> Void)? { get set }
    var isLoading: Bool { get }
    var currentFilters: LaunchFiltersModel { get }
    func loadNextPage() async
    func cellViewModel(atIndex index: Int) -> LaunchCellViewModel
    func applyFilters(_ filters: LaunchFiltersModel) async
    var emptyLaunchesText: String { get }
    var retryButtonText: String { get }
}

