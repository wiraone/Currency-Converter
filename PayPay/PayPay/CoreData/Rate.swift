//
//  Rate.swift
//  PayPay
//
//  Created by Wirawan on 27/12/22.
//

import Foundation
import CoreData

@objc(Rate)
class Rate: NSManagedObject {
    static func create(_ code: String, rateValue: Double, usd: Double, _ context: NSManagedObjectContext) -> Rate {
        let rate = Rate(context: context)
        rate.code = code
        rate.rate = rateValue
        rate.usd = usd
        return rate
    }
}
