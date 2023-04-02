//
//  AccountInitialization.swift
//  NewsApp
//
//  Created by Andrew on 3/22/23.
//

import SwiftUI

struct AccountInitialization: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var auth: AuthService
    @State var step: Step = .first
    
    
    var body: some View {
        switch step {
        case .first:
            InitializationFirstStep(auth: auth) {
                withAnimation {
                    step = .second
                }
            }
                .transition(.move(edge: .leading))
                .environmentObject(auth)
        case .second:
            InitializationSecondStep() {
                withAnimation {
                    step = .first
                }
            }
                .transition(.move(edge: .trailing))
                .environmentObject(router)
                .environmentObject(auth)
        }
    }
    
    enum Step {
        case first
        case second
    }
}

struct AccountInitialization_Previews: PreviewProvider {
    static var previews: some View {
        AccountInitialization()
    }
}
