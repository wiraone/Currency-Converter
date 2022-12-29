//
//  ViewController.swift
//  PayPay
//
//  Created by Wirawan on 25/12/22.
//

import UIKit

class ConverterViewController: UIViewController {
    @IBOutlet weak var curencyTextfield: UITextField!
    @IBOutlet weak var curencyPickerButton: UIButton!
    @IBOutlet weak var loadingIndicatorView: UIView!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    private var viewModel: CurrencyConverterViewModel!
    private var currenciesCollectionViewController: CurrenciesCollectionViewController!
    private var currencyPickerAlert: UIAlertController!
    private var currencyPickerView: UIPickerView!
    private var currencyList: [Currency] = []
    private var baseCurrency: Currency?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initCurrencyPicker()
        
        let openExchangeServiceProtocol: OpenExchangeServiceProtocol = APIManager()
        viewModel = CurrencyConverterViewModel(openExchangeServiceProtocol: openExchangeServiceProtocol)
        viewModel.output = self
        
        viewModel.fetchCurrenyList()
        viewModel.fetchCurrencyLatesRates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Identifier.toCurrenciesCollectionViewController {
            
            if let destinationViewController = segue.destination as? CurrenciesCollectionViewController {
                self.currenciesCollectionViewController = destinationViewController
            }
        }
    }
    
    private func initCurrencyPicker() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 250)
        
        self.currencyPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        self.currencyPickerView.delegate = self
        self.currencyPickerView.dataSource = self
        vc.view.addSubview(self.currencyPickerView)
        
        self.currencyPickerAlert = UIAlertController(title: "Choose currency", message: "", preferredStyle: UIAlertController.Style.alert)
        self.currencyPickerAlert.setValue(vc, forKey: "contentViewController")
        self.currencyPickerAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            
            let buttonTitle = self?.viewModel.getCurrencyText(currency: self?.baseCurrency)
            
            if let currencyText = self?.curencyTextfield.text {
                let inputValue = Double(currencyText)
                self?.viewModel.reloadAllCurrencyCollectionView(currencyResults: self?.currenciesCollectionViewController.currencyConverterResults,
                                                                baseCurrency: self?.baseCurrency,
                                                                inputValue: inputValue)
            }
            
            
            self?.curencyPickerButton.setTitle(buttonTitle, for: .normal)
            self?.currencyPickerAlert.dismiss(animated: true)
            
        }))
        self.currencyPickerAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.currencyPickerAlert.dismiss(animated: true)
        }))
        
    }
    
    @IBAction func didTapCurrencyPickerButton(_ sender: UIButton) {
        self.present(currencyPickerAlert, animated: true)
    }
}

extension ConverterViewController: CurrencyConverterViewModelOutput {
    func updateCurrencyPickerButton(currency: Currency?) {
        let buttonTitle = self.viewModel.getCurrencyText(currency: currency)
        self.curencyPickerButton.setTitle(buttonTitle, for: .normal)
    }
    
    func didStartFetchAPI() {
        loadingIndicatorView.isHidden = false
    }
    
    func didFinishFetchAPI() {
        loadingIndicatorView.isHidden = true
    }
    
    func updateCurrencyPickerView(currencyList: [Currency]) {
        self.currencyList = currencyList
        self.baseCurrency = self.currencyList.first
        self.currencyPickerView.reloadAllComponents()
    }
    
    func updateCurrencyCollectionView(currencyConverterResults: [CurrencyConverterResult]) {
        self.currenciesCollectionViewController.currencyConverterResults = currencyConverterResults
        self.currenciesCollectionViewController.collectionView.reloadData()
        
        if let lastUpdate = viewModel.fetchConfiguration() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY/MM/dd: hh:mm"
            self.lastUpdateLabel.text = "last update at: \n" + dateFormatter.string(from: lastUpdate)
        }
    }
}

extension ConverterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: 60))
        let pickerLabel = UILabel(frame: view.bounds)
        let currency = self.currencyList[row]
        
        pickerLabel.text = viewModel.getCurrencyText(currency: currency)
        pickerLabel.font = UIFont.init(name: "Avenir-Next", size: 14)
        pickerLabel.adjustsFontSizeToFitWidth = true
        pickerLabel.textAlignment = .center
        pickerLabel.lineBreakMode = .byWordWrapping
        pickerLabel.numberOfLines = 0

        view.addSubview(pickerLabel)
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.baseCurrency = self.currencyList[row]
    }
}

extension ConverterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.currencyList.count
    }
}

