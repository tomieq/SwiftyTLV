//
//  TlvBox.swift
//  SwiftyTLV
//
//  Created by Tomasz on 17/06/2025.
//
import Foundation

public protocol DataConvertible {
    var data: Data { get }
}

public struct TlvBox<T: DataConvertible> {
    public let tag: T
    public let value: Data

    public init(tag: T, value: Data) {
        self.tag = tag
        self.value = value
    }

    public init(tag: T, value: T) {
        self.tag = tag
        self.value = value.data
    }

    public init(tag: T, hexString: String) {
        self.tag = tag
        self.value = Data(hexString: hexString)
    }
}
