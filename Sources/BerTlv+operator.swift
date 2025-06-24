//
//  BerTlv+operator.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 24/06/2025.
//

import Foundation

public func +(left: BerTlv, right: BerTlv) -> Data {
    left.data.appending(right.data)
}

public func +(left: Data, right: BerTlv) -> Data {
    left.appending(right.data)
}
