//
//  UserModel.swift
//  NewsApp
//
//  Created by Andrew on 3/22/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift


struct UserModel: Codable, Identifiable {
    @DocumentID var id: String?
    var email: String
    var name: String
    var nickname: String
    var photo: String
    var about: String
    var site: String
    var uid: String
    var initialized: Bool
    
    static func fromSession(_ session: User) -> Self {
        Self(
            email: session.email!,
            name: "",
            nickname: "",
            photo: "",
            about: "",
            site: "",
            uid: session.uid,
            initialized: false
        )
    }
    
    mutating func setId (_ id: String) {
        self.id = id
    }
    
    mutating func initialize (
        nickname: String,
        name: String,
        about: String,
        site: String,
        photo: String
    ) {
        self.nickname = nickname
        self.name = name
        self.about = about
        self.site = site
        self.photo = photo
        self.initialized = true
    }
}
