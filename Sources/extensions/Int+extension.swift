//
//  Int+extension.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation

extension Int {
    public var hexString: String {
        var hexString = String(format: "%04X", self)
        if ((hexString.count % 2) == 1){
            hexString = "0" + hexString
        }
        return hexString
    }

    public var data: Data {
        Data(hexString: self.hexString)
    }

    public var byte: UInt8 {
        UInt8(self & 0xFF)
    }
}
