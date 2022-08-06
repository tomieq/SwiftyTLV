//
//  SimpleTlvParser.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation

public enum SimpleTlvParserError: Error {
    case invalidData(String)
}

public enum SimpleTlvParser {
    public static func parse(data: Data) throws -> [TlvFrame] {
        var result = [TlvFrame]()

        var index: Int = 0
        while index < data.count {
            let tag: UInt8 = data[index]
            index += 1
            do {
                let payloadSize = try self.getValueLenght(data: data, offset: index)
                index += try self.getLengthOffset(tlvData: data, offset: index)
                if payloadSize > 0 {
                    let payload = try data.subArray(offset: index, length: payloadSize)
                    let frame = TlvFrame(tag: tag, value: payload)
                    result.append(frame)
                }

                index += payloadSize
            } catch {
                print("Problem while parsing tag \(tag.hexString)")
                throw error
            }
        }
        return result
    }

    static func getLengthOffset(tlvData: Data, offset: Int) throws -> Int {
        guard let data = tlvData[safeIndex: offset] else {
            let info = "Cannot calculate size offset as index \(offset) is out of bound (data size is \(tlvData.count))"
            print(info)
            throw SimpleTlvParserError.invalidData(info)
        }
        switch data {
        case 0xFF:
            return 3
        default:
            return 1
        }
    }

    static func getValueLenght(data: Data, offset: Int) throws -> Int {
        func byte(offset: Int) throws -> UInt8 {
            guard let byte = data[safeIndex: offset] else {
                let info = "Cannot calculate payload size as index \(offset) is out of bound (data size is \(data.count))"
                print(info)
                throw SimpleTlvParserError.invalidData(info)
            }
            return byte
        }
        let prefix = try byte(offset: offset)

        switch prefix {
        case 0xFF:
            let size1 = try byte(offset: offset + 1)
            let size2 = try byte(offset: offset + 2)
            var data = Data()
            data.append(size1)
            data.append(size2)
            return data.int
        default:
            return prefix.int
        }
    }

    public static func makeValueLength(payload: Data) -> Data {
        let length = payload.count
        var resultData: Data = Data()

        if (length < 0xFF) {
            resultData.append(length.byte)
            return resultData
        }

        resultData.append(0xFF)
        resultData.append(length.data)
        return resultData
    }

    public static func serialize(_ tlv: TlvFrame) -> Data {
        var data = Data()
        data.append(tlv.tag)
        data.append(self.makeValueLength(payload: tlv.value))
        data.append(tlv.value)
        return data
    }
}
