//
//  TLVFrame.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//


extension UInt8: DataConvertible {}
extension UInt16: DataConvertible {}

// Tag Length Value frame
public typealias TlvFrame = TlvBox<UInt8>
public typealias TlvFrame16 = TlvBox<UInt16>
