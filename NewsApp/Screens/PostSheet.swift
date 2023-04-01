//
//  PostSheet.swift
//  NewsApp
//
//  Created by Andrew on 4/1/23.
//

import SwiftUI

struct PostSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 20))
                        .foregroundColor(.body)
                        .onTapGesture {
                            dismiss()
                        }
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18))
                        .foregroundColor(.body)
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20))
                        .foregroundColor(.body)
                        .rotationEffect(.degrees(90))
                }
                HStack(spacing: 4) {
                    Avatar(url: "https://yt3.googleusercontent.com/MRywaef1JLriHf-MUivy7-WAoVAL4sB7VHZXgmprXtmpOlN73I4wBhjjWdkZNFyJNiUP6MHm1w=s900-c-k-c0x00ffffff-no-rj", size: .average, type: .circular)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("BBC News")
                            .poppinsFont(.footnoteBold)
                            .foregroundColor(.dark)
                        Text("14м назад")
                            .poppinsFont(.caption)
                            .foregroundColor(.body)
                    }
                    Spacer()
                    UiButton(type: .primary, size: .small, text: "Отписаться") {}
                }
                
                ScrollView(showsIndicators: false) {
                    RemoteImage(url: "https://images.coolhouseplans.com/plans/44207/44207-b600.jpg", width: .max, height: .constant(248))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    Text("Lorem ipsum lorem y ipsum lorem: lorem ipsum lorem ipsum lorem")
                        .poppinsFont(.title3)
                        .foregroundColor(.dark)
                    
                    Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
                        .poppinsFont(.footnote)
                        .foregroundColor(.body)
                }
            }
            .padding([.top, .leading, .trailing], 24)
            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.error)
                Text("24.5K")
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                    .padding(.trailing, 26)
                Image(systemName: "ellipsis.message")
                    .font(.system(size: 20))
                    .foregroundColor(.dark)
                Text("1K")
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                Spacer()
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 30)
            .frame(height: 64)
            .barShadow()
        }
    }
}

struct PostSheet_Previews: PreviewProvider {
    static var previews: some View {
        PostSheet()
    }
}
