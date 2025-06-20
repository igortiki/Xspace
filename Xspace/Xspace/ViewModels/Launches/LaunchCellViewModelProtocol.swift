//
//  LaunchCellViewModelProtocol.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/9/25.
//  Copyright © 2025 XSpace. All rights reserved.
//

import UIKit

@MainActor
protocol LaunchCellViewModelProtocol: AnyObject {
    var missionName: String { get }
    var dateTimeString: String { get }
    var rocketDescription: String { get }
    var daysSinceText: String { get }
    var fromNowText: String { get }
    var successIcon: UIImage? { get }
    var successIconTintColor: UIColor { get }
    var missionPatchImage: UIImage? { get }
    func prepareImage(completion: @escaping (UIImage?) -> Void)
    func cancelImageLoad()
}
