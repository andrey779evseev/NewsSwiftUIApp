//
//  SearchScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/27/23.
//

import SwiftUI

struct SearchScreen: View {
    init(
        auth: AuthService,
        namespace: Namespace.ID
    ) {
        self.auth = auth
        self._model = StateObject(wrappedValue: FollowViewModel(userId: auth.user!.id!, uid: auth.user!.uid))
        self.namespace = namespace
    }
    var namespace: Namespace.ID
    @ObservedObject var auth: AuthService
    @StateObject private var model: FollowViewModel
    @EnvironmentObject var router: Router
    @State private var search = ""
    @State private var tab = "Новости"
    @State private var profileUser: UserModel? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            Input(
                value: $search,
                placeholder: "Поиск",
                autocapitalization: false,
                rightIconPerform: {
                    router.go(.home)
                },
                leftIconPerform: {},
                rightIcon: {
                Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(.body)
            }, leftIcon: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.body)
            })
            .matchedGeometryEffect(id: "input", in: namespace)
            .onChange(of: search) { value in
                if tab == "Авторы" {
                    withAnimation {
                        model.getSuggestions(value)
                    }
                }
            }
            Tabs(items: ["Новости", "Авторы"], tab: $tab)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    if tab == "Новости" {
//                        HorizontalCard()
//                        HorizontalCard()
//                        HorizontalCard()
//                        HorizontalCard()
//                        HorizontalCard()
//                        HorizontalCard()
                    } else {
                        ForEach(model.suggestions, id: \.uid) { user in
                            let isFollowed = model.following.contains(where: { $0.uid == user.uid })
                            UserCard(user: user, isFollowed: isFollowed) {
                                if isFollowed {
                                    model.unfollow(user.uid)
                                } else {
                                    model.follow(user.uid)
                                }
                            }
                            .onTapGesture {
                                profileUser = user
                            }
                        }
                        .sheet(item: $profileUser) { user in
                            SearchProfileSheet(user: user, isFollowed: model.following.contains(where: { $0.uid == user.uid }))
                        }
                    }
                }
            }
        }
        .padding(.all, 24)
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen(auth: AuthService(), namespace: Namespace().wrappedValue)
    }
}
