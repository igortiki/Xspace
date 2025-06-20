//
//  FormatterHelper.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/9/25.
//  Copyright © 2025 XSpace. All rights reserved.
//

import Foundation

final class FormatterHelper {
    
    // MARK: - Date Formatting
    static func formattedDate(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    static func formattedTime(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    // MARK: - Relative Time
    static func relativeDate(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    // MARK: - Day Calculations
    static func daysSince(from timestamp: Int) -> Int? {
        let launchDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return Calendar.current.dateComponents([.day], from: launchDate, to: Date()).day
    }
    
    static func signedDaysDifference(from timestamp: Int) -> String {
        let launchDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let now = Date()
        let days = Calendar.current.dateComponents([.day], from: now, to: launchDate).day ?? 0
        return String(format: "%+d", days)
    }
    
    static func formattedValuation(_ valuation: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: valuation)) ?? "\(valuation)"
    }
}
