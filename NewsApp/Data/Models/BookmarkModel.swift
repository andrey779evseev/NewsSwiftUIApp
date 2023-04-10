//
//  BookmarkModel.swift
//  NewsApp
//
//  Created by Andrew on 4/10/23.
//

import Foundation
import FirebaseFirestoreSwift


struct BookmarkModel: Codable, Identifiable {
    @DocumentID var id: String?
    var postId: String
    var title: String
    
    mutating func setId (_ id: String) {
        self.id = id
    }
}
