//
//  LatestScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/27/23.
//

import SwiftUI

struct LatestScreen: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var auth: AuthService
    
    @State private var latestPosts: [ExtendedPostModel] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationTitle(text: "Последние") {
                router.go(.home)
            }
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    if isLoading {
                        ProgressView()
                            .tint(.blue)
                            .scaleEffect(3)
                            .padding(.vertical, 80)
                    } else if latestPosts.isEmpty {
                        Text("Нет постов, подпишитесь на кого нибудь")
                            .poppinsFont(.title3)
                            .foregroundColor(.body)
                            .padding(.vertical, 40)
                            .multilineTextAlignment(.center)
                    } else {
                        ForEach($latestPosts) { $post in
                            VerticalCard(post: $post)
                                .environmentObject(auth)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding([.top, .leading, .trailing], 24)
        .task {
            self.latestPosts = await PostRepository.getFeed(for: auth.user!.id!, with: 15, sort: .time)
            isLoading = false
        }
    }
}

struct LatestScreen_Previews: PreviewProvider {
    static var previews: some View {
        LatestScreen()
    }
}
