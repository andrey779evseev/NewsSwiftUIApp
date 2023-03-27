//
//  NotificationScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/26/23.
//

import SwiftUI

struct NotificationScreen: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationTitle(text: "Уведомления") {
                router.go(.home)
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Сегодня, Апрель 22")
                        .poppinsFont(.footnoteBold)
                    
                    NotificationCard(type: .post)
                    NotificationCard(type: .follow)
                    NotificationCard(type: .comment)
                    
                    Text("Вчера, Апрель 21")
                        .poppinsFont(.footnoteBold)
                    
                    NotificationCard(type: .like)
                    NotificationCard(type: .follow)
                    NotificationCard(type: .comment)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.top, .leading, .trailing], 24)
    }
}

struct NotificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationScreen()
    }
}
