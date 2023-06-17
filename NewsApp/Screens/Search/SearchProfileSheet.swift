//
//  SearchProfileScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/28/23.
//

import SwiftUI

struct SearchProfileSheet: View {
    @EnvironmentObject var auth: AuthService
    @Environment(\.dismiss) var dismiss
    var user: UserModel
    var isFollowed: Bool
    @StateObject var userProfileModel = UserProfileViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @State private var followersCount = 0
    @State private var followingCount = 0
    @State private var postsCount = 0
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationTitle(text: "") {
                dismiss()
            }
            UserProfile(
                user: user,
                type: isFollowed ? .followed : .unfollowed,
                model: userProfileModel,
                followersCount: $followersCount,
                followingCount: $followingCount,
                postsCount: $postsCount
            ) {}
                .environmentObject(auth)
        }
        .padding(.all, 24)
        .background(isDarkMode ? Color.darkmodeBackground : Color.white)
        .task {
            self.followersCount = await FollowRepository.getFollowersCount(auth.user!.id!)
            self.followingCount = await FollowRepository.getFollowingCount(auth.user!.id!)
            self.postsCount = await PostRepository.getPostsCount(auth.user!.uid)
        }
    }
}

struct SearchProfileSheet_Previews: PreviewProvider {
    static var previews: some View {
        SearchProfileSheet(user: TestUserModel, isFollowed: true)
    }
}
