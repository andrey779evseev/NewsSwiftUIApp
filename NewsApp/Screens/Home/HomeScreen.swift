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
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                HStack {
                    Image("Logo")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("News")
                        .poppinsFont(.title3Bold)
                        .foregroundColor(.dark)
                }
                Spacer()
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .shadow(color: .dark.opacity(0.15), radius: 10)
                    .overlay(
                        Image(systemName: "bell")
                            .font(.system(size: 20))
                            .foregroundColor(.dark)
                    )
                    .onTapGesture {
                        router.go(.notifications)
                    }
            }
            .padding(.bottom, 26)
            
            HStack(spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.body)
                    .padding(.trailing, 10)
                
                Text("Поиск")
                    .poppinsFont(.caption)
                    .foregroundColor(.placeholder)
                
                Spacer()
                
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundColor(.body)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.body))
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
