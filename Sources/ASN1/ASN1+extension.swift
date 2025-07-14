//
//  ASN1+extension.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 14/07/2025.
//

public extension ASN1 {
    var children: [ASN1] {
        switch self {
        case .sequence(let elements), .set(let elements):
            return elements
        default:
            return []
        }
    }
    
    func child(at index: Int) -> ASN1? {
        children[safeIndex: index]
    }
}

public enum ASN1AppendError: Error {
    case notSupported
}

public extension ASN1 {
    mutating func append(_ value: ASN1) throws {
        switch self {
        case .sequence(var elements):
            elements.append(value)
            self = .sequence(elements)
        case .set(var elements):
            elements.append(value)
            self = .set(elements)
        default:
            throw ASN1AppendError.notSupported
        }
    }
}
