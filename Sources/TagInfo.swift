//
//  TagInfo.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 18/06/2025.
//
import Foundation

public struct TagInfo {
    public enum Class: UInt8, CaseIterable {
        case universal = 0x00       // 00
        case application = 0x40     // 01
        case contextSpecific = 0x80 // 10
        case `private` = 0xC0       // 11
        
        static let mask: UInt8 = 0xC0
    }
    public enum Form: UInt8, CaseIterable {
        case primitive = 0x00       // 0
        case constructed = 0x20     // 1
        
        static let mask: UInt8 = 0x20
    }
    
    public let `class`: Class
    public let form: Form
    public let number: Int
    public let tagType: TagType?
    
    public init(class klazz: Class, form: Form, number: Int) {
        self.class = klazz
        self.form = form
        self.number = number
        self.tagType = TagType(rawValue: self.number)
    }
    
    public init(class klazz: Class, form: Form, type: TagType) {
        self.class = klazz
        self.form = form
        self.number = type.rawValue
        self.tagType = type
    }
    
    public init?(data: Data) throws {
        if data.isEmpty {
            return nil
        } else {
            self.class = Class.allCases.first { data[safeIndex: 0].or(0) & Class.mask == $0.rawValue }.or(.universal)
            self.form = Form.allCases.first { data[safeIndex: 0].or(0) & Form.mask == $0.rawValue }.or(.primitive)
            var tag = data
            
            // remove metadata bits
            tag[0] = tag[0] & 0x1F
            
            // if long tag
            if tag[0] == 0x1F {
                tag.removeFirst()
                var tagNumber = 0
                for byte in tag {
                    tagNumber = (tagNumber << 7) | Int(byte & 0x7F)
                    if byte & 0x80 == 0 { break }
                }
                self.number = tagNumber
            } else {
                self.number = try tag.uInt8.int
            }
        }
        self.tagType = TagType(rawValue: self.number)
    }
    
    public var data: Data {
        var result = Data()
        let base = self.class.rawValue | self.form.rawValue
        
        if number < 31 {
            // Short-form tag
            result.append(base | UInt8(number))
        } else {
            // Long-form tag
            result.append(base | 0x1F) // 0x1F = 5 bits all set
            var tagNumber = number
            var bytes: [UInt8] = []
            
            repeat {
                bytes.insert(UInt8(tagNumber & 0x7F), at: 0)
                tagNumber >>= 7
            } while tagNumber > 0
            
            // Set continuation bits
            for i in 0..<bytes.count - 1 {
                bytes[i] |= 0x80
            }
            result.append(contentsOf: bytes)
        }
        return result
    }
}

extension TagInfo: Equatable {}
extension TagInfo.Class: Equatable {}
extension TagInfo.Form: Equatable {}

extension TagInfo: CustomStringConvertible {
    private var readableType: String {
        if let tagType, (self.form == .primitive).or(self.class == .universal) {
            ", Type: \(tagType)"
        } else {
            ""
        }
    }
    public var description: String {
        "Class: \(self.class), Form: \(self.form), Number: \(self.number) [0x\(self.number.hex)]\(readableType)"
    }
}

extension TagInfo.Class: CustomStringConvertible {
    public var description: String {
        switch self {
        case .universal:
            "UNIVERSAL"
        case .application:
            "APPLICATION"
        case .contextSpecific:
            "Context-specific"
        case .private:
            "PRIVATE"
        }
    }
}

extension TagInfo.Form: CustomStringConvertible {
    public var description: String {
        switch self {
        case .primitive:
            "Primitive"
        case .constructed:
            "Constructed"
        }
    }
    
}

extension TagInfo {
    func with(class c: TagInfo.Class? = nil, form: TagInfo.Form? = nil) -> TagInfo {
        TagInfo(class: c.or(self.class), form: form.or(self.form), number: self.number)
    }
}
