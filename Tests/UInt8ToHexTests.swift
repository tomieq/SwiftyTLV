//
//  UInt8ToHexTests.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import XCTest
@testable import SwiftyTLV

class UInt8ToHexTests: XCTestCase {
    func test_convertingOneDigitNumbers() throws {
        var oneDigitNumber: UInt8 = 4
        XCTAssertEqual(oneDigitNumber.hexString, "04")
        oneDigitNumber = UInt8.min
        XCTAssertEqual(oneDigitNumber.hexString, "00")
    }

    func test_convertingTwoDigitNumbers() throws {
        var oneDigitNumber: UInt8 = 16
        XCTAssertEqual(oneDigitNumber.hexString, "10")
        oneDigitNumber = UInt8.max
        XCTAssertEqual(oneDigitNumber.hexString, "FF")
    }
}
