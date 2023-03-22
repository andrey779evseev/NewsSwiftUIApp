//
//  ContentView.swift
//  NewsApp
//
//  Created by Andrew on 3/20/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var auth = AuthService()
    @StateObject var router = Router()
    
    var body: some View {
        Group {
            if !auth.isInitialized {
                SplashScreen()
                    .transition(.opacity)
            }
            else if !auth.isAuthenticated {
                NonAuthorizedScreen()
                    .environmentObject(router)
                    .environmentObject(auth)
            } else {
                AuthorizedScreen()
                    .environmentObject(router)
                    .environmentObject(auth)
            }
        }.onAppear {
            auth.listenToAuthState()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
