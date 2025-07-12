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
            case .integer(let data):
                "INTEGER(\(data.count.below(33).or(showFullValue) ? "0x\(data.hexString)" : data.description))"
            case .boolean(let bool):
                "BOOLEAN(\(bool))"
            case .bitString(let data):
                (data.count.below(33).or(showFullValue) ? "0x\(data.hexString)" : data.description)
                    .convert { preview in
                        "BITSTRING(\(preview))"
                    }.appending(decodeValueIfPossible(raw: data, indentation: indentation.incremented, showFullValue: showFullValue).or(""))
            case .octetString(let data):
                (data.count.below(33).or(showFullValue) ? "0x\(data.hexString)" : data.description)
                    .convert { preview in
                        "OCTET_STRING(\(preview))"
                    }.appending(decodeValueIfPossible(raw: data, indentation: indentation.incremented, showFullValue: showFullValue).or(""))
            case .octetStringFactory(let asn1):
                asn1.printable(indentation: indentation.incremented, newLine: true, showFullValue: showFullValue)
                    .convert { preview in
                        "OCTET_STRING encoded:\(preview)"
                    }
                
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
                array.map { $0.printable(indentation: indentation.incremented, showFullValue: showFullValue) }.joined()
                    .convert { preview in
                        "SEQUENCE [\(preview)\n"
                    }.appending(String(repeating: "\t", count: indentation) + "]")
            case .set(let array):
                array.map { $0.printable(indentation: indentation.incremented, showFullValue: showFullValue) }.joined()
                    .convert { preview in
                        "SET [\(preview)\n"
                    }.appending(String(repeating: "\t", count: indentation) + "]")
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
                printableWrapped(name: "CONTEXT_SPECIFIC primitive", indentation: indentation.incremented, asn1: asn1, showFullValue: showFullValue)
            case .contextSpecificConstructed(let tag, let asnList):
                "CONTEXT_SPECIFIC constructed [\(tag)] (EXPLICIT or CHOICE)\(asnList.map { $0.printable(indentation: indentation.incremented, showFullValue: showFullValue) }.joined())"
            case .applicationPrimitive(let asn1):
                printableWrapped(name: "APPLICATION primitive", indentation: indentation.incremented, asn1: asn1, showFullValue: showFullValue)
            case .applicationConstructed(let tag, let asnList):
                "APPLICATION constructed [\(tag)]\(asnList.map { $0.printable(indentation: indentation.incremented, showFullValue: showFullValue) }.joined())"
            case .customTlv(let tlv):
                "CUSTOM_TLV(tag: 0x\(tlv.tag.hexString)(\(Optional {try tlv.tag.int}.or(0))) -> \(tlv.tagInfo), value: \(tlv.value.count.below(33).or(showFullValue) ? "0x\(tlv.value.hexString)" : tlv.value.description))"
            }
        }
        return (newLine ? "\n" : "") + String(repeating: "\t", count: indentation) + desc
    }
    
    private func printableWrapped(name: String, indentation: Int, asn1: ASN1, showFullValue: Bool) -> String {
        asn1.convert { asn1 in
            "\(name) \(asn1.printable(indentation: indentation, newLine: true, showFullValue: showFullValue))"
        }
    }
    
    private func decodeValueIfPossible(raw: Data, indentation: Int, showFullValue: Bool) -> String? {
        Optional { try? ASN1(data: raw) }.map {
            if case .customTlv = $0 {
                nil
            } else {
                ", encoded:" + $0.printable(indentation: indentation, newLine: true, showFullValue: showFullValue)
            }
        }
    }
}
