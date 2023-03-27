//
//  VerticalCard.swift
//  NewsApp
//
//  Created by Andrew on 3/25/23.
//

import SwiftUI

struct VerticalCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RemoteImage(url:  "https://images.unsplash.com/photo-1451187580459-43490279c0fa?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2372&q=80", width: .max, height: .constant(183))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.bottom, 8)
            Text("Lorem ipsum lorem ipsum lorem ipsum")
                .poppinsFont(.footnote)
                .foregroundColor(.dark)
                .padding(.bottom, 4)
            CardInfo()
                
        }
        .padding(.all, 8)
    }
}

struct VerticalCard_Previews: PreviewProvider {
    static var previews: some View {
        VerticalCard()
    }
}
