//
//  TagInfo+preset.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 23/06/2025.
//

public extension TagInfo {
    static let BOOLEAN = TagInfo(class: .universal, form: .primitive, type: .boolean)
    static let INTEGER = TagInfo(class: .universal, form: .primitive, type: .integer)
    static let BITSTRING = TagInfo(class: .universal, form: .primitive, type: .bitString)
    static let OCTET_STRING = TagInfo(class: .universal, form: .primitive, type: .octetString)
    static let DATE = TagInfo(class: .universal, form: .primitive, type: .date)
    static let TIME_OF_DAY = TagInfo(class: .universal, form: .primitive, type: .timeOfDay)
    static let DATE_TIME = TagInfo(class: .universal, form: .primitive, type: .dateTime)
    static let REAL = TagInfo(class: .universal, form: .primitive, type: .real)
    static let ENUMERATED = TagInfo(class: .universal, form: .primitive, type: .enumerated)
    static let OBJECT_IDENTIFIER = TagInfo(class: .universal, form: .primitive, type: .objectIdentifier)
    static let SEQUENCE = TagInfo(class: .universal, form: .constructed, type: .sequence)
    static let IA5_STRING = TagInfo(class: .universal, form: .primitive, type: .ia5String)
    static let VISIBLE_STRING = TagInfo(class: .universal, form: .primitive, type: .visibleString)
    static let NUMERIC_STRING = TagInfo(class: .universal, form: .primitive, type: .numericString)
    static let UTF8_STRING = TagInfo(class: .universal, form: .primitive, type: .utf8String)
    static let NULL = TagInfo(class: .universal, form: .primitive, type: .null)
}
