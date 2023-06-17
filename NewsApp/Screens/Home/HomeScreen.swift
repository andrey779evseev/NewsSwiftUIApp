//
//  HomeScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/23/23.
//

import SwiftUI

struct HomeScreen: View {
    var namespace: Namespace.ID
    @EnvironmentObject var router: Router
    @EnvironmentObject var auth: AuthService
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var popularPosts: [ExtendedPostModel] = []
    @State private var latestPosts: [ExtendedPostModel] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                HStack {
                    Image("Logo")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("News")
                        .poppinsFont(.title3Bold)
                        .foregroundColor(.dark)
                }
                Spacer()
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 32, height: 32)
                    .foregroundColor(isDarkMode ? .darkmodeInputBackground : .white)
                    .shadow(color: .dark.opacity(0.15), radius: 10)
                    .overlay(
                        Image(systemName: "bell")
                            .font(.system(size: 20))
                            .foregroundColor(.dark)
                    )
                    .onTapGesture {
                        router.go(.notifications)
                    }
            }
            .padding(.bottom, 26)
            
            HStack(spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.body)
                    .padding(.trailing, 10)
                
                Text("Поиск")
                    .poppinsFont(.caption)
                    .foregroundColor(isDarkMode ? .white : .placeholder)
                
                Spacer()
                
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundColor(.body)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            .background(
                ZStack {
                    if isDarkMode {
                        RoundedRectangle(cornerRadius: 6).fill(Color.darkmodeInputBackground)
                    } else {
                        RoundedRectangle(cornerRadius: 6).stroke(Color.body)
                    }
                }
            )
            .onTapGesture {
                router.go(.search)
            }
            .matchedGeometryEffect(id: "input", in: namespace)
            
            
            
            ScrollView(showsIndicators: false) {
                HStack {
                    Text("Популярные")
                        .poppinsFont(.footnoteBold)
                        .foregroundColor(.dark)
                    Spacer()
                    Button {
                        router.go(.popular)
                    } label: {
                        Text("Смотреть все")
                            .poppinsFont(.caption)
                            .foregroundColor(.body)
                    }
                }
                
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
                
                HStack {
                    Text("Последние")
                        .poppinsFont(.footnoteBold)
                        .foregroundColor(.dark)
                    Spacer()
                    Button {
                        router.go(.latest)
                    } label: {
                        Text("Смотреть все")
                            .poppinsFont(.caption)
                            .foregroundColor(.body)
                    }
                }
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
                        HorizontalCard(post: $post)
                            .environmentObject(auth)
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.top, .leading, .trailing], 24)
        .task {
            self.popularPosts = await PostRepository.getFeed(for: auth.user!.id!, with: 1, sort: .popularity)
            self.latestPosts = await PostRepository.getFeed(for: auth.user!.id!, with: 2, sort: .time)
            isLoading = false
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(namespace: Namespace().wrappedValue)
    }
}
