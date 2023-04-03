//
//  Shadow.swift
//  NewsApp
//
//  Created by Andrew on 4/1/23.
//

import SwiftUI


extension View {
    func barShadow() -> some View {
        self
            .background(Color.white
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: -2)
                .mask(Rectangle().padding(.top, -20))
            )
    }
    
    func cardShadow() -> some View {
        self
            .background(Color.white
                .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 0)
            )
    }
}
