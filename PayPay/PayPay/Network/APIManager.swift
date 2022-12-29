//
//  APIServices.swift
//  PayPay
//
//  Created by Wirawan on 26/12/22.
//

import Foundation

class APIManager: OpenExchangeServiceProtocol {

    // MARK: - Fetch currency list from open exchange api.
    /// Get a JSON list of all currency symbols available from the Open Exchange Rates API, along with their full names
     
    func fetchCurrencyList(completion: @escaping (Result<CurrencyListResponse, OpenExchangeError>) -> Void) {
        
        // For this example we are not set any parameter to true so we can exclude parameter from the url request
        let baseURL = Network.baseURL
        let endpoint = Network.Endpoint.currencies
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            guard let data = data else { return }
          
            DispatchQueue.main.async {

                if let currentListResponse = try? JSONDecoder().decode(CurrencyListResponse.self, from: data) {
                    completion(.success(currentListResponse))
                } else {
                    let openExchangeError = OpenExchangeError(title: nil, description: error?.localizedDescription, code: -1)
                    completion(.failure(openExchangeError))
                }
            }
        }.resume()
    }
    
    // Fetch currency list from open exchange api.
    ///
    /// Get a JSON list of all currency symbols available from the Open Exchange Rates API, along with their full names
    /// Query params
    /// `prettyprint`
    /// `show_alternative` Include alternative currencies.
    /// `show_inactive` Include historical/inactive currencies
    ///
    //
    func fetchCurrencyLatestRates(completion: @escaping (Result<CurrencyRateResponse, OpenExchangeError>) -> Void) {
        // For this example we are not set any parameter to true so we can exclude parameter from the url request
        let baseURL = Network.baseURL
        let endpoint = Network.Endpoint.latest
        let appId = Network.openExchangeRatesAppId
        let baseCurrency = Network.openExchangeRatesBaseCurrency

        guard let url = URL(string: "\(baseURL)\(endpoint)?app_id=\(appId)&base=\(baseCurrency)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, res, error in
            guard let data = data else { return }
         
            DispatchQueue.main.async {

                if let currentListResponse = try? JSONDecoder().decode(CurrencyRateResponse.self, from: data) {
                    completion(.success(currentListResponse))
                } else {
                    let openExchangeError = OpenExchangeError(title: nil, description: error?.localizedDescription, code: -1)
                    completion(.failure(openExchangeError))
                }
            }
        }.resume()
    }
}
