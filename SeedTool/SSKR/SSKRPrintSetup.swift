//
//  SSKRPrintSetup.swift
//  SeedTool
//
//  Created by Wolf McNally on 2/7/22.
//

import SwiftUI

struct SSKRPrintSetup: View {
    @EnvironmentObject var model: Model
    @Binding var isPresented: Bool
    @State var summaryPage: Bool
    @State var notesOnSummaryPage: Bool
    @State var multipleSharesPerPage: Bool
    @State var pages: PrintablePages

    let sskr: SSKRGenerator

    init(isPresented: Binding<Bool>, sskr: SSKRGenerator) {
        let summaryPage = true
        let notesOnSummaryPage = false
        let multipleSharesPerPage = false
        
        self._summaryPage = State(initialValue: summaryPage)
        self._notesOnSummaryPage = State(initialValue: notesOnSummaryPage)
        self._multipleSharesPerPage = State(initialValue: multipleSharesPerPage)

        self._isPresented = isPresented
        self.sskr = sskr
        self._pages = State(initialValue: Self.updatedPages(sskr: sskr, multipleSharesPerPage: multipleSharesPerPage, summaryPage: summaryPage, notesOnSummaryPage: notesOnSummaryPage))
    }
    
    var body: some View {
        PrintSetup(
            subject: $pages,
            isPresented: $isPresented
        ) {
            VStack(alignment: .leading) {
                Toggle("Summary Page", isOn: $summaryPage)
                Text("Include a first page that can be used to identify each share.")
                    .font(.caption)
                Toggle("Seed Notes", isOn: $notesOnSummaryPage)
                    .disabled(!summaryPage)
                Text("Include the Seed Notes field on the first page.")
                    .font(.caption)
                Toggle("Multiple Shares Per Page", isOn: $multipleSharesPerPage)
                Text("Print multiple “share coupons” on each page that need to be cut apart.")
                    .font(.caption)
            }
        }
        .environmentObject(model)
        .onChange(of: multipleSharesPerPage) { newValue in
            pages = Self.updatedPages(
                sskr: sskr,
                multipleSharesPerPage: newValue,
                summaryPage: summaryPage,
                notesOnSummaryPage: notesOnSummaryPage
            );
        }
        .onChange(of: summaryPage) { newValue in
            pages = Self.updatedPages(
                sskr: sskr,
                multipleSharesPerPage: multipleSharesPerPage,
                summaryPage: newValue,
                notesOnSummaryPage: notesOnSummaryPage
            );
        }
        .onChange(of: notesOnSummaryPage) { newValue in
            pages = Self.updatedPages(
                sskr: sskr,
                multipleSharesPerPage: multipleSharesPerPage,
                summaryPage: summaryPage,
                notesOnSummaryPage: newValue);
        }
    }

    static func updatedPages(sskr: SSKRGenerator, multipleSharesPerPage: Bool, summaryPage: Bool, notesOnSummaryPage: Bool) -> PrintablePages {
        sskr.multipleSharesPerPage = multipleSharesPerPage
        return PrintablePages(name: sskr.name, printExportFields: sskr.printExportFields, printables: [
            summaryPage ? SSKRSummaryPage(sskr: sskr, includeNotes: notesOnSummaryPage).eraseToAnyPrintable() : nil,
            sskr.eraseToAnyPrintable()
        ].compactMap { $0 })
    }
}

#if DEBUG

import WolfLorem

struct SSKRPrintSetup_Previews: PreviewProvider {
    static let model = Lorem.model()
    static let seed = model.seeds.first!
    static let sskrModel = SSKRPreset.modelTwoOfThreeOfTwoOfThree
//    static let sskrModel = SSKRPreset.modelOneOfOne
    static let sskr = SSKRGenerator(seed: seed, sskrModel: sskrModel)
    static var previews: some View {
        VStack {
            SSKRPrintSetup(isPresented: .constant(true), sskr: sskr)
            .environmentObject(model)
        }
        .darkMode()
    }
}

#endif
