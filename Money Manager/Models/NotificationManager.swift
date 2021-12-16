//
//  NotificationManager.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 16.12.2021.
//

import Foundation
import UserNotifications

struct NotificationManager {
    func notification() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Money Manager"
        notificationContent.body = "Не забудь добавить свои расходы за сегодня!"
        notificationContent.badge = NSNumber(value: 1)
        notificationContent.sound = .default
        
        var datComp = DateComponents()
        datComp.hour = 20
        datComp.minute = 10
        let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
        let request = UNNotificationRequest(identifier: "ID", content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
}
