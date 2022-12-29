//
//  Date.swift
//  PayPay
//
//  Created by Wirawan on 27/12/22.
//

import Foundation

extension Date {
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
 }
