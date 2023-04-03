//
//  MarkdownEditor.swift
//  NewsApp
//
//  Created by Andrew on 4/3/23.
//

import SwiftUI



struct Editor: View {
    @State private var text = ""
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                    Text("Добавить Новость/Статью")
                        .poppinsFont(.footnote)
                        .foregroundColor(.placeholder)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack(spacing: 16) {
                Group {
                    Image(systemName: "bold")
                    Image(systemName: "italic")
                    Image(systemName: "list.number")
                    Image(systemName: "list.bullet")
                    Image(systemName: "link")
                        .font(.system(size: 18))
                }
                .font(.system(size: 20))
                .foregroundColor(.body)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .cardShadow()
            .padding([.leading, .bottom], 8)
        }
    }
}

struct Editor_Previews: PreviewProvider {
    static var previews: some View {
        Editor()
    }
}
