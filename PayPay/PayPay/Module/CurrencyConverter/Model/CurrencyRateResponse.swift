//
//  LatestRates.swift
//  PayPay
//
//  Created by Wirawan on 26/12/22.
//

import Foundation

// MARK: - LatesRates
struct CurrencyRateResponse: Codable {
    let disclaimer: String
    let license: String
    let timestamp: Int
    let base: String
    let rates: [String: Double]
}
