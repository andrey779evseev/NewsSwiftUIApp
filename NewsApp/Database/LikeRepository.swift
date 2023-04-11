//
//  LikeRepository.swift
//  NewsApp
//
//  Created by Andrew on 4/7/23.
//

import Foundation
import FirebaseFirestore


struct LikeRepository {
    public static func isLiked(_ postId: String, by userUid: String, completion: @escaping (_ liked: LikeModel?) -> Void) {
        db.collection("posts").document(postId).collection("likes").whereField("uid", isEqualTo: userUid).getDocuments { snapshot, error in
            if let error = error {
                print("Error while reading likes count from post: \(error.localizedDescription)")
                completion(nil)
            } else if let document = snapshot?.documents.first {
                do {
                    let data = try document.data(as: LikeModel.self)
                    completion(data)
                } catch {
                    print("Error while parsing post: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    public static func isLiked(_ postId: String, by userUid: String) async -> LikeModel? {
        await withCheckedContinuation { continuation in
            isLiked(postId, by: userUid) { liked in
                continuation.resume(returning: liked)
            }
        }
    }
    
    public static func like(_ post: ExtendedPostModel, by userUid: String) async -> LikeModel? {
        var model = LikeModel(uid: userUid)
        do {
            try await db.collection("posts").document(post.id!).updateData([
                "likesAmount": FieldValue.increment(Int64(1))
            ])
            let ref = try db.collection("posts").document(post.id!).collection("likes").addDocument(from: model)
            model.setId(ref.documentID)
            
            await NotificationRepository.saveNotification(from: userUid, postName: post.title, to: post.userUid, type: .like)
            
            return model
        } catch {
            print("Error while liking the post: \(error.localizedDescription)")
            return nil
        }
    }
    
    public static func unlike(_ likeId: String, in postId: String, completion: @escaping () -> Void) {
        db.collection("posts").document(postId).updateData([
            "likesAmount": FieldValue.increment(Int64(-1))
        ]) { _ in
            db.collection("posts").document(postId).collection("likes").document(likeId).delete()
            completion()
        }
    }
    
    public static func unlike(_ likeId: String, in postId: String) async {
        await withCheckedContinuation { continuation in
            unlike(likeId, in: postId) {
                continuation.resume()
            }
        }
    }
}
