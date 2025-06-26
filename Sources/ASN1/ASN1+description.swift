//
//  ASN1+description.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 25/06/2025.
//
import Foundation

extension ASN1: CustomStringConvertible {
    public var description: String {
        printable()
    }
    
    public func printable(indentation: Int = 0, newLine: Bool = true, showFullValue: Bool = false) -> String {
        var desc: String {
            switch self {
            case .integer(let int):
                "INTEGER(\(int))"
            case .integerRaw(let data):
                "INTEGER RAW(\(data.count.below(33).or(showFullValue) ? data.hexString : data.description))"
            case .boolean(let bool):
                "BOOLEAN(\(bool))"
            case .bitString(let data):
                "BITSTRING(\(data.count.below(33).or(showFullValue) ? data.hexString : data.description))"
            case .octetString(let asn):
                "OCTET_STRING \(asn.printable(indentation: indentation.incremented, showFullValue: showFullValue))"
            case .octetStringRaw(let data):
                "OCTET_STRING RAW(\(data.count.below(33).or(showFullValue) ? data.hexString : data.description))"
            case .null:
                "NULL"
            case .objectIdentifier(let string):
                "OID(\"\(string)\")"
            case .objectDescriptor(let string):
                "OBJECT_DESCRIPTOR(\"\(string)\")"
            case .external(let asn1):
                "EXTERNAL(\(asn1))"
            case .real(let data):
                "REAL(\(data.hexString))"
            case .enumerated(let data):
                "ENUMERATED(\(data.hexString))"
            case .embeddedPdv(let asn1):
                "EMBEDDED_PDV(\(asn1))"
            case .utf8String(let string):
                "UTF8STRING(\"\(string)\")"
            case .relativeOid(let string):
                "RELATIVE_OID(\"\(string)\")"
            case .time(let string):
                "TIME(\(string))"
            case .sequence(let array):
                "SEQUENCE [\(array.map { $0.printable(indentation: indentation.incremented, showFullValue: showFullValue) }.joined(separator: ","))\n"
                + String(repeating: "\t", count: indentation) + "]"
            case .set(let array):
                "SET [\(array.map { $0.printable(indentation: indentation.incremented, showFullValue: showFullValue) }.joined(separator: ","))\n"
                + String(repeating: "\t", count: indentation) + "]"
            case .numericString(let string):
                "NUMERIC_STRING(\"\(string)\")"
            case .printableString(let string):
                "PRINTABLE_STRING(\"\(string)\")"
            case .ia5String(let string):
                "IA5_STRING(\"\(string)\")"
            case .utcTime(let date):
                "UTC_TIME(\(date))"
            case .generalizedTime(let date):
                "GENERALIZED_TIME(\(date))"
            case .visibleString(let string):
                "VISIBLE_STRING(\"\(string)\")"
            case .generalString(let string):
                "GENERAL_STRING(\"\(string)\")"
            case .date(let date):
                "DATE(\(date))"
            case .timeOfDay(let hour, let minute, let second):
                "TIME_OF_DAY(\(hour):\(minute):\(second))"
            case .dateTime(let date):
                "DATE_TIME(\(date))"
            case .contextSpecificPrimitive(let asn1):
                printableWrapped(name: "CONTEXT_SPECIFIC primitive", asn1: asn1, showFullValue: showFullValue)
            case .contextSpecificConstructed(let tag, let asnList):
                "CONTEXT_SPECIFIC constructed [\(tag)] (EXPLICIT or CHOICE)\(asnList.map { $0.printable(indentation: indentation.incremented, showFullValue: showFullValue) }.joined())"
            case .applicationPrimitive(let asn1):
                printableWrapped(name: "APPLICATION primitive", asn1: asn1, showFullValue: showFullValue)
            case .applicationConstructed(let tag, let asnList):
                "APPLICATION constructed [\(tag)]\(asnList.map { $0.printable(indentation: indentation.incremented, showFullValue: showFullValue) }.joined())"
            case .customTlv(let tlv):
                "CUSTOM_TLV(tag: \(tlv.tag.hexString) -> \(tlv.tagInfo), value: \(tlv.value.count.below(33).or(showFullValue) ? tlv.value.hexString : tlv.value.description))"
            }
        }
        return (newLine ? "\n" : "") + String(repeating: "\t", count: indentation) + desc
    }
    
    private func printableWrapped(name: String, asn1: ASN1, showFullValue: Bool) -> String {
        asn1.convert {
            if case .customTlv = $0 {
                asn1.printable(newLine: false, showFullValue: showFullValue)
            } else {
                "\(name) \(asn1.printable(newLine: false, showFullValue: showFullValue))"
            }
        }
    }
}
