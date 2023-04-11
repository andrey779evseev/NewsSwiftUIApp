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
        FollowRepository.getFollowers(userId) {followers in
            self.followers = followers
        }
        FollowRepository.getFollowing(userId) {following in
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
    
    public func follow (_ uid: String) async {
        let model = await FollowRepository.follow(uid, with: self.userId, by: self.uid)
        if let model = model {
            DispatchQueue.main.sync {
                self.following.append(model)
            }
        } else {
            print("Following doesnt happend")
        }
    }
    
    public func unfollow (_ uid: String) async {
        if let model = self.following.first(where: { $0.uid == uid }) {
            await FollowRepository.unfollow(model.id!, from: self.userId, by: uid)
            DispatchQueue.main.sync {
                self.following = self.following.filter {$0.uid != uid}
            }
        }
    }
}
