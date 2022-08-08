//
//  BerTlvParser.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation

public enum BerTlvParserError: Error {
    case invalidData(String)
}

public enum BerTlvParser {
    public static func parse(data: Data) throws -> [TlvFrame] {
        var result: [TlvFrame] = []

        var index: Int = 0
        while index < data.count {
            if data[index] == 0 {
                index += 1
                continue
            }
            let tag: UInt8 = data[index]
            index += 1
            do {
                let valueLength = try self.getValueLength(data: data, offset: index)
                index += try self.getLengthOffset(tlvData: data, offset: index)
                if valueLength > 0 {
                    let value = try data.subArray(offset: index, length: valueLength)
                    let frame = TlvFrame(tag: tag, value: value)
                    result.append(frame)
                }
                index += valueLength
            } catch {
                print("Problem while parsing tag \(tag.hexString)")
                throw error
            }
        }
        return result
    }

    public static func getLengthOffset(tlvData: Data, offset: Int) throws -> Int {
        guard let data = tlvData[safeIndex: offset] else {
            let info = "Cannot calculate size offset as index \(offset) is out of bound (data size is \(tlvData.count))"
            print(info)
            throw BerTlvParserError.invalidData(info)
        }

        switch data & 0x80 {
        case 0x80:
            return (data & 0x0F).int + 1
        default:
            return 1
        }
    }

    public static func getValueLength(data: Data, offset: Int) throws -> Int {
        func byte(offset: Int) throws -> UInt8 {
            guard let byte = data[safeIndex: offset] else {
                let info = "Cannot calculate payload size as index \(offset) is out of bound (data size is \(data.count))"
                print(info)
                throw BerTlvParserError.invalidData(info)
            }
            return byte
        }

        let prefix = try byte(offset: offset)

        switch prefix & 0x80 {
        case 0x80:
            let numberOfBytes = (prefix & 0x0F).int
            return try data.subArray(offset: offset + 1, length: numberOfBytes).int
        default:
            return prefix.int
        }
    }

    public static func makeValueLength(value: Data) -> Data {
        let length = value.count
        var resultData: Data = Data()

        if length < 0x80 {
            resultData.append(length.byte)
            return resultData
        } else if length <= 0xFF {
            resultData.append(0x81)
            resultData.append(length.byte)
            return resultData
        } else if length <= 0xFFFF {
            resultData.append(0x82)
            resultData.append(length.data)
            return resultData
        } else if length <= 0xFFFFFF {
            resultData.append(0x83)
            resultData.append(length.data)
            return resultData
        }
        resultData.append(0x84)
        resultData.append(length.data)
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
