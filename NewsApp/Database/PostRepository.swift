//
//  PostRepository.swift
//  NewsApp
//
//  Created by Andrew on 4/6/23.
//

import Foundation
import FirebaseFirestore


struct PostRepository {
    public static func createPost (_ model: PostModel, completion: @escaping () -> Void) {
        do {
            try db.collection("posts").addDocument(from: model) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
                completion()
            }
        } catch {
            print(error)
            completion()
        }
    }
    
    public static func createPost (_ model: PostModel) async -> Void {
        await withCheckedContinuation { continuation in
            createPost(model) { 
                continuation.resume()
            }
        }
    }
    
    public static func getPosts(by author: String, sort: GetPostsSorting, completion: @escaping (_ posts: [ExtendedPostModel]) -> Void) {
        var query = db.collection("posts")
            .whereField("userUid", isEqualTo: author)
        
        switch sort {
        case .popularity:
            query = query
                .order(by: "likesAmount", descending: true)
        case .time:
            query = query
                .order(by: "createdAt", descending: true)
        }
        query
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion([])
                } else {
                    let result = querySnapshot!.documents.compactMap { document in
                        do {
                            return try document.data(as: PostModel.self)
                        } catch {
                            print("error when parsing following model \(error)")
                        }
                        return nil
                    }
                    Task {
                        var extendedModels: [ExtendedPostModel] = []
                        for post in result {
                            let user = await UserRepository.getUser(post.userUid)
                            let model = ExtendedPostModel(base: post, user: user!)
                            extendedModels.append(model)
                        }
                        completion(extendedModels)
                    }
                }}
    }
    
    public static func getPosts(by author: String, sort: GetPostsSorting) async -> [ExtendedPostModel] {
        await withCheckedContinuation { continuation in
            getPosts(by: author, sort: sort) { posts in
                continuation.resume(returning: posts)
            }
        }
    }
    
    public static func getFeed (for userId: String, with limit: Int, sort: GetPostsSorting) async -> [ExtendedPostModel] {
        let followings = await FollowRepository.getFollowing(userId).map { following in following.uid }
        do {
            let snapshot = try await db.collection("posts")
                .whereField("userUid", in: followings)
                .order(by: sort == .popularity ? "likesAmount" : "createdAt", descending: true)
                .limit(to: limit)
                .getDocuments()
            let result = snapshot.documents.compactMap { document in
                do {
                    return try document.data(as: PostModel.self)
                } catch {
                    print("error when parsing following model \(error)")
                    return nil
                }
            }
            var extendedModels: [ExtendedPostModel] = []
            for post in result {
                let user = await UserRepository.getUser(post.userUid)
                let model = ExtendedPostModel(base: post, user: user!)
                extendedModels.append(model)
            }
            return extendedModels
        } catch {
            print("Error while getting popular \(error.localizedDescription)")
            return []
        }
    }
    
    public enum GetPostsSorting {
        case popularity
        case time
    }
}