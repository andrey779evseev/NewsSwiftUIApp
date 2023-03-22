//
//  Storage.swift
//  NewsApp
//
//  Created by Andrew on 3/22/23.
//

import Foundation
import FirebaseStorage
import SwiftUI

let storage = Storage.storage()
let storageRef = storage.reference()


struct FirebaseStorage {
    public static func uploadAvatar (_ data: Data, with uid: String, completion: @escaping (_ url: URL?) -> Void) {
        let filename = "avatars/\(uid)/\(UUID().uuidString).jpg"
        let ref = storageRef.child(filename)
        
        let md = StorageMetadata()
        md.contentType = "image/jpeg"

        ref.putData(data, metadata: md) { (metadata, error) in
            if error == nil {
                ref.downloadURL(completion: { (url, error) in
                    completion(url)
                })
            } else {
                print("error \(String(describing: error))")
            }
            completion(nil)
        }
            
    }
}
