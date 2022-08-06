//
//  UInt8+extension.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation

extension UInt8 {
    public var data: Data {
        Data([self])
    }

    public var hexString: String {
        String(format: "%02X", self)
    }

    public var int: Int {
        Int(self)
    }
}
