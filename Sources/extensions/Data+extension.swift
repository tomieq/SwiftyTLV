//
//  Data+extension.swift
//
//
//  Created by Tomasz Kucharski on 06/08/2022.
//

import Foundation
import SwiftExtensions

public enum DataError: Error {
    case outOfIndex
}



extension Data {
    public func subArray(offset: Int, length: Int) throws -> Data {
        var result: Data = Data()
        let rightBoudary = offset + length - 1
        for index in offset...rightBoudary {
            guard let _ = self[safeIndex: index] else {
                print("Cannot get subArray(\(offset), \(length)) as right boundary \(rightBoudary) exceedes data size \(self.count)")
                throw DataError.outOfIndex
            }
            result.append(self[index])
        }
        return result
    }
}
