//
//  TLVFrame.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//
import Foundation

public struct TlvFrame {
    public let tag: Data
    public let value: Data

    public init(tag: Data, value: Data) {
        self.tag = tag
        self.value = value
    }

    public init(tag: Data, hexString: String) {
        self.tag = tag
        self.value = Data(hexString: hexString)
    }
    
    public init(tag: String, hexString: String) {
        self.tag = Data(hexString: tag)
        self.value = Data(hexString: hexString)
    }
    
    public init(tag: UInt8, hexString: String) {
        self.tag = tag.data
        self.value = Data(hexString: hexString)
    }
    
    public init(tag: UInt8, value: Data) {
        self.tag = tag.data
        self.value = value
    }
}
