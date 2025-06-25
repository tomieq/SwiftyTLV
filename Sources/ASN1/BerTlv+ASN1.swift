//
//  BerTlv+ASN1Value.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 25/06/2025.
//
import Foundation
import SwiftExtensions

public enum ASN1Error: Error {
    case invalidOIDValue(String)
    case invalidObjectDescriptorValue
    case invalidUTF8StringValue
    case invalidRelativeOIDValue
    case invalidTimeValue
    case invalidNumericStringValue
    case invalidPrintableStringValue
    case invalidIA5StringValue
    case invalidGeneralStringValue
    case invalidTimeOfDayStringValue(String)
}

extension BerTlv {
    var asn1: ASN1 {
        get throws {
            switch tagInfo.class {
            case .contextSpecific:
                switch tagInfo.form {
                case .primitive:
                        .contextSpecificPrimitive(try primitive)
                case .constructed:
                        .contextSpecificConstructed(tag: tagInfo.number,
                                                    try BerTlv.list(data: value).map { try $0.asn1 })
                }
                   
            case .application:
                switch tagInfo.form {
                case .primitive:
                        .applicationPrimitive(try primitive)
                case .constructed:
                        .applicationConstructed(tag: tagInfo.number,
                                                try BerTlv.list(data: value).map { try $0.asn1 })
                }
                    
            default:
                try primitive
            }
        }
    }
    private var primitive: ASN1 {
        get throws {
            switch tagInfo.tagType {
            case .boolean:
                    .boolean(try value.uInt8.above(0))
            case .integer:
                Optional { try value.int }.map { .integer($0) }.or(.customTlv(self))
            case .bitString:
                    .bitString(value)
            case .octetString:
                    .octetString(value)
            case .null:
                    .null
            case .objectIdentifier:
                    .objectIdentifier(
                        try OID.decode(value)
                            .orThrow(ASN1Error.invalidOIDValue(value.hexString))
                    )
            case .objectDescriptor:
                    .objectDescriptor(
                        try String(data: value, encoding: .utf8)
                            .orThrow(ASN1Error.invalidObjectDescriptorValue)
                    )
            case .external:
                    .external(try ASN1(tlv: BerTlv.from(data: value)))
            case .real:
                    .real(value)
            case .enumerated:
                    .enumerated(value)
            case .embeddedPdv:
                    .embeddedPdv(try ASN1(tlv: BerTlv.from(data: value)))
            case .utf8String:
                    .utf8String(try String(data: value, encoding: .utf8)
                        .orThrow(ASN1Error.invalidUTF8StringValue)
                    )
            case .relativeOid:
                    .relativeOid(try OID.decode(value)
                        .orThrow(ASN1Error.invalidRelativeOIDValue)
                    )
            case .time:
                    .time(try String(data: value, encoding: .utf8)
                        .orThrow(ASN1Error.invalidTimeValue))
            case .sequence:
                    .sequence(try BerTlv.list(data: value).map { try $0.asn1 })
            case .set:
                    .set(try BerTlv.list(data: value).map { try $0.asn1 })
            case .numericString:
                    .numericString(try String(data: value, encoding: .utf8)
                        .orThrow(ASN1Error.invalidNumericStringValue)
                    )
            case .printableString:
                    .printableString(try String(data: value, encoding: .utf8)
                        .orThrow(ASN1Error.invalidPrintableStringValue)
                    )
            case .ia5String:
                    .ia5String(try String(data: value, encoding: .ascii)
                        .orThrow(ASN1Error.invalidIA5StringValue)
                    )
            case .utcTime:
                    .utcTime(try Date(derUtcTime: value))
            case .generalizedTime:
                    .generalizedTime(try Date(derGeneralizedTime: value))
            case .visibleString:
                String(data: value, encoding: .ascii).map {
                    .visibleString($0)
                }.or(.customTlv(self))
            case .generalString:
                .generalString(try String(data: value, encoding: .utf8)
                        .orThrow(ASN1Error.invalidGeneralStringValue))
            case .date:
                    .date(try Date(derDate: value))
            case .timeOfDay:
                try String(data: value, encoding: .utf8)
                    .orThrow(ASN1Error.invalidTimeOfDayStringValue(value.hexString))
                    .convert { text in
                        let parts = try text.split(":").triple
                        let numbers = try zip(parts.0.decimal, parts.1.decimal, parts.2.decimal)
                            .orThrow(ASN1Error.invalidTimeOfDayStringValue(text))
                        return .timeOfDay(hour: numbers.0, minute: numbers.1, second: numbers.2)
                    }
                
            case .dateTime:
                    .dateTime(try Date(derDateTime: value))
            default:
                    .customTlv(self)
            }
        }
    }
}
