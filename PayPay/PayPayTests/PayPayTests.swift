//
//  PayPayTests.swift
//  PayPayTests
//
//  Created by Wirawan on 25/12/22.
//

import XCTest
@testable import PayPay

class PayPayTests: XCTestCase {
    
    private var viewModel: CurrencyConverterViewModel!
    private var openExchangeServiceProtocol: MockOpenExchangeServiceProtocol!
    private var output: MockCurrencyConverterViewModelOutput!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        output = MockCurrencyConverterViewModelOutput()
        self.openExchangeServiceProtocol = MockOpenExchangeServiceProtocol()
        viewModel = CurrencyConverterViewModel(openExchangeServiceProtocol: self.openExchangeServiceProtocol)
        //Clear Configuration Core data
        viewModel.deleteAllData("Configuration")
        viewModel.output = output
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        openExchangeServiceProtocol = nil
        try super.tearDownWithError()
    }

    func testUpdateCurrencyPickerViewWhenFetchCurrencyListSuccess() {
        // given
        let mockResponse = ["IDR": "Indonesian Rupiah", "JPY": "Japanese Yen", "USD": "United States Dollar"]
        openExchangeServiceProtocol.fetcCurrencyListhMockResult = .success(mockResponse)
        // when
        viewModel.fetchCurrenyList()
        // then
        XCTAssertEqual(output.mockCurrencyList.count, 3)
        XCTAssertEqual(output.mockCurrencyList[0].name, "Indonesian Rupiah")
    }
    
    func testUpdateCurrencyPickerViewWhenFetchCurrencyListFailure() {
        //given
        openExchangeServiceProtocol.fetcCurrencyListhMockResult = .failure(OpenExchangeError(title: nil, description: nil, code: nil))
        // when
        viewModel.fetchCurrenyList()
        // then
        XCTAssertEqual(output.mockCurrencyList.count, 0)
    }
    
    func testFirstSelectedCurencyAlwaysUSD() {
        // given
        let mockResponse = ["IDR": "Indonesian Rupiah", "JPY": "Japanese Yen", "USD": "United States Dollar"]
        openExchangeServiceProtocol.fetcCurrencyListhMockResult = .success(mockResponse)
        // when
        viewModel.fetchCurrenyList()
        // then
        XCTAssertEqual(output.mockCurrency?.name, "United States Dollar")
    }
    
    func testUpdateCollectionViewCurrency() {
        // given
        let mockResponse: CurrencyRateResponse = CurrencyRateResponse.init(disclaimer: "disclaimer", license: "license", timestamp: 1672023586, base: "USD", rates: ["AED": 3.6729,"AFN":88.47132,"ALL": 107.340278,"IDR": 15629.5,"ZWL": 322])
        openExchangeServiceProtocol.fetcCurrenyLatesthMockResult = .success(mockResponse)
        // when
        viewModel.fetchCurrencyLatesRates()
        // then
        XCTAssertEqual(output.mockCurrencyConverterResults.count, 5)
    }
    
    func testUpdatePickerViewWhenFetchCurrencyListFailure() {
        //given
        openExchangeServiceProtocol.fetcCurrencyListhMockResult = .failure(OpenExchangeError(title: nil, description: nil, code: nil))
        // when
        viewModel.fetchCurrenyList()
        // then
        XCTAssertEqual(output.mockCurrencyList.count, 0)
    }
    
    func testCalculateCurencyFromYenToIDR() {
        // given 1 USD = 133.71 Yen,  1 USD = 15629.5 IDR
        let rateIDR = 15629.5
        let rateYenPerUSD = 1/133.71
        
        // when
        let value = viewModel.calculate(currency: "YEN", inputValue: 12, rate: rateIDR, rateOnUSD:rateYenPerUSD )

        // then
        XCTAssertEqual(value, 1402.6923939869864)
    }
    
    func testCalculateCurencyFromUSDToIDR() {
        // given 1 USD = 15629.5 IDR
        let rateIDR = 15629.5
        let rateIDRPerUSD = 1/15629.5
        
        // when
        let value = viewModel.calculate(currency: "USD", inputValue: 12, rate: rateIDR, rateOnUSD:rateIDRPerUSD)

        // then
        XCTAssertEqual(value, 187554)
    }
}


class MockOpenExchangeServiceProtocol: OpenExchangeServiceProtocol {
    var fetcCurrencyListhMockResult: Result<CurrencyListResponse, OpenExchangeError>?
    var fetcCurrenyLatesthMockResult: Result<CurrencyRateResponse, OpenExchangeError>?
    
    func fetchCurrencyList(completion: @escaping (Result<CurrencyListResponse, OpenExchangeError>) -> Void) {
        if let result = fetcCurrencyListhMockResult {
            completion(result)
        }
    }
    
    func fetchCurrencyLatestRates(completion: @escaping (Result<CurrencyRateResponse, OpenExchangeError>) -> Void) {
        if let result = fetcCurrenyLatesthMockResult {
            completion(result)
        }
    }
}

class MockCurrencyConverterViewModelOutput: CurrencyConverterViewModelOutput {
    var mockCurrencyList: [Currency] = []
    var mockCurrencyConverterResults: [CurrencyConverterResult] = []
    var mockCurrency: Currency? = nil
    
    
    func didStartFetchAPI() {}
    
    func didFinishFetchAPI() {}
    
    func updateCurrencyPickerView(currencyList: [Currency]) {
        self.mockCurrencyList = currencyList
    }
    
    func updateCurrencyCollectionView(currencyConverterResults: [CurrencyConverterResult]) {
        self.mockCurrencyConverterResults = currencyConverterResults
    }
    
    func updateCurrencyPickerButton(currency: Currency?) {
        self.mockCurrency = currency
    }
}
