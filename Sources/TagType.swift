//
//  TagType.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 18/06/2025.
//

public enum TagType: Int, CaseIterable {
    case boolean = 0x01            // 1
    case integer = 0x02            // 2
    case bitString = 0x03          // 3
    case octetString = 0x04        // 4
    case null = 0x05               // 5
    case objectIdentifier = 0x06   // 6
    case objectDescriptor = 0x07   // 7
    case external = 0x08           // 8
    case real = 0x09               // 9
    case enumerated = 0x0A         // 10
    case embeddedPdv = 0x0B        // 11
    case utf8String = 0x0C         // 12
    case relativeOid = 0x0D        // 13
    case time = 0x0E               // 14
    case sequence = 0x10           // 16
    case set = 0x11                // 17
    case numericString = 0x12      // 18
    case printableString = 0x13    // 19
    case teletexString = 0x14      // 20
    case videotexString = 0x15     // 21
    case ia5String = 0x16          // 22
    case utcTime = 0x17            // 23
    case generalizedTime = 0x18    // 24
    case graphicString = 0x19      // 25
    case visibleString = 0x1A      // 26
    case generalString = 0x1B      // 27
    case universalString = 0x1C    // 28
    case characterString = 0x1D    // 29
    case bmpString = 0x1E          // 30
    case date = 0x1F               // 31
    case timeOfDay = 0x20          // 32
    case dateTime = 0x21           // 33
    case duration = 0x22           // 34
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
