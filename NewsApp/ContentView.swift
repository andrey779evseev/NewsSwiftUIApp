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
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isTouchedDarkMode") private var isTouchedDarkMode = false
    @Environment(\.colorScheme) var colorScheme

    
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
        }
        .background(isDarkMode ? Color.darkmodeBackground : Color.white)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear {
            auth.listenToAuthState()
            if !isTouchedDarkMode {
                isDarkMode = colorScheme == .dark
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
