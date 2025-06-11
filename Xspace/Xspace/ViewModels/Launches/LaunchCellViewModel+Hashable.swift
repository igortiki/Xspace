//
//  LaunchCellViewModel+Hashable.swift
//  Xspace
//
//  Created by Igor Malasevschi on 11.06.2025.
//  Copyright © 2025 Xspace. All rights reserved.
//



import Foundation

extension LaunchCellViewModel: Hashable {
    static func == (lhs: LaunchCellViewModel, rhs: LaunchCellViewModel) -> Bool {
        lhs.missionName == rhs.missionName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(missionName)
    }
}
