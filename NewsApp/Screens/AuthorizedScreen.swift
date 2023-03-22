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
    
    var body: some View {
        if !(auth.user?.initialized ?? false) {
            AccountInitialization()
                .environmentObject(router)
                .environmentObject(auth)
        } else {
            VStack{
                Text("Главная страница")
                Button {
                    auth.signOut()
                    router.go(.login)
                } label: {
                    Text("Выйти")
                }
            }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
        }
    }
}

struct AuthorizedScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizedScreen()
    }
}
