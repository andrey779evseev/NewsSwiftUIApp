//
//  FollowModel.swift
//  NewsApp
//
//  Created by Andrew on 3/22/23.
//

import Foundation
import FirebaseFirestoreSwift


struct FollowModel: Codable {
    @DocumentID var id: String?
    var uid: String
    
    mutating func setId (_ id: String) {
        self.id = id
    }
}
