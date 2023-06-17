//
//  SplashScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/22/23.
//

import SwiftUI

struct SplashScreen: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
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
        .background(isDarkMode ? Color.darkmodeBackground : Color.white)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
