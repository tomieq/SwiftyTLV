//
//  Data+extension.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation

extension Data {
    static func random(length: Int) -> Data {
        return Data((0..<length).map { _ in UInt8.random(in: UInt8.min...UInt8.max) })
    }
}
