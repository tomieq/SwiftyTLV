//
//  DataToIntTests.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import XCTest
@testable import SwiftyTLV

class DataToIntTests: XCTestCase {
    func test_smallNumberDataToInt() throws {
        var data = Data()
        data.append(0xE)
        XCTAssertEqual(data.int, 14)
    }

    func test_mediumNumberDataToInt() throws {
        let data = Data(hexString: "FE")
        XCTAssertEqual(data.int, 254)
    }

    func test_bigNumberDataToInt() throws {
        let data = Data(hexString: "0A07")
        XCTAssertEqual(data.int, 2567)
    }

    func test_hugeNumberDataToInt() throws {
        let data = Data(hexString: "01000000")
        XCTAssertEqual(data.int, 16777216)
    }
}
