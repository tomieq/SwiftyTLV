//
//  BerTlv+TagInfo.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 20/06/2025.
//
import Foundation

public extension BerTlv {
    convenience init(class clas: TagInfo.Class, form: TagInfo.Form, type: TagType, value: Data?) {
        self.init(tag: TagInfo(class: clas, form: form, type: type), value: value)
    }

    convenience init(tag: TagInfo, value: Data?) {
        self.init(tag: tag.data, value: value)
    }
    
    convenience init(tag: TagInfo, values: [BerTlv]) {
        self.init(tag: tag.data, value: values.reduce(Data(), +))
    }
}
