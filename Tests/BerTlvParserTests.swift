//
//  TLVParserTests.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import XCTest
@testable import SwiftyTLV

class BerTlvParserTests: XCTestCase {
    func test_parseOneTLV() throws {
        let tlv = Data(hexString: "18022ABC")
        let parsed = try BerTlvParser.parse(data: tlv)
        XCTAssertEqual(parsed.first{ $0.tag == 0x18 }?.value.hexString, "2ABC")
    }

    func test_parseMultipleTLV() throws {
        var data = Data(hexString: "18022ABC")
        data.append(Data(hexString: "9002EBCA"))
        let parsed = try BerTlvParser.parse(data: data)
        XCTAssertEqual(parsed.first{ $0.tag == 0x18 }?.value.hexString, "2ABC")
        XCTAssertEqual(parsed.first{ $0.tag == 0x90 }?.value.hexString, "EBCA")
    }

    func test_parseMultipleTLVGluedWithZeroes() throws {
        var data = Data(hexString: "18022ABC")
        data.append(Data(repeating: 0, count: 11))
        data.append(Data(hexString: "9002EBCA"))
        let parsed = try BerTlvParser.parse(data: data)
        XCTAssertEqual(parsed.first{ $0.tag == 0x18 }?.value.hexString, "2ABC")
        XCTAssertEqual(parsed.first{ $0.tag == 0x90 }?.value.hexString, "EBCA")
    }

    func test_parseMultipleLongTLV() throws {
        let tlvPayload1 = Data.random(length: 0x78)
        let tlvPayload2 = Data.random(length: 0x1EA60)
        var data = Data()
        data.append(Data(hexString: "3378"))
        data.append(tlvPayload1)
        data.append(Data(hexString: "998301EA60"))
        data.append(tlvPayload2)
        let parsed = try BerTlvParser.parse(data: data)
        XCTAssertEqual(parsed.first{ $0.tag == 0x33 }?.value, tlvPayload1)
        XCTAssertEqual(parsed.first{ $0.tag == 0x99 }?.value, tlvPayload2)
    }

    func test_lengthOffset() throws {
        XCTAssertEqual(try BerTlvParser.getLengthOffset(tlvData: Data(hexString: "72"), offset: 0), 1)
        XCTAssertEqual(try BerTlvParser.getLengthOffset(tlvData: Data(hexString: "80"), offset: 0), 1)
        XCTAssertEqual(try BerTlvParser.getLengthOffset(tlvData: Data(hexString: "8190"), offset: 0), 2)
        XCTAssertEqual(try BerTlvParser.getLengthOffset(tlvData: Data(hexString: "823432"), offset: 0), 3)
        XCTAssertEqual(try BerTlvParser.getLengthOffset(tlvData: Data(hexString: "83343278"), offset: 0), 4)
        XCTAssertEqual(try BerTlvParser.getLengthOffset(tlvData: Data(hexString: "8412121212"), offset: 0), 5)
    }

    func test_calculatingSize() throws {
        func getSize(_ hexString: String) throws -> Int {
            try BerTlvParser.getValueLength(data: Data(hexString: hexString), offset: 0)
        }

        XCTAssertEqual(try getSize("0"), 0)
        XCTAssertEqual(try getSize("00"), 0)
        XCTAssertEqual(try getSize("05"), 5)
        XCTAssertEqual(try getSize("8105"), 5)
        XCTAssertEqual(try getSize("820005"), 5)
        XCTAssertEqual(try getSize("83000005"), 5)
        XCTAssertEqual(try getSize("8400000005"), 5)

        XCTAssertEqual(try getSize("7F"), 0x7F)
        XCTAssertEqual(try getSize("8181"), 0x81)
        XCTAssertEqual(try getSize("82FFFF"), 0xFFFF)
        XCTAssertEqual(try getSize("83010000"), 0x010000)
        XCTAssertEqual(try getSize("83FFFFFF"), 0xFFFFFF)
        #if __LP64__
        XCTAssertEqual(try getSize("8401000000"), 0x01000000)
        XCTAssertEqual(try getSize("84FFFFFFFF"), 0xFFFFFFFF)
        #endif
    }

    func test_makingPayloadSize() throws {
        func makeData(_ size: Int) throws -> String {
            BerTlvParser.makeValueLength(value: Data(repeating: 0, count: size)).hexString
        }

        XCTAssertEqual(try makeData(0), "00")
        XCTAssertEqual(try makeData(1), "01")
        XCTAssertEqual(try makeData(0x7F), "7F")
        XCTAssertEqual(try makeData(0xFF), "81FF")
        XCTAssertEqual(try makeData(0x0100), "820100")
        XCTAssertEqual(try makeData(0xFFFF), "82FFFF")
        XCTAssertEqual(try makeData(0x010000), "83010000")
        XCTAssertEqual(try makeData(0xFFFFFF), "83FFFFFF")
        #if __LP64__
        XCTAssertEqual(try makeData(0xFFFFFFFF), "84FFFFFFFF")
        XCTAssertEqual(try makeData(0x01000000), "8401000000")
        #endif
    }

    func test_serializeOneByteTLV() {
        let tlv = TlvFrame(tag: 0xCC, hexString: "EB")
        XCTAssertEqual(BerTlvParser.serialize(tlv).hexString, "CC01EB")
    }

    func test_serializeTwoByteTLV() {
        let tlv = TlvFrame(tag: 0xFF, hexString: "EBAC")
        XCTAssertEqual(BerTlvParser.serialize(tlv).hexString, "FF02EBAC")
    }

    func test_serialize127ByteTLV() {
        let valueLenght = 127
        let payload = Data.random(length: valueLenght)
        let tlv = TlvFrame(tag: 0xBA, value: payload)
        XCTAssertEqual(BerTlvParser.serialize(tlv).hexString, "BA\(valueLenght.byte.hexString)\(payload.hexString)")
    }

    func test_serialize128ByteTLV() {
        let valueLenght = 128
        let payload = Data.random(length: valueLenght)
        let tlv = TlvFrame(tag: 0xBA, value: payload)
        XCTAssertEqual(BerTlvParser.serialize(tlv).hexString, "BA81\(valueLenght.byte.hexString)\(payload.hexString)")
    }

    func test_serialize65535ByteTLV() {
        let valueLenght = 65535
        let payload = Data.random(length: valueLenght)
        let tlv = TlvFrame(tag: 0xCA, value: payload)
        XCTAssertEqual(BerTlvParser.serialize(tlv).hexString, "CA82\(valueLenght.hexString)\(payload.hexString)")
    }
}
