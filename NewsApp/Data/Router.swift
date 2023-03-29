//
//  Router.swift
//  RecipesApp
//
//  Created by Andrew on 1/21/23.
//

import Foundation
import SwiftUI


final class Router: ObservableObject {
    @Published var route: Routes = .login
    
    func go(_ newRoute: Routes) {
        withAnimation {
            route = newRoute
        }
    }
    
    enum Routes: String {
        // MARK: auth
        case login
        case registration
        
        // MARK: home
        case home
        case latest
        case popular
        case notifications
        
        // MARK: search
        case search
        
        // MARK: bookmarks
        case bookmarks
        
        // MARK: profile
        case profile
        
        // MARK: settings
        case settings
    }
}
