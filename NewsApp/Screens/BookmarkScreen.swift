//
//  BookmarkScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/29/23.
//

import SwiftUI

struct BookmarkScreen: View {
    @EnvironmentObject var auth: AuthService
    @State private var search = ""
    @State private var posts: [ExtendedPostModel] = []
    @State private var isLoading = true
    
    func getPosts () async {
        isLoading = true
        self.posts = await BookmarkRepository.getBookmarks(for: auth.user!.id!, search: search)
        isLoading = false
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Закладки")
                .poppinsFont(.title)
                .foregroundColor(.dark)
            Input(
                value: $search,
                placeholder: "Поиск",
                rightIconPerform: {},
                leftIconPerform: {},
                rightIcon: {
                Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 20))
                        .foregroundColor(.body)
            }, leftIcon: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.body)
            })
            .onChange(of: search) { newItem in
                Task {
                    await getPosts()
                }
            }
            if isLoading {
                Spacer()
                ProgressView()
                    .tint(.blue)
                    .scaleEffect(3)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else if posts.isEmpty {
                Spacer()
                Text("У вас еще нет закладок, вы можете из добавить нажав, кнопку закладки, на странице поста")
                    .poppinsFont(.title3)
                    .foregroundColor(.body)
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach($posts) { $post in
                            HorizontalCard(post: $post) {
                                Task {
                                    await getPosts()
                                }
                            }
                            .environmentObject(auth)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.top, .leading, .trailing], 24)
        .task {
            await getPosts()
        }
        .refreshable {
            await getPosts()
        }
    }
}

struct BookmarkScreen_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkScreen()
    }
}
