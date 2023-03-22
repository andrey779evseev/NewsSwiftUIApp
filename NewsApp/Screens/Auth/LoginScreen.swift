//
//  LoginScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/21/23.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var auth: AuthService

    var body: some View {
        AuthForm(isLogin: true)
            .environmentObject(router)
            .environmentObject(auth)
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
