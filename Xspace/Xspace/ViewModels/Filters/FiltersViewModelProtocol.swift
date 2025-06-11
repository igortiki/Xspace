//
//  FiltersVIewModelProtocol.swift
//  Devskiller
//
//  Created by Igor Malasevschi on 6/10/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

protocol FiltersViewModelProtocol {
    var availableYears: [Int] { get }
    var launchYearsLabelText: String { get }
    var launchSuccessLabelText: String { get }
    var sortOrderLabelText: String { get }
    var applyButtonTitle: String { get }
    var successOptions: [String] { get }
    var sortOrderOptions: [String] { get }
    var selectedYears: Set<Int> { get set }
    var successOnly: Bool { get set }
    var sortOrderAscending: Bool { get set }
    var filterModel: LaunchFiltersModel { get }
    func resetFilters()
}
