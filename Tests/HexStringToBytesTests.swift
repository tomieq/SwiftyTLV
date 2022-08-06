//
//  HexStringToBytesTests.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import XCTest
@testable import SwiftyTLV

class HexStringToBytesTests: XCTestCase {
    func test_bytesFromDecimalHexString() throws {
        let bytes = "0123456789".unicodeScalars.compactMap{ try? $0.hex2byte() }
        XCTAssertEqual(bytes, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
    }

    func test_bytesFromUppercasedHexString() throws {
        let bytes = "ABCDEF".unicodeScalars.compactMap{ try? $0.hex2byte() }
        XCTAssertEqual(bytes, [10, 11, 12, 13, 14, 15])
    }

    func test_bytesFromlowercasedHexString() throws {
        let bytes = "abcdef".unicodeScalars.compactMap{ try? $0.hex2byte() }
        XCTAssertEqual(bytes, [10, 11, 12, 13, 14, 15])
    }

    func test_byteFromInvalidCharacter() throws {
        XCTAssertThrowsError(try "t".unicodeScalars.map{ try $0.hex2byte() })
    }
}
