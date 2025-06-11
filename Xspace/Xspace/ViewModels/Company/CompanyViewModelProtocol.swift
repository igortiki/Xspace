//
//  CompanyViewModelProtocol.swift
//  Devskiller
//
//  Created by Igor Malasevschi on 6/9/25.
//  Copyright © 2025 Xspace. All rights reserved.
//

protocol CompanyViewModelProtocol: AnyObject {
    var companyName: String { get }
    var topHeaderSection: String { get }
    var onCompanyInfoUpdated: ((String) -> Void)? { get set }
    func fetchCompanyInfo() async
}
