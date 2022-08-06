//
//  UnicodeScalar+extension.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation

enum UnicodeScalarError: Error {
    case illegalCharacter(String)
}

extension UnicodeScalar {
    func hex2byte() throws -> UInt8 {
        let value = self.value
        if 48 <= value, value <= 57 {
            return UInt8(value - 48)
        } else if 65 <= value, value <= 70 {
            return UInt8(value - 55)
        } else if 97 <= value, value <= 102 {
            return UInt8(value - 87)
        }
        throw UnicodeScalarError.illegalCharacter("Sign \(value) is not valid hex number")
    }
}
