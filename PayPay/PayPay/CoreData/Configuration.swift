//
//  Configuration.swift
//  PayPay
//
//  Created by Wirawan on 27/12/22.
//

import Foundation
import CoreData

@objc(Configuration)
class Configuration: NSManagedObject {
    static func create(_ lastUpdate: Date, _ context: NSManagedObjectContext) -> Configuration {
        let configuration = Configuration(context: context)
        configuration.lastUpdate = Date()
        return configuration
    }
}
