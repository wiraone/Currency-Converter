//
//  OpenExchangeErrorProtocol.swift
//  PayPay
//
//  Created by Wirawan on 26/12/22.
//

import Foundation

protocol OpenExchangeErrorProtocol: Error {
    var title: String? { get }
    var code: Int { get }
}
