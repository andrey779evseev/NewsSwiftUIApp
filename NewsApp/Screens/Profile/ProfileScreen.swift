//
//  ProfileScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/29/23.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var router: Router
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("\t")
                Spacer()
                Text("Профиль")
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                Spacer()
                Image(systemName: "gear")
                    .font(.system(size: 20))
                    .foregroundColor(.dark)
                    .onTapGesture {
                        router.go(.settings)
                    }
            }
            UserProfile(user: UserModel(email: "bbc@news.com", name: "BBC News", nickname: "bbcnews", photo: "https://yt3.googleusercontent.com/MRywaef1JLriHf-MUivy7-WAoVAL4sB7VHZXgmprXtmpOlN73I4wBhjjWdkZNFyJNiUP6MHm1w=s900-c-k-c0x00ffffff-no-rj", about: "является оперативным бизнес-подразделением Британской радиовещательной корпорации, ответственным за сбор и передачу новостей и текущих событий.", site: "https://bbc.news.com", uid: "bbcnews", initialized: true), type: .own)
        }
        .padding([.top, .leading, .trailing], 24)
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
