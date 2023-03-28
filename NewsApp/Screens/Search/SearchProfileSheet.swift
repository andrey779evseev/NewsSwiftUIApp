//
//  SearchProfileScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/28/23.
//

import SwiftUI

struct SearchProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    var user: UserModel
    var isFollowed: Bool
    
    @State private var tab = "Популярные"
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationTitle(text: "") {
                dismiss()
            }
            ScrollView(showsIndicators: false) {
                HStack {
                    Avatar(url: "https://yt3.googleusercontent.com/MRywaef1JLriHf-MUivy7-WAoVAL4sB7VHZXgmprXtmpOlN73I4wBhjjWdkZNFyJNiUP6MHm1w=s900-c-k-c0x00ffffff-no-rj", size: .big, type: .circular)
                    Spacer()
                    VStack(spacing: 0) {
                        Text("1.2M")
                            .poppinsFont(.captionBold)
                            .foregroundColor(.dark)
                        Text("Подписчики")
                            .poppinsFont(.caption)
                            .foregroundColor(.body)
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("1.3M")
                            .poppinsFont(.captionBold)
                            .foregroundColor(.dark)
                        Text("Подпиcки")
                            .poppinsFont(.caption)
                            .foregroundColor(.body)
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("328")
                            .poppinsFont(.captionBold)
                            .foregroundColor(.dark)
                        Text("Новости")
                            .poppinsFont(.caption)
                            .foregroundColor(.body)
                    }
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(user.name.isEmpty ? user.email : user.name)
                        .poppinsFont(.footnoteBold)
                        .foregroundColor(.dark)
                    Text(user.about)
                        .poppinsFont(.footnote)
                        .foregroundColor(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 16) {
                    UiButton(type: .primary, size: .big, text: isFollowed ? "Отписаться" : "Подписаться") {
                        
                    }
                    if let url = URL(string: user.site) {
                        Link(destination: url) {
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .overlay(
                                    Text("Сайт")
                                        .poppinsFont(.footnoteBold)
                                        .foregroundColor(.white)
                                )
                        }
                    }
                }
                Tabs(items: ["Популярные", "Последние"], tab: $tab)
                if tab == "Популярные" {
                    HorizontalCard()
                    HorizontalCard()
                    HorizontalCard()
                    HorizontalCard()
                    HorizontalCard()
                    HorizontalCard()
                } else {
                    HorizontalCard()
                    HorizontalCard()
                    HorizontalCard()
                    HorizontalCard()
                    HorizontalCard()
                    HorizontalCard()
                }
            }
        }
        .padding(.all, 24)
    }
}

struct SearchProfileSheet_Previews: PreviewProvider {
    static var previews: some View {
        SearchProfileSheet(user: UserModel(email: "bbc@news.com", name: "BBC News", nickname: "bbcnews", photo: "https://yt3.googleusercontent.com/MRywaef1JLriHf-MUivy7-WAoVAL4sB7VHZXgmprXtmpOlN73I4wBhjjWdkZNFyJNiUP6MHm1w=s900-c-k-c0x00ffffff-no-rj", about: "является оперативным бизнес-подразделением Британской радиовещательной корпорации, ответственным за сбор и передачу новостей и текущих событий.", site: "https://bbc.news.com", uid: "bbcnews", initialized: true), isFollowed: true)
    }
}
