//
//  BerTlv.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 18/06/2025.
//
import Foundation
import SwiftExtensions

public enum BerTagLength {
    case auto
    case fixed(Int)
}
public enum BerTlvDecodeError: Error {
    case dataNotConsumed(left: Int)
}

public typealias BerTagType = any Equatable & DataConvertible
final public class BerTlv {
    public let tag: Data
    public let value: Data
    public lazy var tagInfo = (try? TagInfo(data: tag)) ?? TagInfo(class: .universal, form: .primitive, type: .null)

    public init(tag: BerTagType, value: DataConvertible?) {
        self.tag = tag.data
        self.value = (value?.data).or(Data())
    }

    public init(tag: BerTagType, value: String) {
        self.tag = tag.data
        self.value = Data(hexString: value)
    }
    public required init?(rawValue: Data) {
        guard let tlv = try? BerTlv.from(data: rawValue) else {
            return nil
        }
        self.tag = tlv.tag
        self.value = tlv.value
    }
}

extension BerTlv: RawRepresentable {
    public typealias RawValue = Data
    public var rawValue: Data {
        self.data
    }
}
extension BerTlv: Equatable {}
// MARK: encoder

extension BerTlv {
    func makeValueLength(value: Data) -> Data {
        let length = value.count
        var resultData: Data = Data()

        if length < 0x80 {
            resultData.append(asOneByte: length)
            return resultData
        } else if length <= 0xFF {
            resultData.append(0x81)
            resultData.append(asOneByte: length)
            return resultData
        } else if length <= 0xFFFF {
            resultData.append(0x82)
            resultData.append(asTwoBytes: length)
            return resultData
        } else if length <= 0xFFFFFF {
            resultData.append(0x83)
            resultData.append(asThreeBytes: length)
            return resultData
        }
        resultData.append(0x84)
        resultData.append(asFourBytes: length)
        return resultData
    }

    public var data: Data {
        var data = Data()
        data.append(self.tag)
        data.append(self.makeValueLength(value: self.value))
        data.append(self.value)
        return data
    }
}

// MARK: decoder

extension BerTlv {
    public static func list(data: Data, tagLength: BerTagLength = .auto) throws -> [BerTlv] {
        var data = data

        var result: [BerTlv] = []
        while data.isEmpty.not {
            result.append(try make(data: &data, tagLength: tagLength))
        }
        return result
    }
    
    public static func from(data: Data, tagLength: BerTagLength = .auto) throws -> BerTlv {
        var data = data
        let tlv = try make(data: &data, tagLength: tagLength)
        guard data.isEmpty else {
            throw BerTlvDecodeError.dataNotConsumed(left: data.count)
        }
        return tlv
    }
    
    private static func make(data: inout Data, tagLength: BerTagLength) throws -> BerTlv {
        func tag() throws -> Data {
            switch tagLength {
            case .auto:
                var tag = data.consume(bytes: 1)
                if try tag.uInt8.isBitSet(mask: 0x1F) {
                    var next = data.consume(bytes: 1)
                    tag.append(next)
                    while try next.uInt8.isBitSet(mask: 0x80).and(data.isEmpty.not) {
                        next = data.consume(bytes: 1)
                        tag.append(next)
                    }
                }
                return tag
            case .fixed(let size):
               return data.consume(bytes: size)
            }
        }
        let tag = try tag()
        do {
            let length = try self.getLength(data: &data)
            let value = length > 0 ? data.consume(bytes: length) : Data()
            let frame = BerTlv(tag: tag, value: value)
            return frame
        } catch {
            print("Problem while parsing tag \(tag.hexString)")
            throw error
        }
    }

    static func getLength(data: inout Data) throws -> Int {
        let prefix = try data.consume(bytes: 1).uInt8

        switch prefix & 0x80 {
        case 0x80:
            let numberOfBytes = (prefix & 0x0F).int
            return try data.consume(bytes: numberOfBytes).int
        default:
            return prefix.int
        }
    }
}
