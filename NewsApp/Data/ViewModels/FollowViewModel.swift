//
//  AccountInitializationViewModel.swift
//  NewsApp
//
//  Created by Andrew on 3/22/23.
//

import Foundation
import Swift
import SwiftUI


final class FollowViewModel: ObservableObject {
    init (userId: String, uid: String) {
        self.userId = userId
        self.uid = uid
        UserRepository.getFollowers(userId) {followers in
            self.followers = followers
        }
        UserRepository.getFollowing(userId) {following in
            self.following = following
        }
        getSuggestions("")
    }
    var userId: String
    var uid: String
    @Published var following: [FollowModel] = []
    @Published var followers: [FollowModel] = []
    @Published var suggestions: [UserModel] = []
    
    public func getSuggestions (_ search: String) {
        UserRepository.getSuggestions(search) {users in
            self.suggestions = users.filter { $0.id != self.userId }
        }
    }
    
    public func follow (_ uid: String) {
        let model = UserRepository.follow(uid, with: self.userId, by: self.uid)
        if let model = model {
            withAnimation {
                following.append(model)
            }
        }
    }
    
    public func unfollow (_ uid: String) {
        if let model = following.first(where: { $0.uid == uid }) {
            UserRepository.unfollow(model.id!, with: self.userId, by: self.uid)
            withAnimation {
                following = following.filter {$0.uid != uid}
            }
        }
    }
}
