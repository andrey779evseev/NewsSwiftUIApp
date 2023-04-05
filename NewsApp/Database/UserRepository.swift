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
    
    public static func getUser (_ uid: String) async -> UserModel? {
        await withCheckedContinuation { continuation in
            getUser(uid) { user in
                continuation.resume(returning: user)
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
}
