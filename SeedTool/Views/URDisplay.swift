//
//  URDisplay.swift
//  Gordian Seed Tool
//
//  Created by Wolf McNally on 2/19/21.
//

import SwiftUI
import BCFoundation
import URUI

let appMaxFragmentLen = 600

struct URDisplay: View {
    @StateObject private var displayState: URDisplayState
    @State private var activityParams: ActivityParams?
    let name: String
    let fields: ExportFields?

    init(ur: UR, name: String, fields: ExportFields? = nil) {
        self._displayState = StateObject(wrappedValue: URDisplayState(ur: ur, maxFragmentLen: appMaxFragmentLen))
        self.name = name
        var fields = fields ?? [:]
        fields[.format] = "UR"
        self.fields = fields
    }
    
    var body: some View {
        URQRCode(data: .constant(displayState.part), foregroundColor: .black, backgroundColor: .white)
            .frame(maxWidth: 600)
            .conditionalLongPressAction(actionEnabled: displayState.isSinglePart) {
                activityParams = ActivityParams(
                    makeQRCodeImage(displayState.part, backgroundColor: .white).scaled(by: 8),
                    name: name,
                    fields: fields
                )
            }
            .onAppear {
                displayState.framesPerSecond = 3
                displayState.run()
            }
            .onDisappear() {
                displayState.stop()
            }
            .background(ActivityView(params: $activityParams))
            .accessibility(label: Text("QR Code"))
    }
}

#if DEBUG

import WolfLorem

struct URDisplay_Previews: PreviewProvider {
    static let ur = Lorem.seed().ur

    static var previews: some View {
        Group {
            URDisplay(ur: ur, name: "Lorem")
        }
        .darkMode()
    }
}

#endif
