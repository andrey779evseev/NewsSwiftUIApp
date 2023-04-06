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
                .order(by: "likesAmount")
        case .time:
            query = query
                .order(by: "createdAt")
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
    
    public enum GetPostsSorting {
        case popularity
        case time
    }
}
