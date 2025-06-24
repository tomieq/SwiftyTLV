//
//  DataConvertible.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 24/06/2025.
//
import Foundation

public protocol DataConvertible {
    var data: Data { get }
}
extension Data: DataConvertible {
    public var data: Data {
        self
    }
}
extension BerTlv: DataConvertible {}
extension TagInfo: DataConvertible {}
extension String: DataConvertible {
    public var data: Data {
        Data(hexString: self)
    }
}
extension Array: DataConvertible where Element == BerTlv {
    public var data: Data {
        self.reduce(Data(), +)
    }
}
