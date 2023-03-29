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
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationTitle(text: "") {
                dismiss()
            }
            UserProfile(user: UserModel(email: "bbc@news.com", name: "BBC News", nickname: "bbcnews", photo: "https://yt3.googleusercontent.com/MRywaef1JLriHf-MUivy7-WAoVAL4sB7VHZXgmprXtmpOlN73I4wBhjjWdkZNFyJNiUP6MHm1w=s900-c-k-c0x00ffffff-no-rj", about: "является оперативным бизнес-подразделением Британской радиовещательной корпорации, ответственным за сбор и передачу новостей и текущих событий.", site: "https://bbc.news.com", uid: "bbcnews", initialized: true), type: isFollowed ? .followed : .unfollowed)
        }
        .padding(.all, 24)
    }
}

struct SearchProfileSheet_Previews: PreviewProvider {
    static var previews: some View {
        SearchProfileSheet(user: UserModel(email: "bbc@news.com", name: "BBC News", nickname: "bbcnews", photo: "https://yt3.googleusercontent.com/MRywaef1JLriHf-MUivy7-WAoVAL4sB7VHZXgmprXtmpOlN73I4wBhjjWdkZNFyJNiUP6MHm1w=s900-c-k-c0x00ffffff-no-rj", about: "является оперативным бизнес-подразделением Британской радиовещательной корпорации, ответственным за сбор и передачу новостей и текущих событий.", site: "https://bbc.news.com", uid: "bbcnews", initialized: true), isFollowed: true)
    }
}
