//
//  TLVFrame.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation

// Tag Length Value frame
public struct TlvFrame {
    public let tag: UInt8
    public let value: Data

    public init(tag: UInt8, value: Data) {
        self.tag = tag
        self.value = value
    }

    public init(tag: UInt8, value: UInt8) {
        self.tag = tag
        self.value = value.data
    }

    public init(tag: UInt8, hexString: String) {
        self.tag = tag
        self.value = Data(hexString: hexString)
    }
}
