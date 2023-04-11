//
//  NotificationScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/26/23.
//

import SwiftUI

struct NotificationScreen: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var auth: AuthService
    
    @State private var notifications: [Date: [ExtendedNotificationModel]] = [:]
    @State private var isLoading = true
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationTitle(text: "Уведомления") {
                router.go(.home)
            }
            
            if isLoading {
                Spacer()
                ProgressView()
                    .tint(.blue)
                    .scaleEffect(3)
                Spacer()
            } else if notifications.isEmpty {
                Spacer()
                Text("У вас еще нет уведомлений")
                    .poppinsFont(.title2)
                    .foregroundColor(.body)
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ForEach(Array(notifications.keys), id: \.self) { day in
                            Text(fullDate(day))
                                .poppinsFont(.footnoteBold)
                                .foregroundColor(Color.dark)
                            
                            ForEach(notifications[day]!.sorted { $0.createdAt < $1.createdAt }) { notification in
                                NotificationCard(notification: notification)
                                    .environmentObject(auth)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.top, .leading, .trailing], 24)
        .task {
            let arr = await NotificationRepository.getNotifications(auth.user!.id!)
            self.notifications = arr.groupBy(by: [.day], for: \.createdAt)
            isLoading = false
        }
    }
}

struct NotificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationScreen()
    }
}
