//
//  Network.swift
//  PayPay
//
//  Created by Wirawan on 25/12/22.
//

import Foundation

struct Network {
    static let baseURL = "https://openexchangerates.org/api"
    static let openExchangeRatesAppId = "9f0979bcf08a4b548dca2abbd4e3649b"
    static let openExchangeRatesBaseCurrency = "USD"
    static let refreshTime: Int = 30 // in minutes
    
    struct Endpoint {
        static let currencies = "/currencies.json"
        static let latest = "/latest.json"
    }
    
    struct Error {
        static let title = "Error"
        static let message = "Unknown Error"
        static let code = -1
    }
}
