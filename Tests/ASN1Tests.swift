//
//  ASN1Tests.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 24/06/2025.
//
import Foundation
import Testing
import SwiftyTLV

struct ASN1Tests {
    @Test
    func integer() throws {
        let asn = ASN1.integer(0x12)
        let data = Data(hexString: "020112")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func booleanTrue() throws {
        let asn = ASN1.boolean(true)
        let data = Data(hexString: "0101FF")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func booleanFalse() throws {
        let asn = ASN1.boolean(false)
        let data = Data(hexString: "010100")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func bitString() throws {
        let asn = ASN1.bitString(Data([0x12]))
        let data = Data(hexString: "030112")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func octetString() throws {
        let asn = ASN1.octetString(Data([0x12]))
        let data = Data(hexString: "040112")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func null() throws {
        let asn = ASN1.null
        let data = Data(hexString: "0500")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func objectIdentifier() throws {
        let asn = ASN1.objectIdentifier("1.0.8571.2.1")
        let data = Data(hexString: "060528C27B0201")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func objectDescriptor() throws {
        let asn = ASN1.objectDescriptor("FTAM PCI")
        let data = Data(hexString: "07084654414D20504349")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func utf8String() throws {
        let asn = ASN1.utf8String("abcdlmyz")
        let data = Data(hexString: "0C08616263646C6D797A")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func relativeObjectIdentifier() throws {
        let asn = ASN1.relativeOid("1.0")
        let data = Data(hexString: "0D0128")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func time() throws {
        try [
            "1985-W15-5": "0E0A313938352D5731352D35",
            "-0002-04-12": "0E0B2D303030322D30342D3132",
            "15:27:35.5": "0E0A31353A32373A33352E35",
            "15:27:46+01:00": "0E0E31353A32373A34362B30313A3030"
        ].forEach { (time, binary) in
            let asn = ASN1.time(time)
            let data = Data(hexString: binary)
            let tlv = try BerTlv.from(data: data)
            let asnFromData = try ASN1(tlv: tlv)
            #expect(asnFromData == asn, "time: \(time) does not match binary: \(binary)")
            let dataFromAsn = try asn.data
            #expect(dataFromAsn == data, "asn: \(dataFromAsn.hexString) does not match \(data.hexString)")
        }
    }
    @Test
    func sequence() throws {
        let asn = ASN1.sequence([
            .printableString("be"),
            .printableString("pai")
        ])
        print(try asn.data.hexString)
        let data = Data(hexString: "3009130262651303706169")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func numericString() throws {
        let asn = ASN1.numericString("1000000")
        let data = Data(hexString: "120731303030303030")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func printableString() throws {
        let asn = ASN1.printableString("Parker")
        let data = Data(hexString: "13065061726B6572")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func ia5String() throws {
        let asn = ASN1.ia5String("ABCD EFGH")
        let data = Data(hexString: "1609414243442045464748")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func utcTime() throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmmss'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: "960415203000Z")!

        let asn = ASN1.utcTime(date)
        let data = Data(hexString: "170D3936303431353230333030305A")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func generalizedTime() throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: "19960415203000")!

        let asn = ASN1.generalizedTime(date)
        let data = Data(hexString: "180E3139393630343135323033303030")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func visibleString() throws {
        let asn = ASN1.visibleString("John")
        let data = Data(hexString: "1A044A6F686E")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func date() throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: "20121221000000")!

        let asn = ASN1.date(date)
        print(try asn.data.hexString)
        let data = Data(hexString: "1F1F0A323031322D31322D3231")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func timeOfDay() throws {
        let asn = ASN1.timeOfDay(hour: 6, minute: 30, second: 0)
        let data = Data(hexString: "1F200830363A33303A3030")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    @Test
    func dateTime() throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: "19511014153012")!

        let asn = ASN1.dateTime(date)
        let data = Data(hexString: "1F2113313935312D31302D31345431353A33303A3132")
        let tlv = try BerTlv.from(data: data)
        #expect(try ASN1(tlv: tlv) == asn)
        #expect(try asn.data == data)
    }
    
