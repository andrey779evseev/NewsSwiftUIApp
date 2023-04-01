//
//  VerticalCard.swift
//  NewsApp
//
//  Created by Andrew on 3/25/23.
//

import SwiftUI

struct VerticalCard: View {
    @State private var isShowPost = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RemoteImage(url:  "https://images.coolhouseplans.com/plans/44207/44207-b600.jpg", width: .max, height: .constant(183))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.bottom, 8)
            Text("Lorem ipsum lorem ipsum lorem ipsum")
                .poppinsFont(.footnote)
                .foregroundColor(.dark)
                .padding(.bottom, 4)
            CardInfo()
                
        }
        .padding(.all, 8)
        .onTapGesture {
            isShowPost = true
        }
        .sheet(isPresented: $isShowPost) {
            PostSheet()
        }
    }
}

struct VerticalCard_Previews: PreviewProvider {
    static var previews: some View {
        VerticalCard()
    }
}
