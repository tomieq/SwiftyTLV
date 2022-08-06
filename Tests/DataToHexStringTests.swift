//
//  DataToHexStringTests.swift
//  
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation
import XCTest
@testable import SwiftyTLV

class DataToHexStringTests: XCTestCase {
    func test_data2hexString() {
        let bytes: [UInt8] = [0x89, 0xAC, 0x99]
        XCTAssertEqual(Data(bytes: bytes).hexString, "89AC99")
    }
}
