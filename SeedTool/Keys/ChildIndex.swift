//
//  ChildIndex.swift
//  Gordian Seed Tool
//
//  Created by Wolf McNally on 1/22/21.
//

import Foundation
import BCFoundation

extension ChildIndex {
//struct ChildIndex: ExpressibleByIntegerLiteral, Equatable {
//    let value: UInt32
//    init(_ value: UInt32) throws {
//        guard(value & 0x80000000 == 0) else {
//            throw GeneralError("Invalid child index.")
//        }
//        self.value = value
//    }
//
//    init(integerLiteral: UInt32) {
//        try! self.init(integerLiteral)
//    }
//
//    static func ==(lhs: ChildIndex, rhs: ChildIndex) -> Bool {
//        return lhs.value == rhs.value
//    }
//
//    static func <(lhs: ChildIndex, rhs: ChildIndex) -> Bool {
//        return lhs.value < rhs.value
//    }
    
    var cbor: CBOR {
        CBOR.unsignedInt(UInt64(value))
    }
    
    init?(cbor: CBOR) throws {
        guard case let CBOR.unsignedInt(value) = cbor else {
            return nil
        }
        guard value < 0x80000000 else {
            throw GeneralError("Invalid child index.")
        }
        self.init(UInt32(value))
    }
}

//extension ChildIndex: CustomStringConvertible {
//    var description: String {
//        String(value)
//    }
//}
//
//extension ChildIndex {
//    static func parse(_ s: String) -> ChildIndex? {
//        guard let i = Int(s), i >= 0, i < 0x80000000 else {
//            return nil
//        }
//        return try! ChildIndex(UInt32(i))
//    }
//}
