//
//  OpenExchangeError.swift
//  PayPay
//
//  Created by Wirawan on 26/12/22.
//

import Foundation

struct OpenExchangeError: OpenExchangeErrorProtocol {

    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }

    private var _description: String

    init(title: String?, description: String?, code: Int?) {
        self.title = title ?? Network.Error.title
        self._description = description ?? Network.Error.message
        self.code = code ?? Network.Error.code
    }
}
