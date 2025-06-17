//
//  SimpleTlvParser.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation

public enum SimpleTlvParser {
    public static func parse(data: Data) throws -> [TlvFrame] {
        var result = [TlvFrame]()
        var data = data
        while data.isEmpty.not {
            let tag = data.consume(bytes: 1)
            do {
                let lenght = try self.getLenght(data: &data)
                if lenght > 0 {
                    let payload = data.consume(bytes: lenght)
                    let frame = TlvFrame(tag: tag, value: payload)
                    result.append(frame)
                }
            } catch {
                print("Problem while parsing tag \(tag.hexString)")
                throw error
            }
        }
        return result
    }

    public static func getLenght(data: inout Data) throws -> Int {
        let prefix = data.consume(bytes: 1)

        switch try prefix.uInt8 {
        case 0xFF:
            return try data.consume(bytes: 2).int
        default:
            return try prefix.int
        }
    }

    public static func makeValueLength(payload: Data) -> Data {
        let length = payload.count
        var resultData: Data = Data()

        if (length < 0xFF) {
            resultData.append(UInt8(length))
            return resultData
        }

        resultData.append(0xFF)
        resultData.append(UInt16(length).data)
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
