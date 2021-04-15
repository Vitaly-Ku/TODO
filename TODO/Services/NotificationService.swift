//
//  NotificationService.swift
//  TODO
//
//  Created by Vit K on 02.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class NotificationService {
    
//    let vc = NewTaskViewController()

    func makeNotificationContent(str: String) -> UNNotificationContent {
        Main.instance.notifBadgeCount += 1
        let content = UNMutableNotificationContent()
        content.title = str
        content.badge = NSNumber(value: Main.instance.notifBadgeCount)
        return content
    }

    func makeIntervalNotificationTrigger(doub: Double) -> UNNotificationTrigger {
        let pickedTime = doub // подставить выбранное в picker время
        let curentTime = Date().timeIntervalSince1970 // текущее время
        let interval = pickedTime - curentTime // интервал в секундах между выбранным и текущим
        
        return UNTimeIntervalNotificationTrigger(
            timeInterval: interval,
            repeats: false
        )
    }

    func sendNotificationRequest(
        content: UNNotificationContent,
        trigger: UNNotificationTrigger) {
                
        let request = UNNotificationRequest(
            identifier: UUID().uuidString, // для формирования уникальных строк
            content: content,
            trigger: trigger
        )
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}


