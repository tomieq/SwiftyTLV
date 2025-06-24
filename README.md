# SwiftyTLV

SwiftyTLV is a Swift library for decoding and encoding binary data into TLV structures.

## SIMPLE-TLV

Simple TLV is defined by ISO 7816-4. 
It contains of 1 byte for tag field, 1 or 3 bytes defining the value length and the sequence of bytes carrying value.

## BER-TLV

BER format is more complex. Tag can be defined as one or more bytes. The length also can be defined as one or more bytes. BER is used by ASN.1 data structures.

## `SimpleTlv`

`SimpleTlv` is a basic structure that holds TLV data. It has `tag` and `value` attributes.

`SimpleTlv` can be used both for encoding and decoding.

#### Encoding
```swift
let tlv = SimpleTlv(tag: Data([0xBA]), value: Data([0x0A, 0x87])
let data = tlv.data
```
#### Decoding
```swift
let data = Data(hexString: "18022ABC")
let tlv = try SimpleTlv.from(data: tlv)
let tlvs = try SimpleTlv.list(data: tlv)
```

## `BerTlv`

`BerTlv` can be used both for encoding and decoding. 

#### Encoding
```swift
let tlv = BerTlv(tag: "BF89", value: Data([0x0A, 0x87])
let data = tlv.data
```

#### Encoding with `TagInfo`
```swift
let tlv = BerTlv(tag: TagInfo(class: .contextSpecific, form: .constructed, type: .bitString), value: Data([0x34])
let tlv = BerTlv(tag: .CONTEXT_SPECIFIC(.bitString), value: Data([0x34]))
let tlv = BerTlv(tag: .BOOLEAN, value: Data([0x01])
```

#### Decoding
When decoding, you can either let the engine obtain the number of tags according to BER specs or set it to fixed width. By default is `auto`. 
```swift
let data = Data(hexString: "18022ABC")
let tlv = try BerTlv.from(data: data)
let tlv = try BerTlv.from(data: data, tagLength: .fixed(1))
let tlvs = try BerTlv.list(data: data)
let tlvs = try BerTlv.list(data: data, tagLength: .fixed(1))
```

## OID
Library has in-build `OID` encoder and decoder.

You can make TLV payload with:
```swift
let tlv = BerTlv(tag: "06", value: OID.encode("1.2.62329.4"))
```

When you created `BerTlv` from binary data, you can obtain it's OID with code:
```swift
let tlv = try BerTlv.from(data: data)
let oid = tlv.oid
```
