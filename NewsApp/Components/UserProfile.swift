//
//  UserProfile.swift
//  NewsApp
//
//  Created by Andrew on 3/29/23.
//

import SwiftUI

struct UserProfile: View {
    var user: UserModel
    var type: UserType
    var perform: () -> Void
    
    @State private var tab = "Популярные"
    
    var buttonText: String {
        switch type {
        case .followed:
            return "Отписаться"
        case .unfollowed:
            return "Подписаться"
        case .own:
            return "Редактировать"
        }
    }
    
    var body: some View {
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
                UiButton(type: .primary, size: .big, text: buttonText) {
                    perform()
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
    enum UserType {
        case followed
        case unfollowed
        case own
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(user: TestUserModel, type: .followed) {}
    }
}
