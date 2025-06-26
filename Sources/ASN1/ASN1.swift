//
//  ASN1Value.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 24/06/2025.
//
import Foundation
import SwiftExtensions

public indirect enum ASN1 {
    case integer(Int)
    case integerRaw(Data) // it's INTEGER, but carry Data
    case boolean(Bool)
    case bitString(Data)
    case octetString(ASN1)
    case octetStringRaw(Data)
    case null
    case objectIdentifier(String)
    case objectDescriptor(String)
    case external(ASN1)
    case real(Data)
    case enumerated(Data)
    case embeddedPdv(ASN1)
    case utf8String(String)
    case relativeOid(String)
    case time(String)
    case sequence([ASN1])
    case set([ASN1])
    case numericString(String)
    case printableString(String)
    case ia5String(String)
    case utcTime(Date)
    case generalizedTime(Date)
    case visibleString(String)
    case generalString(String)
    case date(Date)
    case timeOfDay(hour: Int, minute: Int, second: Int)
    case dateTime(Date)
    case contextSpecificPrimitive(ASN1)
    case contextSpecificConstructed(tag: Int, [ASN1])
    case applicationPrimitive(ASN1)
    case applicationConstructed(tag: Int, [ASN1])
    case customTlv(BerTlv)
    
    public init(tlv: BerTlv) throws {
        self = try tlv.asn1
    }
    
    public init(data: Data) throws {
        self = try BerTlv.from(data: data).asn1
    }
}

extension ASN1: Equatable {}


extension ASN1 {
    public var tlv: BerTlv {
        get throws {
            switch self {
            case .integer(let int):
                BerTlv(tag: .INTEGER, value: int.data)
            case .integerRaw(let data):
                BerTlv(tag: .INTEGER, value: data)
            case .boolean(let bool):
                BerTlv(tag: .BOOLEAN, value: bool ? Data([0xFF]) : Data([0x00]))
            case .bitString(let data):
                BerTlv(tag: .BITSTRING, value: data)
            case .octetString(let asn):
                BerTlv(tag: .OCTET_STRING, value: try asn.data)
            case .octetStringRaw(let data):
                BerTlv(tag: .OCTET_STRING, value: data)
            case .null:
                BerTlv(tag: .NULL)
            case .objectIdentifier(let string):
                BerTlv(tag: .OBJECT_IDENTIFIER, value: OID.encode(string))
            case .objectDescriptor(let string):
                BerTlv(tag: .OBJECT_DESCRIPTOR, value: string.data(using: .utf8))
            case .external(let asn):
                BerTlv(tag: TagInfo(class: .universal, form: .constructed, type: .external),
                       value: try asn.data)
            case .real(let data):
                BerTlv(tag: .REAL, value: data)
            case .enumerated(let data):
                BerTlv(tag: .ENUMERATED, value: data)
            case .embeddedPdv(let asn):
                BerTlv(tag: TagInfo(class: .universal, form: .constructed, type: .embeddedPdv),
                       value: try asn.data)
            case .utf8String(let string):
                BerTlv(tag: .UTF8_STRING, value: string.data(using: .utf8))
            case .relativeOid(let string):
                BerTlv(tag: .RELATIVE_OBJECT_IDENTIFIER, value: OID.encode(string))
            case .time(let string):
                BerTlv(tag: .TIME, value: string.data(using: .utf8))
            case .sequence(let asnList):
                BerTlv(tag: .SEQUENCE,
                       value: try asnList.map { try $0.tlv }.data)
            case .set(let asnList):
                BerTlv(tag: .SET,
                       value: try asnList.map { try $0.tlv }.data)
            case .numericString(let string):
                BerTlv(tag: .NUMERIC_STRING, value: string.data(using: .utf8))
            case .printableString(let string):
                BerTlv(tag: .PRINTABLE_STRING, value: string.data(using: .utf8))
            case .ia5String(let string):
                BerTlv(tag: .IA5_STRING, value: string.data(using: .ascii))
            case .utcTime(let date):
                BerTlv(tag: .UTC_TIME, value: try date.derUtcTime)
            case .generalizedTime(let date):
                BerTlv(tag: .GENERALIZED_TIME, value: try date.derGeneralizedTime)
            case .visibleString(let string):
                BerTlv(tag: .VISIBLE_STRING, value: string.data(using: .ascii))
            case .generalString(let string):
                BerTlv(tag: .GENERAL_STRING, value: string.data(using: .utf8))
            case .date(let date):
                BerTlv(tag: .DATE, value: try date.derDate)
            case .timeOfDay(let hour, let minute, let second):
                BerTlv(tag: .TIME_OF_DAY, value: "\(hour.timeOfDay):\(minute.timeOfDay):\(second.timeOfDay)".data(using: .utf8))
            case .dateTime(let date):
                BerTlv(tag: .DATE_TIME, value: try date.derDateTime)
                
            case .contextSpecificPrimitive(let asn):
                try contextSpecificPrimitive(asn)
            case .contextSpecificConstructed(let tag, let asnList): // explicit
                try contextSpecificConstructed(tag: tag, asnList)
            case .applicationPrimitive(let asn):
                try applicationPrimitive(asn)
            case .applicationConstructed(let tag, let asnList):
                try applicationConstructed(tag: tag, asnList)
                
            case .customTlv(let tlv):
                tlv
            }
            
        }
        
    }
    private func contextSpecificPrimitive(_ asn: ASN1) throws -> BerTlv {
        let tlv = try asn.tlv
        return BerTlv(tag: tlv.tagInfo.with(class: .contextSpecific), value: tlv.value)
    }
    private func contextSpecificConstructed(tag: Int, _ asn: [ASN1]) throws -> BerTlv {
        try BerTlv(tag: TagInfo(class: .contextSpecific, form: .constructed, number: tag),
               value: asn.map { try $0.tlv }.data)
    }
    private func applicationPrimitive(_ asn: ASN1) throws -> BerTlv {
        let tlv = try asn.tlv
        return BerTlv(tag: tlv.tagInfo.with(class: .application), value: tlv.value)
    }
    private func applicationConstructed(tag: Int, _ asn: [ASN1]) throws -> BerTlv {
        try BerTlv(tag: TagInfo(class: .application, form: .constructed, number: tag),
               value: asn.map { try $0.tlv }.data)
    }
    
    public var data: Data {
        get throws {
            try tlv.data
        }
    }
}

extension ASN1: Convertible {}
fileprivate extension Int {
    var timeOfDay: String {
        String(format: "%02d", self)
    }
}
