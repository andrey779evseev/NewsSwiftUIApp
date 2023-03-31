//
//  UserRepository.swift
//  NewsApp
//
//  Created by Andrew on 3/22/23.
//

import Foundation
import Swift
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

let db = Firestore.firestore()

struct UserRepository {
    public static func createUser (_ user: UserModel) -> String? {
        do {
            let ref = try db.collection("users").addDocument(from: user) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
            }
            return ref.documentID
        } catch {
            print(error)
            return nil
        }
    }
    
    public static func updateUser (_ user: UserModel, completion: @escaping () -> Void) {
        db.collection("users").document(user.id!).updateData([
            "nickname": user.nickname,
            "name": user.name,
            "about": user.about,
            "site": user.site,
            "photo": user.photo,
            "initialized": user.initialized
        ]) { _ in
            completion()
        }
    }
    
    public static func getUser (_ uid: String, completion: @escaping (_ user: UserModel?) -> Void) {
        db.collection("users").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else if let user = querySnapshot!.documents.first {
                    var data: UserModel? = nil
                    do {
                        data = try user.data(as: UserModel.self)
                    }
                    catch {
                        print(error)
                    }
                    completion(data)
                } else {
                    completion(nil)
                }
            }
    }
    
    public static func getSuggestions (_ search: String, completion: @escaping (_ users: [UserModel]) -> Void) {
        var query: Query? = db.collection("users")
            .limit(to: 24)
        if !search.isEmpty {
            query = db.collection("users")
                .whereField("name", isGreaterThanOrEqualTo: search)
                .whereField("name", isLessThan: search + "z")
                .limit(to: 24)
        }
        query!
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let result = querySnapshot!.documents.compactMap { document in
                        do {
                            return try document.data(as: UserModel.self)
                        } catch {
                            print("error when parsing following model \(error)")
                        }
                        return nil
                    }
                    completion(result)
                }}
    }
    
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
    
    public static func follow(_ uid: String, with userId: String, by: String) -> FollowModel? {
        var model = FollowModel(uid: uid)
        do {
            let ref = try db.collection("users").document(userId).collection("following")
                .addDocument(from: model) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    }
                }
            self.getUser(uid) { user in
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
        self.getUser(by) { user in
            if let userModel = user {
                var follower: FollowModel? = nil
                db.collection("users").document(userModel.id!).collection("followers").whereField("uid", isEqualTo: by)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else if let data = querySnapshot!.documents.first {
                            do {
                                follower = try data.data(as: FollowModel.self)
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                if let follower = follower {
                    db.collection("users").document(userModel.id!).collection("followers").document(follower.id!).delete()
                }
            }
        }
    }
}
