//
//  TagInfo+preset.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 23/06/2025.
//

// Shorthands for primitive types
public extension TagInfo {
    static let BOOLEAN = TagInfo(class: .universal, form: .primitive, type: .boolean)
    static let INTEGER = TagInfo(class: .universal, form: .primitive, type: .integer)
    static let BITSTRING = TagInfo(class: .universal, form: .primitive, type: .bitString)
    static let OCTET_STRING = TagInfo(class: .universal, form: .primitive, type: .octetString)
    static let DATE = TagInfo(class: .universal, form: .primitive, type: .date)
    static let TIME = TagInfo(class: .universal, form: .primitive, type: .time)
    static let TIME_OF_DAY = TagInfo(class: .universal, form: .primitive, type: .timeOfDay)
    static let DATE_TIME = TagInfo(class: .universal, form: .primitive, type: .dateTime)
    static let UTC_TIME = TagInfo(class: .universal, form: .primitive, type: .utcTime)
    static let GENERALIZED_TIME = TagInfo(class: .universal, form: .primitive, type: .generalizedTime)
    static let REAL = TagInfo(class: .universal, form: .primitive, type: .real)
    static let ENUMERATED = TagInfo(class: .universal, form: .primitive, type: .enumerated)
    static let OBJECT_IDENTIFIER = TagInfo(class: .universal, form: .primitive, type: .objectIdentifier)
    static let RELATIVE_OBJECT_IDENTIFIER = TagInfo(class: .universal, form: .primitive, type: .relativeOid)
    static let OBJECT_DESCRIPTOR = TagInfo(class: .universal, form: .primitive, type: .objectDescriptor)
    static let SEQUENCE = TagInfo(class: .universal, form: .constructed, type: .sequence)
    static let SET = TagInfo(class: .universal, form: .constructed, type: .set)
    static let IA5_STRING = TagInfo(class: .universal, form: .primitive, type: .ia5String)
    static let VISIBLE_STRING = TagInfo(class: .universal, form: .primitive, type: .visibleString)
    static let GENERAL_STRING = TagInfo(class: .universal, form: .primitive, type: .generalString)
    static let PRINTABLE_STRING = TagInfo(class: .universal, form: .primitive, type: .printableString)
    static let NUMERIC_STRING = TagInfo(class: .universal, form: .primitive, type: .numericString)
    static let UTF8_STRING = TagInfo(class: .universal, form: .primitive, type: .utf8String)
    static let NULL = TagInfo(class: .universal, form: .primitive, type: .null)
}
