//
//  CurrenciyConverterServices.swift
//  PayPay
//
//  Created by Wirawan on 26/12/22.
//

import Foundation

protocol OpenExchangeServiceProtocol {
    func fetchCurrencyList(completion: @escaping (Result<CurrencyListResponse, OpenExchangeError>) -> Void)
    func fetchCurrencyLatestRates(completion: @escaping (Result<CurrencyRateResponse, OpenExchangeError>) -> Void)
}
