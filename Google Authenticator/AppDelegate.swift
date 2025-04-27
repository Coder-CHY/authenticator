//
//  AppDelegate.swift
//  Google Authenticator
//
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if url.scheme == "myapp" {
            NotificationCenter.default.post(name: Notification.Name("NavigateToHome"), object: nil)
            return true
        }
        return false
    }
}
