//
//  MarkdownEditor.swift
//  NewsApp
//
//  Created by Andrew on 4/3/23.
//

import SwiftUI



struct Editor: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .foregroundColor(.body)
                        .scrollContentBackground(.hidden)
                        .focused($isFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                if isFocused {
                                    Spacer()
                                    Button {
                                        isFocused = false
                                    } label: {
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 16))
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                        }
                        .offset(x: -4, y: -8)
                    if text.isEmpty {
                        Text("Добавить Новость/Статью")
                            .poppinsFont(.footnote)
                            .foregroundColor(.placeholder)
                            .onTapGesture {
                                isFocused = true
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 40)
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
            .background(isDarkMode ? Color.darkmodeInputBackground : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .cardShadow()
            .padding([.leading, .bottom], 8)
        }
        .background(isDarkMode ? Color.darkmodeBackground : Color.white)
    }
}

struct Editor_Previews: PreviewProvider {
    static var previews: some View {
        Editor(text: .constant(""))
            .padding()
    }
}
