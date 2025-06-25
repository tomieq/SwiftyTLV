//
//  Date+BER.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 24/06/2025.
//
import Foundation

public enum ASN1DateEncodeError: Error {
    case canNotConvertToUtcTime
    case canNotConvertToGenerazedTime
    case canNotConvertToDate
    case canNotConvertToDateTime
}
public enum ASN1DateDecodeError: Error {
    case invalidUtcTimeFormat(String)
    case invalidGeneralizedTimeFormat(String)
    case invalidDateFormat(String)
    case invalidDateTimeFormat(String)
}

// MARK: utcTime
public extension Date {
    var derUtcTime: Data {
        get throws {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyMMddHHmmss'Z'"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            return try formatter
                .string(from: self)
                .data(using: .ascii)
                .orThrow(ASN1DateEncodeError.canNotConvertToUtcTime)
        }
    }
    
    init(derUtcTime data: Data) throws {
        guard let string = String(data: data, encoding: .ascii) else {
            throw ASN1DateDecodeError.invalidUtcTimeFormat(data.hexString)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmmss'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        data.count.on(11) {
            formatter.dateFormat = "yyMMddHHmm'Z'"
        }
        guard let date = formatter.date(from: string) else {
            throw ASN1DateDecodeError.invalidUtcTimeFormat(string)
        }
        self = date
    }
}

// MARK: generalizedTime
public extension Date {
    var derGeneralizedTime: Data {
        get throws {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            return try formatter
                .string(from: self)
                .data(using: .ascii)
                .orThrow(ASN1DateEncodeError.canNotConvertToGenerazedTime)
        }
    }
    init(derGeneralizedTime data: Data) throws {
        guard let full = String(data: data, encoding: .ascii), let string = full.split(".").first else {
            throw ASN1DateDecodeError.invalidGeneralizedTimeFormat(data.hexString)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHH"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        string.count.on(11) {
            formatter.dateFormat = "yyyyMMddHH'Z'"
        }.on(12) {
            formatter.dateFormat = "yyyyMMddHHmm"
        }.on(13) {
            formatter.dateFormat = "yyyyMMddHHmm'Z'"
        }.on(14) {
            formatter.dateFormat = "yyyyMMddHHmmss"
        }.on(15) {
            formatter.dateFormat = "yyyyMMddHHmmss'Z'"
        }
        guard let date = formatter.date(from: string) else {
            throw ASN1DateDecodeError.invalidGeneralizedTimeFormat(full)
        }
        self = date
    }
}

// MARK: date
public extension Date {
    var derDate: Data {
        get throws {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            return try formatter
                .string(from: self)
                .data(using: .ascii)
                .orThrow(ASN1DateEncodeError.canNotConvertToDate)
        }
    }
    
    init(derDate data: Data) throws {
        guard let string = String(data: data, encoding: .ascii) else {
            throw ASN1DateDecodeError.invalidDateFormat(data.hexString)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        string.count.on(11) {
            formatter.dateFormat = "yyyy-MM-dd'Z'"
        }
        guard let date = formatter.date(from: string) else {
            throw ASN1DateDecodeError.invalidDateFormat(string)
        }
        self = date
    }
}

// MARK: dateTme
public extension Date {
    var derDateTime: Data {
        get throws {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            return try formatter
                .string(from: self)
                .data(using: .ascii)
                .orThrow(ASN1DateEncodeError.canNotConvertToDateTime)
        }
    }
    
    init(derDateTime data: Data) throws {
        guard let string = String(data: data, encoding: .ascii) else {
            throw ASN1DateDecodeError.invalidDateTimeFormat(data.hexString)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = formatter.date(from: string) else {
            throw ASN1DateDecodeError.invalidDateTimeFormat(string)
        }
        self = date
    }
}
