//
//  Currencies.swift
//  PayPay
//
//  Created by Wirawan on 27/12/22.
//

import Foundation
import CoreData

@objc(Currency)
class Currency: NSManagedObject {
    static func create(_ code: String, name: String, _ context: NSManagedObjectContext) -> Currency {
        let currency = Currency(context: context)
        currency.code = code
        currency.name = name
        return currency
    }
}
