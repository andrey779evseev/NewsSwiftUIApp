//
//  FollowRepository.swift
//  NewsApp
//
//  Created by Andrew on 4/5/23.
//

import Foundation
import FirebaseFirestore

struct FollowRepository {
    public static func getFollowing (_ id: String, completion: @escaping (_ following: [FollowModel]) -> Void) {
        db.collection("users").document(id).collection("following")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let result = querySnapshot!.documents.compactMap { document in
                        do {
                            return try document.data(as: FollowModel.self)
                        } catch {
                            print("error when parsing following model \(error)")
                        }
                        return nil
                    }
                    completion(result)
                }}
    }
    
    public static func getFollowing (_ id: String) async -> [FollowModel] {
        await withCheckedContinuation { continuation in
            getFollowing(id) { following in
                continuation.resume(returning: following)
            }
        }
    }
    
    public static func getFollowers (_ id: String, completion: @escaping (_ followers: [FollowModel]) -> Void) {
        db.collection("users").document(id).collection("followers")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let result = querySnapshot!.documents.compactMap { document in
                        do {
                            return try document.data(as: FollowModel.self)
                        } catch {
                            print("error when parsing following model \(error)")
                        }
                        return nil
                    }
                    completion(result)
                }}
    }
    
    public static func getFollowers (_ id: String) async -> [FollowModel] {
        await withCheckedContinuation { continuation in
            getFollowers(id) { followers in
                continuation.resume(returning: followers)
            }
        }
    }
    
    public static func getFollowersModels (_ id: String) async -> [UserModel] {
        let followers = await getFollowers(id)
        var usersModels: [UserModel] = []
        for follower in followers {
            let user = await UserRepository.getUser(follower.uid)
            usersModels.append(user!)
        }
        return usersModels
    }
    
    public static func getFollowingModels (_ id: String) async -> [UserModel] {
        let followings = await getFollowing(id)
        var usersModels: [UserModel] = []
        for following in followings {
            let user = await UserRepository.getUser(following.uid)
            usersModels.append(user!)
        }
        return usersModels
    }
    
    /// uid: who you want to start follow
    /// with: user id (document id) who wants to follow
    /// by: user uid who wants to follow
    public static func follow(_ uid: String, with userId: String, by: String) async -> FollowModel? {
        var model = FollowModel(uid: uid)
        do {
            let ref = try db.collection("users").document(userId).collection("following")
                .addDocument(from: model)
            let user = await UserRepository.getUser(uid)!
            try db.collection("users").document(user.id!).collection("followers")
                .addDocument(from: FollowModel(uid: by))
            model.setId(ref.documentID)
            
            await NotificationRepository.saveNotification(from: by, to: uid, type: .follow)
            
            return model
        } catch {
            print("error while follow \(error)")
            return nil
        }
    }
    
    /// id: document id of follow model
    /// from: document id who follow
    /// by: user uid who is followed
    public static func unfollow(_ id: String, from userId: String, by: String) async {
        do {
            try await db.collection("users").document(userId).collection("following").document(id).delete()
            let user = await UserRepository.getUser(by)!
            let snapshot = try await db
                .collection("users")
                .document(user.id!)
                .collection("followers")
                .whereField("uid", isEqualTo: by)
                .getDocuments()
            if let data = snapshot.documents.first {
                let follower = try data.data(as: FollowModel.self)
                try await db
                    .collection("users")
                    .document(user.id!)
                    .collection("followers")
                    .document(follower.id!)
                    .delete()
            }
        } catch {
            print("Error while unfollowing user: \(error.localizedDescription)")
        }
    }
    
    public static func getFollowed(_ uid: String, by: String, completion: @escaping (_ followed: FollowModel?) -> Void) {
        db.collection("users").document(by).collection("following").whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                print("Error while getting is followed \(error.localizedDescription)")
            }
            if let document = snapshot?.documents.first {
                do {
                    let doc = try document.data(as: FollowModel.self)
                    completion(doc)
                }
                catch {
                    print(error)
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    public static func getFollowed(_ uid: String, by: String) async -> FollowModel? {
        await withCheckedContinuation { continuation in
            getFollowed(uid, by: by) { followed in
                continuation.resume(returning: followed)
            }
        }
    }
    
    public static func getFollowersCount (_ userId: String) async -> Int {
        let query = db.collection("users").document(userId).collection("followers").count
        do {
            let snapshot = try await query.getAggregation(source: .server)
            return snapshot.count.intValue
        } catch {
            print("Error while getting count of followers: \(error.localizedDescription)")
            return 0
        }
    }
    
    public static func getFollowingCount (_ userId: String) async -> Int {
        let query = db.collection("users").document(userId).collection("following").count
        do {
            let snapshot = try await query.getAggregation(source: .server)
            return snapshot.count.intValue
        } catch {
            print("Error while getting count of followers: \(error.localizedDescription)")
            return 0
        }
    }
}
