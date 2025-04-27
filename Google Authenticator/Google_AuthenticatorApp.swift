//
//  Google_AuthenticatorApp.swift
//  Google Authenticator
//
//

import SwiftUI
import GoogleSignIn

@main
struct Google_AuthenticatorApp: App {
    @StateObject var authViewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            AuthenticationHandler()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}

struct AuthenticationHandler: View {
    @ObservedObject var authViewModel = AuthViewModel()
    var body: some View {
        Group {
            if authViewModel.isUserLoggedIn {
                HomeView()
            } else {
                OnboardingView()
            }
        }
        .onAppear() {
            authViewModel.getUserStatus()
        }
    }
}
