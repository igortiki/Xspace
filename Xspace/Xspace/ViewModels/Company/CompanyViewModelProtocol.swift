//
//  CompanyViewModelProtocol.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/9/25.
//  Copyright © 2025 XSpace. All rights reserved.
//

@MainActor
protocol CompanyViewModelProtocol: AnyObject {
    var companyName: String { get }
    var topHeaderSection: String { get }
    var onViewStateChange: ((LoadState<String>) -> Void)? { get set }
    func fetchCompanyInfo() async
}
