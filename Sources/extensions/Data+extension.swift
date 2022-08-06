//
//  Data+extension.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation

public enum DataError: Error {
    case outOfIndex
}

extension Data {
    public init(hexString: String) {
        let scalars = hexString.unicodeScalars
        var bytes = Array<UInt8>(repeating: 0, count: (scalars.count + 1) >> 1)
        for (index, scalar) in scalars.enumerated() {
            guard var byte = try? scalar.hex2byte() else {
                print("Error while initializing Data from hexString \(hexString)")
                self = Data()
                return
            }
            if index & 1 == 0 {
                byte <<= 4
            }
            bytes[index >> 1] |= byte
        }
        self = Data(bytes: bytes)
    }

    public var hexString: String {
        self.map{ String(format: "%02hhx", $0).uppercased() }.joined()
    }
}

extension Data {
    public var int: Int {
        let bytes = self.bytes
        switch count {
        case 1:
            return Int(bytes[0])
        case 2:
            return Int(bytes[0]) << 8 + Int(bytes[1])
        case 3:
            return Int(bytes[0]) << 16 + Int(bytes[1]) << 8 + Int(bytes[2])
        case 4:
            let high = Int(bytes[0]) << 24 + Int(bytes[1]) << 16
            let low = Int(bytes[2]) << 8 + Int(bytes[3])
            return high + low
        default:
            return 0
        }
    }

    var bytes: [UInt8] {
        [UInt8](self)
    }
}

extension Data {
    public func subArray(offset: Int, length: Int) throws -> Data {
        var result: Data = Data()
        let rightBoudary = offset + length - 1
        for index in offset...rightBoudary {
            guard let _ = self[safeIndex: index] else {
                print("Cannot get subArray(\(offset), \(length)) as right boundary \(rightBoudary) exceedes data size \(self.count)")
                throw DataError.outOfIndex
            }
            result.append(self[index])
        }
        return result
    }

    public subscript(safeIndex index: Int) -> Element? {
        get {
            guard index >= 0, index < self.count else { return nil }
            return self[index]
        }

        set(newValue) {
            guard let value = newValue, index >= 0, index < self.count else { return }
            self[index] = value
        }
    }
}
