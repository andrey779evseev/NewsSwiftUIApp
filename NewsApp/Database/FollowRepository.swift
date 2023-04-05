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
    
    public static func follow(_ uid: String, with userId: String, by: String) -> FollowModel? {
        var model = FollowModel(uid: uid)
        do {
            let ref = try db.collection("users").document(userId).collection("following")
                .addDocument(from: model) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    }
                }
            UserRepository.getUser(uid) { user in
                if let user = user {
                    let model = FollowModel(uid: by)
                    do {
                        try db.collection("users").document(user.id!).collection("followers")
                            .addDocument(from: model) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                }
                            }
                    } catch {
                        print("error while adding user to followers \(error)")
                    }
                }
            }
            model.setId(ref.documentID)
            return model
        } catch {
            print("error while follow \(error)")
        }
        return nil
    }
    
    public static func unfollow(_ id: String, with userId: String, by: String) {
        db.collection("users").document(userId).collection("following").document(id).delete()
        UserRepository.getUser(by) { user in
            if let userModel = user {
                db.collection("users").document(userModel.id!).collection("followers").whereField("uid", isEqualTo: by)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else if let data = querySnapshot!.documents.first {
                            do {
                                let follower = try data.data(as: FollowModel.self)
                                db.collection("users").document(userModel.id!).collection("followers").document(follower.id!).delete()
                            }
                            catch {
                                print(error)
                            }
                        } else {
                            print("Not found follower with this uid \(by)")
                        }
                    }
            } else {
                print("Error founding user")
            }
        }
    }
    
}
