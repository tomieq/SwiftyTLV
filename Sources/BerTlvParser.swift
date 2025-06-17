//
//  BerTlvParser.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation
import SwiftExtensions

public enum BerTlvParser {
    public static func parse(data: Data) throws -> [TlvFrame] {
        var result: [TlvFrame] = []
        var data = data
        while data.isEmpty.not {
            let tag = try data.consume(bytes: 1).uInt8
            do {
                let length = try self.getLength(data: &data)
                if length > 0 {
                    let value = data.consume(bytes: length)
                    let frame = TlvFrame(tag: tag, value: value)
                    result.append(frame)
                }
            } catch {
                print("Problem while parsing tag \(tag.hexString)")
                throw error
            }
        }
        return result
    }

    public static func getLength(data: inout Data) throws -> Int {
        let prefix = try data.consume(bytes: 1).uInt8

        switch prefix & 0x80 {
        case 0x80:
            let numberOfBytes = (prefix & 0x0F).int
            return try data.consume(bytes: numberOfBytes).int
        default:
            return prefix.int
        }
    }

    public static func makeValueLength(value: Data) -> Data {
        let length = value.count
        var resultData: Data = Data()

        if length < 0x80 {
            resultData.append(UInt8(length))
            return resultData
        } else if length <= 0xFF {
            resultData.append(0x81)
            resultData.append(UInt8(length))
            return resultData
        } else if length <= 0xFFFF {
            resultData.append(0x82)
            resultData.append(UInt16(length).data)
            return resultData
        } else if length <= 0xFFFFFF {
            resultData.append(0x83)
            resultData.append(UInt24(length).data)
            return resultData
        }
        resultData.append(0x84)
        resultData.append(UInt32(length).data)
        return resultData
    }

    public static func serialize(_ tlv: TlvFrame) -> Data {
        var data = Data()
        data.append(tlv.tag.data)
        data.append(self.makeValueLength(value: tlv.value))
        data.append(tlv.value)
        return data
    }
}
