//
//  BerTlv+OID.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 20/06/2025.
//

public extension BerTlv {
    var oid: String? {
        guard tagInfo.tagType == .objectIdentifier else {
            return nil
        }
        return OID.decode(value)
    }
}
