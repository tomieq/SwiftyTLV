//
//  BerTlvParser.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation
import SwiftExtensions

public enum BerTagLength {
    case auto
    case fixed(Int)
}

public enum BerTlvParser {
    public static func parse(data: Data, tagLength: BerTagLength = .auto) throws -> [TlvFrame] {
        var data = data
        func tag() -> Data {
            switch tagLength {
            case .auto:
                var tag = data.consume(bytes: 1)
                if try! tag.uInt8.isBitSet(mask: 0x1F) {
                    tag.append(data.consume(bytes: 1))
                    while data[safeIndex: 0].or(0).isBitSet(mask: 0x80) {
                        tag.append(data.consume(bytes: 1))
                    }
                }
                return tag
            case .fixed(let size):
               return data.consume(bytes: size)
            }
        }
        var result: [TlvFrame] = []
        
        while data.isEmpty.not {
            let tag = tag()
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
        data.append(tlv.tag)
        data.append(self.makeValueLength(value: tlv.value))
        data.append(tlv.value)
        return data
    }
}
