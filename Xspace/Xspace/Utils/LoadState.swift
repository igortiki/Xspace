//
//  LoadState.swift
//  Xspace
//
//  Created by Igor Malasevschi on 13.06.2025.
//  Copyright © 2025 Xspace. All rights reserved.
//


import Foundation

enum LoadState<T> {
    case loading
    case loaded(T)
    case error(String)
}
