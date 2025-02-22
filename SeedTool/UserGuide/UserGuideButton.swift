//
//  UserGuideButton.swift
//  SeedTool
//
//  Created by Wolf McNally on 7/27/21.
//

import SwiftUI

struct UserGuideButton: View {
    @State private var isPresented: Bool = false
    let openToChapter: Chapter?
    let showShortTitle: Bool
    let font: Font
    
    init(openToChapter: Chapter? = nil, showShortTitle: Bool = false, font: Font = .title) {
        self.openToChapter = openToChapter
        self.showShortTitle = showShortTitle
        self.font = font
    }
    
    var body: some View {
        Button {
            isPresented = true
        } label: {
            if showShortTitle,
               let chapter = openToChapter,
               let title = chapter.shortTitle
            {
                HStack(spacing: 5) {
                    Image.guide
                    Text(title)
                }
                .font(.caption)
                .lineLimit(1)
            } else {
                Image.guide
            }
        }
        .sheet(isPresented: $isPresented) {
            UserGuide(isPresented: $isPresented, openToChapter: openToChapter)
        }
        .font(font)
        .padding([.top, .bottom, .trailing], 10)
        .accessibility(label: Text("Documentation"))
    }
}

#if DEBUG

struct UserGuideButton_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            UserGuideButton(openToChapter: nil)
            UserGuideButton(openToChapter: .aboutSeedTool)
            UserGuideButton(openToChapter: .whatIsALifehash)
        }
        .darkMode()
    }
}

#endif
