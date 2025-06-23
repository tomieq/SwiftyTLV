//
//  BerTlv+TagInfo.swift
//  SwiftyTLV
//
//  Created by Tomasz Kucharski on 20/06/2025.
//
import Foundation

public extension BerTlv {
    convenience init(class clas: TagInfo.Class, form: TagInfo.Form, type: TagType, value: Data?) {
        self.init(tagInfo: TagInfo(class: clas, form: form, type: type), value: value)
    }

    convenience init(tagInfo: TagInfo, value: Data?) {
        self.init(tag: tagInfo.data, value: value)
    }
    
    convenience init(tagInfo: TagInfo, value: String) {
        self.init(tag: tagInfo.data, value: value)
    }
}
