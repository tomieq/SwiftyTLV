//
//  TagType.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 18/06/2025.
//

public enum TagType: Int, CaseIterable {
    case boolean = 1
    case integer = 2
    case bitString = 3
    case octetString = 4
    case null = 5
    case objectIdentifier = 6
    case objectDescriptor = 7
    case external = 8
    case real = 9
    case enumerated = 10
    case embeddedPdv = 11
    case utf8String = 12
    case relativeOid = 13
    case time = 14
    case sequence = 16
    case set = 17
    case numericString = 18
    case printableString = 19
    case teletexString = 20
    case videotexString = 21
    case ia5String = 22
    case utcTime = 23
    case generalizedTime = 24
    case graphicString = 25
    case visibleString = 26
    case generalString = 27
    case universalString = 28
    case characterString = 29
    case bmpString = 30
    case date = 31
    case timeOfDay = 32
    case dateTime = 33
    case duration = 34
}

extension TagType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .boolean:
            "BOOLEAN"
        case .integer:
            "INTEGER"
        case .bitString:
            "BIT-STRING"
        case .octetString:
            "OCTET-STRING"
        case .null:
            "NULL"
        case .objectIdentifier:
            "OBJECT-IDENTIFIER"
        case .objectDescriptor:
            "ObjectDescriptor"
        case .external:
            "EXTERNAL"
        case .real:
            "REAL"
        case .enumerated:
            "ENUMERATED"
        case .embeddedPdv:
            "EMBEDDED-PDV"
        case .utf8String:
            "UTF8String"
        case .relativeOid:
            "RELATIVE-OID"
        case .time:
            "TIME"
        case .sequence:
            "SEQUENCE"
        case .set:
            "SET"
        case .numericString:
            "NumericString"
        case .printableString:
            "PrintableString"
        case .teletexString:
            "TeletexString"
        case .videotexString:
            "VideotextString"
        case .ia5String:
            "IA5String"
        case .utcTime:
            "UTCTIME"
        case .generalizedTime:
            "GeneralizedTime"
        case .graphicString:
            "GraphicString"
        case .visibleString:
            "VisibleString"
        case .generalString:
            "GeneralString"
        case .universalString:
            "UniversalString"
        case .characterString:
            "CHARACTER-STRING"
        case .bmpString:
            "BMPString"
        case .date:
            "DATE"
        case .timeOfDay:
            "TIME-OF-DAY"
        case .dateTime:
            "DATE-TIME"
        case .duration:
            "DURATION"
        }
    }
}
