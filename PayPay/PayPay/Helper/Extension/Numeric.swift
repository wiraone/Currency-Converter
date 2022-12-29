//
//  Numeric.swift
//  PayPay
//
//  Created by Wirawan on 28/12/22.
//

import Foundation

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}
