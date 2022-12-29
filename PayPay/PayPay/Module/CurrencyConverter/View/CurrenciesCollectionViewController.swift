//
//  CurrenciesCollectionView.swift
//  PayPay
//
//  Created by Wirawan on 26/12/22.
//

import Foundation
import UIKit

class CurrenciesCollectionViewController: UICollectionViewController {    
    // MARK: - Properties
    var currencyConverterResults: [CurrencyConverterResult] = []
    
    private let reuseIdentifier = Identifier.currencyCell
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets( top: 10.0, left: 0, bottom: 20.0, right: 0)
    private let containerPadding: CGFloat = 30
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Collection Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currencyConverterResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CurrencyCollectionViewCell {
            let currencyConverterResult = self.currencyConverterResults[indexPath.item]
            cell.bind(currencyConverterResult: currencyConverterResult)
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - Collection View Flow Layout Delegate
extension CurrenciesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
           let availableWidth = view.frame.width - containerPadding - paddingSpace
           let widthPerItem = availableWidth / itemsPerRow
           
           return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

