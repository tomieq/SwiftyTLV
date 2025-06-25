//
//  BerTlvTests.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import XCTest
@testable import SwiftyTLV

class BerTlvTests: XCTestCase {
    func test_parseOneTLV() throws {
        let tlv = Data(hexString: "18022ABC")
        let parsed = try BerTlv.from(data: tlv)
        XCTAssertEqual(try parsed.tag.uInt8, 0x18)
        XCTAssertEqual(parsed.value.hexString, "2ABC")
    }
    
    func test_parseOneTLVFixedTagLenght1() throws {
        let tlv = Data(hexString: "18022ABC")
        let parsed = try BerTlv.from(data: tlv, tagLength: .fixed(1))
        XCTAssertEqual(try parsed.tag.uInt8, 0x18)
        XCTAssertEqual(parsed.value.hexString, "2ABC")
    }
    
    func test_parseOneTLVFixedTagLenght2() throws {
        let tlv = Data(hexString: "18A0022ABC")
        let parsed = try BerTlv.from(data: tlv, tagLength: .fixed(2))
        XCTAssertEqual(try parsed.tag.uInt16, 0x18A0)
        XCTAssertEqual(parsed.value.hexString, "2ABC")
    }

    func test_parseTLVWithLongTag() throws {
        let tlv = Data(hexString: "BF4F8101AA")
        let parsed = try BerTlv.from(data: tlv)
        print(parsed)
        XCTAssertEqual(parsed.tag.hexString, "BF4F")
        XCTAssertEqual(parsed.value.hexString, "AA")
    }
    
    func test_parseTLVWithLongTags() throws {
        let data = Data(hexString: "5C81022ABCBF4F8101A0")
        let parsed = try BerTlv.list(data: data)
        print(parsed)
        XCTAssertEqual(parsed.first{ $0.tag.hexString == "5C" }?.value.hexString, "2ABC")
        XCTAssertEqual(parsed.first{ $0.tag.hexString == "BF4F" }?.value.hexString, "A0")
    }

    func test_parseMultipleTLV() throws {
        var data = Data(hexString: "18022ABC")
        data.append(Data(hexString: "9002EBCA"))
        let parsed = try BerTlv.list(data: data)
        XCTAssertEqual(try parsed.first{ try $0.tag.uInt8 == 0x18 }?.value.hexString, "2ABC")
        XCTAssertEqual(try parsed.first{ try $0.tag.uInt8 == 0x90 }?.value.hexString, "EBCA")
    }

    func test_parseMultipleLongTLV() throws {
        let tlvPayload1 = Data.random(length: 0x78)
        let tlvPayload2 = Data.random(length: 0x1EA60)
        var data = Data()
        data.append(Data(hexString: "3378"))
        data.append(tlvPayload1)
        data.append(Data(hexString: "998301EA60"))
        data.append(tlvPayload2)
        let parsed = try BerTlv.list(data: data)
        XCTAssertEqual(try parsed.first{ try $0.tag.uInt8 == 0x33 }?.value, tlvPayload1)
        XCTAssertEqual(try parsed.first{ try $0.tag.uInt8 == 0x99 }?.value, tlvPayload2)
    }

    func test_calculatingSize() throws {
        func getSize(_ hexString: String) throws -> Int {
            var data = Data(hexString: hexString)
            return try BerTlv.getLength(data: &data)
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
        XCTAssertEqual(try getSize("8401000000"), 0x01000000)
        XCTAssertEqual(try getSize("84FFFFFFFF"), 0xFFFFFFFF)
    }

    func test_makingPayloadSize() throws {
        func makeData(_ size: Int) throws -> String {
            BerTlv(tag: "09", value: Data(repeating: 0, count: size)).data[safeRange: 1...5].hexString
        }

        XCTAssertEqual(try makeData(0), "00")
        XCTAssertEqual(try makeData(1), "0100")
        XCTAssertEqual(try makeData(0x7F), "7F00000000")
        XCTAssertEqual(try makeData(0xFF), "81FF000000")
        XCTAssertEqual(try makeData(0x0100), "8201000000")
        XCTAssertEqual(try makeData(0xFFFF), "82FFFF0000")
        XCTAssertEqual(try makeData(0x010000), "8301000000")
        XCTAssertEqual(try makeData(0xFFFFFF), "83FFFFFF00")
        XCTAssertEqual(try makeData(0xFFFFFFFF), "84FFFFFFFF")
        XCTAssertEqual(try makeData(0x01000000), "8401000000")
    }

    func test_serializeOneByteTLV() {
        let tlv = BerTlv(tag: "CC", value: "EB")
        XCTAssertEqual(tlv.data.hexString, "CC01EB")
    }

    func test_serializeTwoByteTLV() {
        let tlv = BerTlv(tag: "FF", value: "EBAC")
        XCTAssertEqual(tlv.data.hexString, "FF02EBAC")
    }

    func test_serialize127ByteTLV() {
        let valueLenght = 127
        let payload = Data.random(length: valueLenght)
        let tlv = BerTlv(tag: "BA", value: payload)
        XCTAssertEqual(tlv.data.hexString, "BA7F\(payload.hexString)")
    }

    func test_serialize128ByteTLV() {
        let valueLenght = 128
        let payload = Data.random(length: valueLenght)
        let tlv = BerTlv(tag: "BA", value: payload)
        XCTAssertEqual(tlv.data.hexString, "BA8180\(payload.hexString)")
    }

    func test_serialize65535ByteTLV() {
        let valueLenght = 65535
        let payload = Data.random(length: valueLenght)
        let tlv = BerTlv(tag: "CA", value: payload)
        XCTAssertEqual(tlv.data.hexString, "CA82FFFF\(payload.hexString)")
    }
    
    func test_initWithTagInfo() throws {
        let tlv = BerTlv(tag: .BOOLEAN, value: Data(hexString: "01"))
        XCTAssertEqual(tlv.tagInfo.form, .primitive)
        XCTAssertEqual(tlv.tagInfo.class, .universal)
        XCTAssertEqual(tlv.tagInfo.tagType, .boolean)
        XCTAssertEqual(tlv.value.hexString, "01")
    }
    
    
}
