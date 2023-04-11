//
//  CommentRepository.swift
//  NewsApp
//
//  Created by Andrew on 4/7/23.
//

import Foundation


struct CommentRepository {
    public static func count (by postId: String) async -> Int {
        let countQuery = db.collection("posts").document(postId).collection("comments").count
        do {
            let snapshot = try await countQuery.getAggregation(source: .server)
            return snapshot.count.intValue
        } catch {
            print("Error while getting count of comments \(error)")
            return 0
        }
    }
    
    public static func getComments(_ postId: String, completion: @escaping (_ comments: [ExtendedCommentModel]) -> Void) {
        db.collection("posts").document(postId).collection("comments").getDocuments { snapshot, error in
            if let error = error {
                print("Error while getting comments \(error.localizedDescription)")
                completion([])
            } else if let snapshot = snapshot {
                let result = snapshot.documents.compactMap { document in
                    do {
                        return try document.data(as: CommentModel.self)
                    } catch {
                        print("error when parsing following model \(error)")
                    }
                    return nil
                }
                Task {
                    var extendedModels: [ExtendedCommentModel] = []
                    for document in result {
                        let user = await UserRepository.getUser(document.userUid)
                        let model = ExtendedCommentModel(model: document, user: user!)
                        extendedModels.append(model)
                    }
                    completion(extendedModels)
                }
            } else {
                completion([])
            }
        }
    }
    
    public static func getComments(_ postId: String) async -> [ExtendedCommentModel] {
        await withCheckedContinuation { continuation in
            getComments(postId) { comments in
                continuation.resume(returning: comments)
            }
        }
    }
    
    public static func addComment(_ model: CommentModel, for post: ExtendedPostModel) async -> CommentModel? {
        do {
            let ref = try db.collection("posts").document(post.id!).collection("comments").addDocument(from: model)
            var model = model
            model.setId(ref.documentID)
            
            await NotificationRepository.saveNotification(from: model.userUid, postName: post.title, to: post.userUid, type: .comment)
            
            return model
        } catch {
            print("Error while adding comment: \(error.localizedDescription)")
            return nil
        }
        
    }
}
