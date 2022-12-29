//
//  CurrencyConverterViewModelOutput.swift
//  PayPay
//
//  Created by Wirawan on 27/12/22.
//

import Foundation

protocol CurrencyConverterViewModelOutput: AnyObject {
    func didStartFetchAPI()
    func didFinishFetchAPI()
    
    func updateCurrencyPickerView(currencyList: [Currency])
    func updateCurrencyCollectionView(currencyConverterResults: [CurrencyConverterResult])
    func updateCurrencyPickerButton(currency: Currency?)
}
