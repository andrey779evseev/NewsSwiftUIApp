//
//  HomeScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/23/23.
//

import SwiftUI

struct HomeScreen: View {
    var namespace: Namespace.ID
    @EnvironmentObject var router: Router
    @State private var search = ""
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                HStack {
                    Image("Logo")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("News")
                        .poppinsFont(.title3)
                        .foregroundColor(.dark)
                }
                Spacer()
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .shadow(color: .dark.opacity(0.15), radius: 10)
                    .overlay(
                        Image(systemName: "bell")
                            .resizable()
                            .frame(width: 18, height: 21.5)
                    )
                    .onTapGesture {
                        router.go(.notifications)
                    }
            }
            .padding(.bottom, 26)
            
            Input(
                value: $search,
                placeholder: "Поиск",
                rightIconPerform: {},
                leftIconPerform: {},
                rightIcon: {
                Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 20))
                        .foregroundColor(.body)
            }, leftIcon: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.body)
            })
            .onTapGesture {
                router.go(.search)
            }
            .matchedGeometryEffect(id: "input", in: namespace)
            
            
            ScrollView(showsIndicators: false) {
                HStack {
                    Text("Популярные")
                        .poppinsFont(.footnoteBold)
                        .foregroundColor(.dark)
                    Spacer()
                    Button {
                         router.go(.popular)
                    } label: {
                        Text("Смотреть все")
                            .poppinsFont(.caption)
                            .foregroundColor(.body)
                    }
                }
                
                VerticalCard()
                
                HStack {
                    Text("Последние")
                        .poppinsFont(.footnoteBold)
                        .foregroundColor(.dark)
                    Spacer()
                    Button {
                         router.go(.latest)
                    } label: {
                        Text("Смотреть все")
                            .poppinsFont(.caption)
                            .foregroundColor(.body)
                    }
                }
                
                HorizontalCard()
                HorizontalCard()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.top, .leading, .trailing], 24)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(namespace: Namespace().wrappedValue)
    }
}
