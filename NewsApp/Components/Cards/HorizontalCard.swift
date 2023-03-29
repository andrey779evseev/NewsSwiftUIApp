//
//  HorizontalCard.swift
//  NewsApp
//
//  Created by Andrew on 3/25/23.
//

import SwiftUI

struct HorizontalCard: View {
    var body: some View {
        HStack(spacing: 4) {
            RemoteImage(url: "https://images.coolhouseplans.com/plans/44207/44207-b600.jpg", width: .constant(96), height: .constant(96))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            VStack(spacing: 4) {
                Text("Lorem impsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum")
                    .lineLimit(2)
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                CardInfo()
            }
        }
        .padding(.all, 8)
    }
}

struct HorizontalCard_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalCard()
    }
}
