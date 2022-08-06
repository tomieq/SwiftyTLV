//
//  Int2HexTests.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import XCTest
@testable import SwiftyTLV

class IntToHexTests: XCTestCase {
    func test_convertingSmallNumbers() throws {
        XCTAssertEqual(1.hexString, "0001")
        XCTAssertEqual(5.hexString, "0005")
        XCTAssertEqual(10.hexString, "000A")
        XCTAssertEqual(12.hexString, "000C")
        XCTAssertEqual(15.hexString, "000F")
    }

    func test_convertingMediumNumbers() throws {
        XCTAssertEqual(16.hexString, "0010")
        XCTAssertEqual(123.hexString, "007B")
        XCTAssertEqual(200.hexString, "00C8")
        XCTAssertEqual(255.hexString, "00FF")
    }

    func test_convertingBigNumbers() throws {
        XCTAssertEqual(800.hexString, "0320")
        XCTAssertEqual(3190.hexString, "0C76")
        XCTAssertEqual(8192.hexString, "2000")
    }
}
