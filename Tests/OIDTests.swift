//
//  OIDTests.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 20/06/2025.
//

import SwiftyTLV
import SwiftExtensions
import Foundation
import Testing


struct OIDTests {
    @Test
    func encode() throws {
        let txt = "1.2.62329.4"
        #expect(OID.encode(txt)?.hexString == "2A83E67904")
    }

    @Test
    func decode() throws {
        let data = Data(hexString: "2A83E67904")
        #expect(OID.decode(data) == "1.2.62329.4")
    }
}
