//
//  Asset.swift
//  Guardian
//
//  Created by Wolf McNally on 1/22/21.
//

import SwiftUI
import URKit

enum Asset: UInt32, Identifiable, CaseIterable {
    // Values from [SLIP44] with high bit turned off
    case btc = 0
    case bch = 145
    
    var cbor: CBOR {
        CBOR.unsignedInt(UInt64(rawValue))
    }
    
    init(cbor: CBOR) throws {
        guard
            case let CBOR.unsignedInt(r) = cbor,
            let a = Asset(rawValue: UInt32(r)) else {
            throw GeneralError("Invalid Asset.")
        }
        self = a
    }
    
    var icon: AnyView {
        switch self {
        case .btc:
            return Image("asset.btc").renderingMode(.original).eraseToAnyView()
        case .bch:
            return Image("asset.bch").renderingMode(.original).eraseToAnyView()
        }
    }
    
    var id: String {
        "asset-\(description)"
    }
    
    var subtype: ModelSubtype {
        ModelSubtype(id: id, icon: icon)
    }
    
    var name: String {
        switch self {
        case .btc:
            return "Bitcoin"
        case .bch:
            return "Bitcoin Cash"
        }
    }
}

extension Asset: Segment {
    var label: AnyView {
        makeSegmentLabel(title: name, icon: icon)
    }
}

extension Asset: CustomStringConvertible {
    var description: String {
        switch self {
        case .btc:
            return "btc"
        case .bch:
            return "bch"
        }
    }
}
