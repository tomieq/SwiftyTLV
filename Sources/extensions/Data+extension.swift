//
//  Data+extension.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation

public extension Data {
    var asn1: ASN1 {
        get throws {
            try ASN1(data: self)
        }
    }
}
