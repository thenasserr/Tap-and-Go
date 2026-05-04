//
//  NotificationService.swift
//  Tap and Go
//
//  Created by Ibrahim Nasser Ibrahim on 02/05/2026.
//

import Foundation
import UserNotifications

// MARK: - Notification Service

protocol NotificationService {
    
    func requestAuthorization()
    func showOrderStatusChanged(
        orderID: String,
        status: OrderStatus
    )
}

// MARK: - Default Notification Service

final class DefaultNotificationService: NotificationService {
    
    private let center = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        center.requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            
            if let error {
                print("Notification permission error:", error.localizedDescription)
                return
            }
            
            print("Notification permission granted:", granted)
        }
    }
    
    func showOrderStatusChanged(
        orderID: String,
        status: OrderStatus
    ) {
        let content = UNMutableNotificationContent()
        content.title = "Order Update"
        content.body = message(
            orderID: orderID,
            status: status
        )
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "order-\(orderID)-\(status.rawValue)",
            content: content,
            trigger: nil
        )
        
        center.add(request) { error in
            if let error {
                print("Show notification error:", error.localizedDescription)
            }
        }
    }
}

// MARK: - Message

private extension DefaultNotificationService {
    
    func message(
        orderID: String,
        status: OrderStatus
    ) -> String {
        switch status {
        case .pendingPayment:
            return "Your order is waiting for payment."
        case .pending:
            return "Your order has been received."
        case .confirmed:
            return "Your order has been confirmed."
        case .preparing:
            return "Your food is being prepared."
        case .delivering:
            return "Your order is on the way."
        case .completed:
            return "Your order has been delivered. Enjoy your meal!"
        case .cancelled:
            return "Your order has been cancelled."
        }
    }
}
