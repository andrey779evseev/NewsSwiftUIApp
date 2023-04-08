//
//  PopularScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/27/23.
//

import SwiftUI

struct PopularScreen: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var auth: AuthService
    
    @State private var popularPosts: [ExtendedPostModel] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationTitle(text: "Популярные") {
                router.go(.home)
            }
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    if isLoading {
                        ProgressView()
                            .tint(.blue)
                            .scaleEffect(3)
                            .padding(.vertical, 80)
                    } else if popularPosts.isEmpty {
                        Text("Нет постов, подпишитесь на кого нибудь")
                            .poppinsFont(.title3)
                            .foregroundColor(.body)
                            .padding(.vertical, 40)
                            .multilineTextAlignment(.center)
                    } else {
                        ForEach($popularPosts) { $post in
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
            self.popularPosts = await PostRepository.getFeed(for: auth.user!.id!, with: 15, sort: .popularity)
            isLoading = false
        }
    }
}

struct PopularScreen_Previews: PreviewProvider {
    static var previews: some View {
        PopularScreen()
    }
}
