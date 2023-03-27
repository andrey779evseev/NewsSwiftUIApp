//
//  LatestScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/27/23.
//

import SwiftUI

struct LatestScreen: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationTitle(text: "Последние") {
                router.go(.home)
            }
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    VerticalCard()
                    VerticalCard()
                    VerticalCard()
                }
            }
        }
        .padding([.top, .leading, .trailing], 24)
    }
}

struct LatestScreen_Previews: PreviewProvider {
    static var previews: some View {
        LatestScreen()
    }
}
