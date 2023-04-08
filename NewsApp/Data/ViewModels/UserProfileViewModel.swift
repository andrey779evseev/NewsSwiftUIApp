//
//  UserProfileViewModel.swift
//  NewsApp
//
//  Created by Andrew on 4/8/23.
//

import Foundation


class UserProfileViewModel: ObservableObject {
    @Published var posts: [ExtendedPostModel] = []
    @Published var tab = "Популярные"
    @Published var isLoading = false
    
    func getPosts (_ userUid: String) async {
        DispatchQueue.main.sync {
            isLoading = true
        }
        let sort: PostRepository.GetPostsSorting
        if tab == "Популярные" {
            sort = .popularity
        } else {
            sort = .time
        }
        let res = await PostRepository.getPosts(by: userUid, sort: sort)
        DispatchQueue.main.sync {
            self.posts = res
            isLoading = false
        }
    }
}
