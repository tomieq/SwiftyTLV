# SwiftyTLV

SwiftyTLV is a Swift library for decoding and encoding binary data into TLV structures.

## SIMPLE-TLV

Simple TLV is defined by ISO 7816-4. 
It contains of 1 byte for tag field, 1 or 3 bytes defining the value length and the sequence of bytes carrying value.

## BER-TLV

BER format is more complex. Tag can be defined as one or more bytes. The length also can be defined as one or more bytes. BER is used by ASN.1 data structures.

## `TlvFrame`

`TlvFrame` is a basic structure that holds TLV data. It has `tag` and `value` attributes.

## `SimpleTlvParser`

`SimpleTlvParser` can be used both for encoding and decoding.

#### Encoding
```swift
let tlv = TlvFrame(tag: Data([0xBA]), value: Data([0x0A, 0x87])
let data = SimpleTlvParser.serialize(tlv)
```
#### Decoding
```swift
let data = Data(hexString: "18022ABC")
let tlvs = try SimpleTlvParser.parse(data: tlv)
```

## `BerTlvParser`

`BerTlvParser` can be used both for encoding and decoding.
