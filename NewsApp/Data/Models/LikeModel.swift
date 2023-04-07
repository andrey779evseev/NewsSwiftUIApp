//
//  LikeModel.swift
//  NewsApp
//
//  Created by Andrew on 4/7/23.
//

import Foundation


import FirebaseFirestoreSwift


struct LikeModel: Codable {
    @DocumentID var id: String?
    var uid: String
    
    mutating func setId (_ id: String) {
        self.id = id
    }
}
