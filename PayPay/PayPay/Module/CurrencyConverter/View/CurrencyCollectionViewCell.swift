//
//  CurrencyCollectionViewCell.swift
//  PayPay
//
//  Created by Wirawan on 26/12/22.
//

import Foundation
import UIKit

class CurrencyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var currrencyCodeLabel: UILabel!
    @IBOutlet weak var currrencyValueLabel: UILabel!
    
    func bind(currencyConverterResult: CurrencyConverterResult) {
        
        self.currrencyCodeLabel.text = currencyConverterResult.rate.code
        self.currrencyValueLabel.text = currencyConverterResult.value.formattedWithSeparator
        self.currrencyValueLabel.adjustsFontSizeToFitWidth = true
        self.currrencyValueLabel.numberOfLines = 0
        self.currrencyValueLabel.minimumScaleFactor = 0.2
    }
}
