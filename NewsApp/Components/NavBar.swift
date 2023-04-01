//
//  NavBar.swift
//  NewsApp
//
//  Created by Andrew on 3/25/23.
//

import SwiftUI

struct NavBar: View {
    @EnvironmentObject var router: Router
    
    var isHome: Bool {
        router.route == .home ||
        router.route == .notifications ||
        router.route == .latest ||
        router.route == .popular
    }
    
    var isSearch: Bool {
        router.route == .search
    }
    
    var isBookmarks: Bool {
        router.route == .bookmarks
    }
    
    var isProfile: Bool {
        router.route == .profile
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Image(systemName: isHome ? "house.fill" : "house")
                .font(.system(size: 20))
                .foregroundColor(isHome ? .blue : .body)
                .onTapGesture {
                    router.go(.home)
                }
            Spacer()
            Image(systemName: isSearch ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                .font(.system(size: 20))
                .foregroundColor(isSearch ? .blue : .body)
                .onTapGesture {
                    router.go(.search)
                }
            Spacer()
            Image(systemName: isBookmarks ? "bookmark.fill" : "bookmark")
                .font(.system(size: 20))
                .foregroundColor(isBookmarks ? .blue : .body)
                .onTapGesture {
                    router.go(.bookmarks)
                }
            Spacer()
            Image(systemName: isProfile ? "person.crop.circle.fill" : "person.crop.circle")
                .font(.system(size: 20))
                .foregroundColor(isProfile ? .blue : .body)
                .onTapGesture {
                    router.go(.profile)
                }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .barShadow()
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar()
            .environmentObject(Router())
    }
}
