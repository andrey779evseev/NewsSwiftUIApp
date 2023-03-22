//
//  RegistrationScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/21/23.
//

import SwiftUI

struct RegistrationScreen: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var auth: AuthService
    
    var body: some View {
        AuthForm(isLogin: false)
            .environmentObject(router)
            .environmentObject(auth)
    }
}

struct RegistrationScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationScreen()
    }
}
