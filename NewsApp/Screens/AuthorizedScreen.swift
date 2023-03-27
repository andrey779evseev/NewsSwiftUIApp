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
//                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                case .notifications:
                    NotificationScreen()
                        .environmentObject(router)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                case .popular:
                    PopularScreen()
                        .environmentObject(router)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                case .latest:
                    LatestScreen()
                        .environmentObject(router)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                case .search:
                    SearchScreen(auth: auth, namespace: namespace)
                        .environmentObject(router)
                default:
                    VStack{
                        Text("Дэфолтная страница \(router.route.rawValue)")
                        Button {
                            auth.signOut()
                            router.go(.login)
                        } label: {
                            Text("Выйти")
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                if router.route != .search {                
                    NavBar()
                        .environmentObject(router)
                }
            }
            .onAppear {
                if router.route != .home && router.route != .bookmarks && router.route != .profile {
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
