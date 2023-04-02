//
//  NonAuthorizedScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/21/23.
//

import SwiftUI

struct NonAuthorizedScreen: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var auth: AuthService
    
    var body: some View {
        switch router.route {
        case .login:
            LoginScreen()
                .transition(.move(edge: .leading))
                .environmentObject(router)
                .environmentObject(auth)
        default:
            RegistrationScreen()
                .transition(.move(edge: .trailing))
                .environmentObject(router)
                .environmentObject(auth)
        }
    }
    
}

struct NonAuthorizedScreen_Previews: PreviewProvider {
    static var previews: some View {
        NonAuthorizedScreen()
    }
}
