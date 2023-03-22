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
    
    enum Routes {
        case login
        case registration
        case home
    }
}
