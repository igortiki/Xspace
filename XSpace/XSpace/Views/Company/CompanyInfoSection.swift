//
//  CompanyInfoSection.swift
//  XSpace
//
//  Created by Malasevschi, Igor (Cognizant) on 23.06.2025.
//

import SwiftUI

struct CompanyInfoSection: View {
    @ObservedObject var companyViewModel: CompanyViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Section Header (touching the top edge of the container)
            Text(companyViewModel.topHeaderSection)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(white: 0.95))
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 28/255, green: 36/255, blue: 58/255))
            
            // Dynamic company description
            Text(companyViewModel.formattedText)
                .font(.system(size: 15))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
        }
        .background(Color.white) // white box
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(UIColor.separator), lineWidth: 1)
        )
        .padding(.horizontal, 8) // only padding *outside* the box
        .onAppear {
            Task {
                await companyViewModel.fetchCompanyInfo()
            }
        }
    }
}
