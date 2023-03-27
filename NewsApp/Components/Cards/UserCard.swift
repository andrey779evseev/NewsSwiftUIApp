//
//  UserCard.swift
//  NewsApp
//
//  Created by Andrew on 3/27/23.
//

import SwiftUI

struct UserCard: View {
    var user: UserModel
    var isFollowed: Bool
    var perform: () -> Void
    var body: some View {
        HStack(spacing: 0) {
            Avatar(url: user.photo, size: .medium, type: .circular)
                .padding(.trailing, 4)
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name.isEmpty ? user.email : user.name)
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                Text("1.2M Подписчиков")
                    .poppinsFont(.caption)
                    .foregroundColor(.body)
            }
            Spacer()
            if isFollowed {
                UiButton(type: .primary, size: .small, text: "Отписаться", perform: perform
                )
            } else {
                UiButton(type: .outline, size: .small, text: "Подписаться", perform: perform, leftIcon: {
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                    .foregroundColor(.blue)})
            }
        }
    }
}

struct UserCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UserCard(user: UserModel(email: "bbc@news.com", name: "BBC News", nickname: "bbcnews", photo: "https://yt3.googleusercontent.com/MRywaef1JLriHf-MUivy7-WAoVAL4sB7VHZXgmprXtmpOlN73I4wBhjjWdkZNFyJNiUP6MHm1w=s900-c-k-c0x00ffffff-no-rj", about: "About bbc news", site: "https://bbc.news", uid: "gg", initialized: true), isFollowed: true, perform: {})
            UserCard(user: UserModel(email: "bbc@news.com", name: "BBC News", nickname: "bbcnews", photo: "https://yt3.googleusercontent.com/MRywaef1JLriHf-MUivy7-WAoVAL4sB7VHZXgmprXtmpOlN73I4wBhjjWdkZNFyJNiUP6MHm1w=s900-c-k-c0x00ffffff-no-rj", about: "About bbc news", site: "https://bbc.news", uid: "gg", initialized: true), isFollowed: false, perform: {})

        }
        .padding()
    }
}
