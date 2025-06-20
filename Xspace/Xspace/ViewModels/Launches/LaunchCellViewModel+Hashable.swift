//
//  LaunchCellViewModel+Hashable.swift
//  XSpace
//
//  Created by Igor Malasevschi on 11.06.2025.
//  Copyright © 2025 XSpace. All rights reserved.
//



import Foundation

extension LaunchCellViewModel: Hashable {
    nonisolated static func == (lhs: LaunchCellViewModel, rhs: LaunchCellViewModel) -> Bool {
        lhs.launchID == rhs.launchID
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(launchID)
    }
}


