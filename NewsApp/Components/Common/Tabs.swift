//
//  Tabs.swift
//  NewsApp
//
//  Created by Andrew on 3/28/23.
//

import SwiftUI

struct Tabs: View {
    var items: [String]
    @Binding var tab: String
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            ForEach(items, id: \.self) { item in
                VStack(spacing: 8) {
                    Text(item)
                        .poppinsFont(.footnote)
                        .foregroundColor(tab == item ? .dark : .body)
                    if tab == item {
                        Rectangle()
                            .frame(height: 4)
                            .foregroundColor(.blue)
                    }
                }
                .fixedSize()
                .onTapGesture {
                    withAnimation {
                        tab = item
                    }
                }
            }
        }
    }
}

struct Tabs_Previews: PreviewProvider {
    static var previews: some View {
        Tabs(items: ["Новости", "Авторы"], tab: .constant("Новости"))
    }
}
