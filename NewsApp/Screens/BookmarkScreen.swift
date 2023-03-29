//
//  BookmarkScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/29/23.
//

import SwiftUI

struct BookmarkScreen: View {
    @State private var search = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Закладки")
                .poppinsFont(.title)
                .foregroundColor(.dark)
            Input(
                value: $search,
                placeholder: "Поиск",
                rightIconPerform: {},
                leftIconPerform: {},
                rightIcon: {
                Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 20))
                        .foregroundColor(.body)
            }, leftIcon: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.body)
            })
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    HorizontalCard()
                    HorizontalCard()
                    HorizontalCard()
                    HorizontalCard()
                    HorizontalCard()
                    HorizontalCard()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.top, .leading, .trailing], 24)
    }
}

struct BookmarkScreen_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkScreen()
    }
}
