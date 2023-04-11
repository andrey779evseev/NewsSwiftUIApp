//
//  FollowersFollowingSheet.swift
//  NewsApp
//
//  Created by Andrew on 4/5/23.
//

import SwiftUI

struct FollowersFollowingSheet: View {
    var isFollowers: Bool
    var user: UserModel
    @Environment(\.dismiss) var dismiss
    
    @State private var users: [UserModel] = []
    @State private var following: [FollowModel] = []
    @State private var isLoading = true
//    @State private var profileUser: UserModel? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 20))
                    .foregroundColor(.dark)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
                Text(isFollowers ? "Подписчики" : "Подписки")
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                Spacer()
                Text("\t")
            }
            if isLoading {
                Spacer()
                ProgressView()
                    .tint(.blue)
                    .scaleEffect(3)
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(users) { model in
                            let isFollowed = following.contains {$0.uid == model.uid}
                            UserCard(user: model, isFollowed: isFollowers && isFollowed, hideButton: !isFollowers) {
                                Task {
                                    if isFollowed {
                                        let follow = self.following.first {$0.uid == model.uid}!
                                        await FollowRepository.unfollow(follow.id!, from: user.id!, by: model.uid)
                                        self.following.removeAll {$0.uid == model.uid}
                                    } else {
                                        let model = await FollowRepository.follow(model.uid, with: user.id!, by: user.uid)
                                        self.following.append(model!)
                                    }
                                }
                            }
//                            .onTapGesture {
//                                profileUser = user
//                            }
//                            .sheet(item: $profileUser) { user in
//                                SearchProfileSheet(user: user, isFollowed: isFollowers || isFollowed)
//                            }
                        }
                    }
                }
            }
        }
        .padding(.all, 24)
        .background(Color.white)
        .task {
            if isFollowers {
                self.users = await FollowRepository.getFollowersModels(user.id!)
                self.following = await FollowRepository.getFollowing(user.id!)
                isLoading = false
            } else {
                self.users = await FollowRepository.getFollowingModels(user.id!)
                isLoading = false
            }
        }
    }
}

struct FollowersFollowingSheet_Previews: PreviewProvider {
    static var previews: some View {
        FollowersFollowingSheet(isFollowers: true, user: TestUserModel)
    }
}
