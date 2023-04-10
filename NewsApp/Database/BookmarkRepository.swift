//
//  BookmarkRepository.swift
//  NewsApp
//
//  Created by Andrew on 4/10/23.
//

import Foundation
import FirebaseFirestore


struct BookmarkRepository {
    public static func saveBookmark(_ model: BookmarkModel, for userId: String) -> BookmarkModel? {
        do {
            let ref = try db.collection("users").document(userId).collection("bookmarks").addDocument(from: model)
            var model = model
            model.setId(ref.documentID)
            return model
        } catch {
            print("Error while saving bookmark: \(error.localizedDescription)")
            return nil
        }
    }
    
    public static func removeBookmark(_ bookmarkId: String, from userId: String) async {
        do {
            try await db.collection("users").document(userId).collection("bookmarks").document(bookmarkId).delete()
        } catch {
            print("Error while deleting bookmark: \(error.localizedDescription)")
        }
    }
    
    public static func getBookmarks(for userId: String, search: String) async -> [ExtendedPostModel] {
        do {
            var query: Query = db.collection("users").document(userId).collection("bookmarks")
            if !search.isEmpty {
                query = query
                    .whereField("title", isGreaterThanOrEqualTo: search)
                    .whereField("title", isLessThan: search + "z")
            }
            let snapshot = try await query.getDocuments()
            let result = snapshot.documents.compactMap { document in
                do {
                    return try document.data(as: BookmarkModel.self)
                } catch {
                    print("error when parsing following model \(error)")
                }
                return nil
            }
            var extendedModels: [ExtendedPostModel] = []
            for document in result {
                let post = await PostRepository.getPost(by: document.postId)
                extendedModels.append(post!)
            }
            return extendedModels
        } catch {
            print("Error while getting bookmarks: \(error.localizedDescription)")
            return []
        }
    }
    
    public static func isInBookmarks (_ postId: String, for userId: String) async -> BookmarkModel? {
        do {
            let snapshot = try await db.collection("users").document(userId).collection("bookmarks").whereField("postId", isEqualTo: postId).getDocuments()
            if let document = snapshot.documents.first {
                return try document.data(as: BookmarkModel.self)
            } else {
                return nil
            }
        } catch {
            print("Error while getting is in bookmarks: \(error.localizedDescription)")
            return nil
        }
    }
}
