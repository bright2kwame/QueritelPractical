//
//  NotificationUtil.swift
//  QueritelPractical
//
//  Created by Bright Ahedor on 24/06/2021.
//

import Foundation
import UserNotifications


class NotificationUtil {
    
    
    func scheduleNotification(title: String, body: String, dataId: String) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = "recording"
        content.userInfo = ["userPayload": dataId]
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

}
