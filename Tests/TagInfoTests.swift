//
//  TagInfoTests.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 18/06/2025.
//

import SwiftyTLV
import SwiftExtensions
import Foundation
import Testing


struct TagInfoTests {
    @Test
    func initApplicationShortTag() throws {
        let data = Data(hexString: "02")
        let tag = try TagInfo(data: data)
        #expect(tag?.class == .universal)
        #expect(tag?.form == .primitive)
        #expect(tag?.number == 2)
    }

    @Test
    func initApplicationTag() throws {
        let data = Data(hexString: "5F811A")
        let tag = try TagInfo(data: data)
        #expect(tag?.class == .application)
        #expect(tag?.form == .primitive)
        #expect(tag?.number == 154)
    }
}
