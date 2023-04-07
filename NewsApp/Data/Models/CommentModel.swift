//
//  CommentModel.swift
//  NewsApp
//
//  Created by Andrew on 4/7/23.
//

import Foundation
import FirebaseFirestoreSwift

struct CommentModel: Codable, Identifiable {
    @DocumentID var id: String?
    var text: String
    var userUid: String
    var createdAt: Date
    
    mutating func setId(_ id: String) {
        self.id = id
    }
}


struct ExtendedCommentModel: Identifiable {
    internal init(model: CommentModel, user: UserModel) {
        self.id = model.id!
        self.text = model.text
        self.userUid = model.userUid
        self.createdAt = model.createdAt
        self.user = user
    }
    
    var id: String
    var text: String
    var userUid: String
    var user: UserModel
    var createdAt: Date
}


let TestExtendedCommentModel = ExtendedCommentModel(model: CommentModel(id: "", text: "Lorem ipsum lorem ipsum lorem ipsumlorem ipsumlorem ipsum ", userUid: "s94LWJ8p77VNR7ykIuO5FEjOIEB2", createdAt: Date.now.addingTimeInterval(-15000)), user: TestUserModel)
