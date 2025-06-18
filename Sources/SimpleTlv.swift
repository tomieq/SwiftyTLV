//
//  SimpleTlv.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 18/06/2025.
//
import Foundation

public struct SimpleTlv {
    public let tag: UInt8
    public let value: Data

    public init(tag: UInt8, value: Data) {
        self.tag = tag
        self.value = value
    }

    public init(tag: UInt8, value: String) {
        self.tag = tag
        self.value = Data(hexString: value)
    }
}

// MARK: encoder

extension SimpleTlv {
    public var data: Data {
        var data = Data()
        data.append(self.tag)
        data.append(self.makeValueLength(payload: self.value))
        data.append(self.value)
        return data
    }
    
    func makeValueLength(payload: Data) -> Data {
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
}

// MARK: decoder

extension SimpleTlv {
    public static func list(data: Data) throws -> [SimpleTlv] {
        var result = [SimpleTlv]()
        var data = data
        while data.isEmpty.not {
            result.append(try Self.make(data: &data))
        }
        return result
    }
    
    public static func from(data: Data) throws -> SimpleTlv {
        var data = data
        return try Self.make(data: &data)
    }
    
    private static func make(data: inout Data) throws -> SimpleTlv {
        let tag = try data.consume(bytes: 1).uInt8
        do {
            let lenght = try self.getLenght(data: &data)
            let payload = lenght > 0 ? data.consume(bytes: lenght) : Data()
            let frame = SimpleTlv(tag: tag, value: payload)
            return frame
        } catch {
            print("Problem while parsing tag \(tag.hexString)")
            throw error
        }
    }

    static func getLenght(data: inout Data) throws -> Int {
        let prefix = data.consume(bytes: 1)

        switch try prefix.uInt8 {
        case 0xFF:
            return try data.consume(bytes: 2).int
        default:
            return try prefix.int
        }
    }
}
