//
//  LaunchesTopSection.swift
//  XSpace
//
//  Created by Malasevschi, Igor (Cognizant) on 23.06.2025.
//

import SwiftUI

struct LaunchesTopSection: View {
    let container: DependencyContainer
    
    var body: some View {
        VStack(spacing: 12) {
            TopBarView(container: container)
            CompanyInfoSection(companyViewModel: container.companyViewModel)
        }
        .background(Color(.systemBackground))
    }
}
