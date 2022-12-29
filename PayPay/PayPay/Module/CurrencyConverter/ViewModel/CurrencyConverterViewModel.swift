//
//  CurrencyConverterViewModel.swift
//  PayPay
//
//  Created by Wirawan on 27/12/22.
//

import Foundation
import CoreData

class CurrencyConverterViewModel {
    weak var output: CurrencyConverterViewModelOutput?
    private let openExchangeServiceProtocol: OpenExchangeServiceProtocol
    
    init(openExchangeServiceProtocol: OpenExchangeServiceProtocol) {
        self.openExchangeServiceProtocol = openExchangeServiceProtocol
    }
  
    // MARK: - Public Method
    func getCurrencyText(currency: Currency?) -> String {
        guard let selectedCurrency = currency,
              let currencyName = selectedCurrency.name,
                let currencyCode = selectedCurrency.code else {
            return "-"
        }

        return "\(currencyName)(\(currencyCode))"
    }
    
    func fetchCurrenyList() {
        
        if self.isShouldLoadFromAPI() {
            self.output?.didStartFetchAPI()
            
            openExchangeServiceProtocol.fetchCurrencyList { [weak self] result in
                switch result {
                case .success(let response):
                    self?.saveCurrencyListToCoreData(currencyListResponse: response)
                    self?.fetchCurrencyListFromCoreData()
                case .failure:
                    self?.output?.updateCurrencyPickerView(currencyList: [])
                    self?.output?.didFinishFetchAPI()
                }
            }
        }
        else {
            self.fetchCurrencyListFromCoreData()
        }
    }
    
    func fetchCurrencyLatesRates() {
        
        if self.isShouldLoadFromAPI() {
            openExchangeServiceProtocol.fetchCurrencyLatestRates { [weak self] result in
                switch result {
                case .success(let response):
                    self?.saveCurrencyRateToCoreData(currencyRateResponse: response)
                    self?.saveConfigurationToCoreData()
                    self?.fetchCurrencyRatesFromCoreData()
                    self?.output?.didFinishFetchAPI()
                case .failure:
                    self?.output?.updateCurrencyCollectionView(currencyConverterResults: [])
                    self?.output?.didFinishFetchAPI()
                }
            }
        }
        else {
            self.fetchCurrencyRatesFromCoreData()
        }
    }
    
    func reloadAllCurrencyCollectionView(currencyResults: [CurrencyConverterResult]?, baseCurrency: Currency?, inputValue: Double?) {
        var currencyConverterResults: [CurrencyConverterResult] = []
        
        guard let currencyResultList = currencyResults else {
            self.output?.updateCurrencyCollectionView(currencyConverterResults: currencyConverterResults)
            return
        }
        
        if let currency = currencyResultList.first(where: { $0.rate.code == baseCurrency?.code }) {
            for currencyConverterResult in currencyResultList {
                
                if let baseCurrencyCode = baseCurrency?.code,
                   let input = inputValue {
                    let currencyOnUSD = currency.rate.usd
                    let value = calculate(currency: baseCurrencyCode, inputValue: input, rate: currencyConverterResult.rate.rate, rateOnUSD: currencyOnUSD)
                    let newCurrencyConverter = CurrencyConverterResult.init(rate: currencyConverterResult.rate, value: value)
                    currencyConverterResults.append(newCurrencyConverter)
                }
            }
        }
        
        
        self.output?.updateCurrencyCollectionView(currencyConverterResults: currencyConverterResults)
    }
    
    func calculate(currency: String = Network.openExchangeRatesBaseCurrency,
                   inputValue: Double = 1,
                   rate: Double,
                   rateOnUSD: Double = 1) -> Double {
       
       var result: Double = 0
       
       if currency == Network.openExchangeRatesBaseCurrency {
           result = inputValue * rate
       }
       else {
           result = inputValue * rateOnUSD * rate
       }
       return result
   }

    func isShouldLoadFromAPI() -> Bool {
        guard let lastUpdate = fetchConfiguration() else {
            return true
        }
        let dateDifferencesInMinutes: Int = Date().minutes(from: lastUpdate)
        return dateDifferencesInMinutes >= Network.refreshTime ? true : false
    }
    
    // MARK: - Curreny list Core Data
    func fetchCurrencyListFromCoreData() {
        var currencyList: [Currency] = []
        let fetch: NSFetchRequest<Currency> = Currency.fetchRequest()
        let sortByCode = NSSortDescriptor.init(key: "name", ascending: true)
        let context = AppDelegate.instance.sharedContext()
        fetch.sortDescriptors = [sortByCode]

        if let currencies = try? context.fetch(fetch) {

            for currency in currencies {
                currencyList.append(currency)
            }
        }
        
        if let baseCurrency = currencyList.first(where: { $0.code == Network.openExchangeRatesBaseCurrency }) {
            self.output?.updateCurrencyPickerButton(currency: baseCurrency)
        }
        
        self.output?.updateCurrencyPickerView(currencyList: currencyList)
        
    }
    
    func saveCurrencyListToCoreData(currencyListResponse: CurrencyListResponse) {
        let context = AppDelegate.instance.sharedContext()
        
        self.deleteAllData("Currency")
        
        for (key, value) in currencyListResponse {
            let _ = Currency.create(key, name: value, context)
        }
                
        try? context.save()
    }
    
    // MARK: - Curreny rate Core Data
    func fetchCurrencyRatesFromCoreData() {
        var currencyConverterResults: [CurrencyConverterResult] = []
        let fetch: NSFetchRequest<Rate> = Rate.fetchRequest()
        let context = AppDelegate.instance.sharedContext()
       
        if let rates = try? context.fetch(fetch) {

            for rate in rates {
                let calculateResult = calculate(rate: rate.rate)
                let currencyConverterResult = CurrencyConverterResult.init(rate: rate, value: calculateResult)
                currencyConverterResults.append(currencyConverterResult)
            }
        }
        self.output?.updateCurrencyCollectionView(currencyConverterResults: currencyConverterResults)
    }
    
    func saveCurrencyRateToCoreData(currencyRateResponse: CurrencyRateResponse) {
        let context = AppDelegate.instance.sharedContext()
        
        self.deleteAllData("Rate")
        
        for (key, value) in currencyRateResponse.rates {
            let _ = Rate.create(key, rateValue: value, usd: 1/value,  context)
        }
                
        try? context.save()
    }
    
    // MARK: - Configuration Core Data
    func fetchConfiguration() -> Date? {
        let fetch: NSFetchRequest<Configuration> = Configuration.fetchRequest()
        let context = AppDelegate.instance.sharedContext()
    
        if let date = try? context.fetch(fetch) {
            return date.first?.lastUpdate
        }
        return nil
    }
    
    func saveConfigurationToCoreData() {
        let context = AppDelegate.instance.sharedContext()
        
        self.deleteAllData("Configuration")
        
        let _ = Configuration.create(Date(), context)
        try? context.save()
    }
    
    // MARK: - delete entity on Core Data
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let context = AppDelegate.instance.sharedContext()
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch {}
    }
}
