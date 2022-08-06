//
//  TLVFrame.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation

// Tag Length Value frame
public struct TlvFrame {
    let tag: Data
    let value: Data

    var tag8: UInt8 {
        self.tag[0]
    }

    init(tag: Data, value: Data) {
        self.tag = tag
        self.value = value
    }

    init(tag: UInt8, value: Data) {
        self.tag = tag.data
        self.value = value
    }

    init(tag: UInt8, value: UInt8) {
        self.tag = tag.data
        self.value = value.data
    }

    init(tag: UInt8, hexString: String) {
        self.tag = tag.data
        self.value = Data(hexString: hexString)
    }
}
