//
//  PostModel.swift
//  NewsApp
//
//  Created by Andrew on 4/6/23.
//

import Foundation
import FirebaseFirestoreSwift

protocol BasePostModel {
    var id: String? { get set }
    var image: String { get set }
    var title: String { get set }
    var text: String { get set }
    var userUid: String { get set }
    var createdAt: Date { get set }
    var likesAmount: Int { get set }
}


struct PostModel: Codable, Identifiable {
    init(id: String? = nil, image: String, title: String, text: String, userUid: String) {
        self.id = id
        self.image = image
        self.title = title
        self.text = text
        self.userUid = userUid
        self.createdAt = Date()
        self.likesAmount = 0
    }
    
    @DocumentID var id: String?
    var image: String
    var title: String
    var text: String
    var userUid: String
    var createdAt: Date
    var likesAmount: Int
}

struct ExtendedPostModel: BasePostModel, Identifiable {
    init(base: PostModel, user: UserModel) {
        self.id = base.id
        self.image = base.image
        self.title = base.title
        self.text = base.text
        self.userUid = base.userUid
        self.createdAt = base.createdAt
        self.likesAmount = base.likesAmount
        self.user = user
    }
    
    @DocumentID var id: String?
    var image: String
    var title: String
    var text: String
    var userUid: String
    var createdAt: Date
    var likesAmount: Int
    var user: UserModel
}


let TestExtendedPostModel = ExtendedPostModel(base:  PostModel(image: "https://images.coolhouseplans.com/plans/44207/44207-b600.jpg", title: "Lorem impsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum", text: "Lorem impsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum", userUid: "s94LWJ8p77VNR7ykIuO5FEjOIEB2"), user: TestUserModel
)
