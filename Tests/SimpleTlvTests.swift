//
//  SimpleTlvTests.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import XCTest
@testable import SwiftyTLV

class SimpleTlvTests: XCTestCase {
    func test_parseOneTLV() throws {
        let tlv = Data(hexString: "18022ABC")
        let parsed = try SimpleTlv.from(data: tlv)
        XCTAssertEqual(parsed.tag, 0x18)
        XCTAssertEqual(parsed.value.hexString, "2ABC")
    }

    func test_parseMultipleTLV() throws {
        let tlvPayload1 = Data.random(length: 0xE0)
        let tlvPayload2 = Data.random(length: 0x89AB)
        var data = Data()
        data.append(Data(hexString: "CAE0"))
        data.append(tlvPayload1)
        data.append(Data(hexString: "6EFF89AB"))
        data.append(tlvPayload2)
        let parsed = try SimpleTlv.list(data: data)
        XCTAssertEqual(parsed.first{ $0.tag == 0xCA }?.value, tlvPayload1)
        XCTAssertEqual(parsed.first{ $0.tag == 0x6E }?.value, tlvPayload2)
    }

    func test_calculatingSize() throws {
        func getSize(_ hexString: String) throws -> Int {
            var data = Data(hexString: hexString)
            return try SimpleTlv.getLenght(data: &data)
        }

        XCTAssertEqual(try getSize("0"), 0)
        XCTAssertEqual(try getSize("00"), 0)
        XCTAssertEqual(try getSize("05"), 5)
        XCTAssertEqual(try getSize("FF0005"), 5)

        XCTAssertEqual(try getSize("7F"), 0x7F)
        XCTAssertEqual(try getSize("FF0081"), 0x81)
        XCTAssertEqual(try getSize("FF2081"), 0x2081)
        XCTAssertEqual(try getSize("FFFFFF"), 0xFFFF)
    }

    func test_makingPayloadSize() throws {
        func makeData(_ size: Int) throws -> String {
            SimpleTlv(tag: 0x07, value: Data(repeating: 0, count: size)).data[safeRange: 1...3].hexString
        }

        XCTAssertEqual(try makeData(0), "00")
        XCTAssertEqual(try makeData(1), "0100")
        XCTAssertEqual(try makeData(0x7F), "7F0000")
        XCTAssertEqual(try makeData(0xFF), "FF00FF")
        XCTAssertEqual(try makeData(0x0100), "FF0100")
        XCTAssertEqual(try makeData(0xFFFF), "FFFFFF")
    }

    func test_serializeOneByteTLV() {
        let tlv = SimpleTlv(tag: 0xCC, value: "EB")
        XCTAssertEqual(tlv.data.hexString, "CC01EB")
    }

    func test_serializeTwoByteTLV() {
        let tlv = SimpleTlv(tag: 0xFF, value: "EBAC")
        XCTAssertEqual(tlv.data.hexString, "FF02EBAC")
    }

    func test_serialize127ByteTLV() {
        let valueLenght = 127
        let payload = Data.random(length: valueLenght)
        let tlv = SimpleTlv(tag: 0xBA, value: payload)
        XCTAssertEqual(tlv.data.hexString, "BA7F\(payload.hexString)")
    }

    func test_serializeLongByteTLV() {
        let valueLenght = 0x1AA
        let payload = Data.random(length: valueLenght)
        let tlv = SimpleTlv(tag: 0xBA, value: payload)
        XCTAssertEqual(tlv.data.hexString, "BAFF01AA\(payload.hexString)")
    }
}
