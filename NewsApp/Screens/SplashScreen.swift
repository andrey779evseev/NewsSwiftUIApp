//
//  SplashScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/22/23.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack {
            Spacer()
            Image("Logo")
                .resizable()
                .frame(width: 300, height: 300)
            Spacer()
            Spacer()
            Text("Новости \n Приднестровья")
                .poppinsFont(.title)
                .foregroundColor(.body)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
