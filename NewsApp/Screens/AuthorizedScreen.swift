//
//  AuthorizedScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/22/23.
//

import SwiftUI

struct AuthorizedScreen: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var auth: AuthService
    @Namespace private var namespace
      
    @State private var page: Router.Routes = .home
    
    var body: some View {
        if !(auth.user?.initialized ?? true) {
            AccountInitialization()
                .environmentObject(router)
                .environmentObject(auth)
        } else {
            VStack(spacing: 0) {
                switch router.route {
                case .home:
                    HomeScreen(namespace: namespace)
                        .environmentObject(router)
                        .environmentObject(auth)
                case .notifications:
                    NotificationScreen()
                        .environmentObject(router)
                        .transition(.move(edge: .trailing))
                case .popular:
                    PopularScreen()
                        .environmentObject(router)
                        .environmentObject(auth)
                        .transition(.move(edge: .trailing))
                case .latest:
                    LatestScreen()
                        .environmentObject(router)
                        .environmentObject(auth)
                        .transition(.move(edge: .trailing))
                case .search:
                    SearchScreen(auth: auth, namespace: namespace)
                        .environmentObject(router)
                case .bookmarks:
                    BookmarkScreen()
                case .profile:
                    ProfileScreen()
                        .environmentObject(router)
                        .environmentObject(auth)
                case .settings:
                    SettingsScreen()
                        .environmentObject(auth)
                        .environmentObject(router)
                        .transition(.move(edge: .trailing))
                default:
                    VStack{}
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                if router.route != .search && router.route != .settings {                
                    NavBar()
                        .environmentObject(router)
                }
            }
            .onAppear {
                if router.route == .login || router.route == .registration {
                    router.go(.home)
                }
            }
        }
    }
    enum PagesEnum: String {
        case home
        case bookmarks
        case profile
    }
}

struct AuthorizedScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizedScreen()
            .environmentObject(Router())
            .environmentObject(AuthService())
    }
}
