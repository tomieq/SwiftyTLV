//
//  Data+extension.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation

extension Data {
    public var int: Int {
        let bytes = self.bytes
        switch count {
        case 1:
            return Int(bytes[0])
        case 2:
            return Int(bytes[0]) << 8 + Int(bytes[1])
        case 3:
            return Int(bytes[0]) << 16 + Int(bytes[1]) << 8 + Int(bytes[2])
        case 4:
            let high = Int(bytes[0]) << 24 + Int(bytes[1]) << 16
            let low = Int(bytes[2]) << 8 + Int(bytes[3])
            return high + low
        default:
            return 0
        }
    }

    var bytes: [UInt8] {
        [UInt8](self)
    }
}

