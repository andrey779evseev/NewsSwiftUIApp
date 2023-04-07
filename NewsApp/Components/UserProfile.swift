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
    @ObservedObject var auth: AuthService
    var perform: () -> Void
    
    @State private var posts: [ExtendedPostModel] = []
    @State private var tab = "Популярные"
    @State private var isFollowersSheet = false
    @State private var isFollowingsSheet = false
    @State private var isLoading = false
    
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
    
    func getPosts () async {
        isLoading = true
        let sort: PostRepository.GetPostsSorting
        if tab == "Популярные" {
            sort = .popularity
        } else {
            sort = .time
        }
        self.posts = await PostRepository.getPosts(by: user.uid, sort: sort)
        isLoading = false
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Avatar(url: user.photo, size: .big, type: .circular)
                Spacer()
                VStack(spacing: 0) {
                    Text("1.2M")
                        .poppinsFont(.captionBold)
                        .foregroundColor(.dark)
                    Text("Подписчики")
                        .poppinsFont(.caption)
                        .foregroundColor(.body)
                }
                .onTapGesture {
                    if type == .own {
                        isFollowersSheet = true
                    }
                }
                .sheet(isPresented: $isFollowersSheet) {
                    FollowersFollowingSheet(isFollowers: true, user: user)
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
                .onTapGesture {
                    if type == .own {
                        isFollowingsSheet = true
                    }
                }
                .sheet(isPresented: $isFollowingsSheet) {
                    FollowersFollowingSheet(isFollowers: false, user: user)
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
            if isLoading {
                ProgressView()
                    .tint(.blue)
                    .scaleEffect(3)
                    .padding(.vertical, 80)
            } else if posts.count > 0 {
                ForEach($posts) { $post in
                    HorizontalCard(post: $post)
                        .environmentObject(auth)
                }
            } else {
                Text("У вас еще нет постов")
                    .poppinsFont(.title2)
                    .foregroundColor(.body)
                    .padding(.vertical, 80)
            }
        }
        .task {
            await getPosts()
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
        UserProfile(user: TestUserModel, type: .followed, auth: AuthService.forTest()) {}
    }
}
