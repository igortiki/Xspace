//
//  LaunchRowView.swift
//  XSpace
//
//  Created by Malasevschi, Igor (Cognizant) on 23.06.2025.
//

import SwiftUI

struct LaunchRowView: View {
    @ObservedObject var viewModel: LaunchCellViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            Group {
                if let image = viewModel.missionPatchImage {
                    image
                        .resizable()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 40, height: 40)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.missionName)
                Text(viewModel.dateTimeString)
                Text(viewModel.rocketDescription)
                Text(viewModel.daysSinceText)
                Text(viewModel.fromNowText)
            }
            .font(.system(size: 14)) // applies to all child Text views
            
            Spacer()
            
            viewModel.successIcon
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(viewModel.successIconTintColor)
                .padding(.trailing, 8)
        }
        .padding(8)
        .onAppear {
            viewModel.loadMissionImageIfNeeded()
        }
    }
}
