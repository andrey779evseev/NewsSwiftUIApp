//
//  SearchScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/27/23.
//

import SwiftUI

struct SearchScreen: View {
    init(
        auth: AuthService,
        namespace: Namespace.ID
    ) {
        self.auth = auth
        self._model = StateObject(wrappedValue: FollowViewModel(userId: auth.user!.id!, uid: auth.user!.uid))
        self.namespace = namespace
    }
    var namespace: Namespace.ID
    @ObservedObject var auth: AuthService
    @StateObject private var model: FollowViewModel
    @EnvironmentObject var router: Router
    @State private var search = ""
    @State private var tab = "Новости"
    @State private var profileUser: UserModel? = nil
    @State private var posts: [ExtendedPostModel] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack(spacing: 16) {
            Input(
                value: $search,
                placeholder: "Поиск",
                autocapitalization: false,
                rightIconPerform: {
                    router.go(.home)
                },
                leftIconPerform: {},
                rightIcon: {
                Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(.body)
            }, leftIcon: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.body)
            })
            .matchedGeometryEffect(id: "input", in: namespace)
            .onChange(of: search, debounceTime: 0.5) { debouncedSearchText in
                if tab == "Авторы" {
                    withAnimation {
                        model.getSuggestions(debouncedSearchText)
                    }
                } else {
                    Task {
                        isLoading = true
                        self.posts = await PostRepository.searchPosts(debouncedSearchText)
                        isLoading = false
                    }
                }
            }
            Tabs(items: ["Новости", "Авторы"], tab: $tab)
            if isLoading {
                Spacer()
                ProgressView()
                    .tint(.blue)
                    .scaleEffect(3)
                Spacer()
            } else if tab == "Новости" && posts.isEmpty {
                Spacer()
                Text("По данному запросу ничего не найдено")
                    .poppinsFont(.title3)
                    .foregroundColor(.body)
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        if tab == "Новости" {
                            ForEach($posts) { $post in
                                HorizontalCard(post: $post)
                                    .environmentObject(auth)
                            }
                        } else {
                            ForEach(model.suggestions, id: \.uid) { user in
                                let isFollowed = model.following.contains(where: { $0.uid == user.uid })
                                UserCard(user: user, isFollowed: isFollowed) {
                                    if isFollowed {
                                        model.unfollow(user.uid)
                                    } else {
                                        model.follow(user.uid)
                                    }
                                }
                                .onTapGesture {
                                    profileUser = user
                                }
                            }
                            .sheet(item: $profileUser) { user in
                                SearchProfileSheet(user: user, isFollowed: model.following.contains(where: { $0.uid == user.uid }))
                                    .environmentObject(auth)
                            }
                        }
                    }
                }
            }
        }
        .padding(.all, 24)
        .task {
            if tab == "Новости" {
                self.posts = await PostRepository.searchPosts(search)
            }
            isLoading = false
        }
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen(auth: AuthService(), namespace: Namespace().wrappedValue)
    }
}
