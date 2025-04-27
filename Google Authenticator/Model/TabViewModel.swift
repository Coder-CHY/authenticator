//
//  TabViewModel.swift
//  Google Authenticator
//
//

import Foundation
import SwiftUI

struct TabViewModel: Identifiable {
    var id = UUID()
    var title: String
    var headline: String
    var image: String
}

class TabViewModelStore: ObservableObject {
    @Published var tabViewModelData: [TabViewModel] = [
        TabViewModel(title: "Stronger security with\nGoogle Authenticator", headline: "Get verification for all your accounts use\n2-Step Verification", image: "icon_2"),
        TabViewModel(title: "Simple setup using your camera", headline: "To setup an account, you'll scan the QR code in\nyour 2-Step Verification settings for Google or any\nthird-party service", image: "icon_4"),
        TabViewModel(title: "A unique code used to sign in", headline: "When using 2-Step Verification, you'll enter your\npassword and a code from this app", image: "icon_1"),
        TabViewModel(title: "Cloud syncing", headline: "Google Authenticator can save your codes to your\nGoogle Account", image: "icon_3")
    ]
}
