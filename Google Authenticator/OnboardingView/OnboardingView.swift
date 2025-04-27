//
//  OnboardingView.swift
//  Google Authenticator
//
//

import SwiftUI
import GoogleSignIn

struct OnboardingView: View {
    @StateObject var tabViewModel = TabViewModelStore()
    @StateObject var authViewModel = AuthViewModel()
    @State var currentPage = 0
    @State private var isAnimating: Bool = false
    @State var openNextView = false
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(tabViewModel.tabViewModelData) { index in
                    Onboarding(openNextView: $openNextView, tabViewModel: index)
                        .tag(tabViewModel.tabViewModelData.firstIndex(where: {$0.id == index.id}) ?? 0)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $openNextView) {
                HomeView()
            }
        }
    }
}

#Preview {
    OnboardingView(tabViewModel: TabViewModelStore())
}

struct Onboarding: View {
    @Binding var openNextView: Bool
    var tabViewModel: TabViewModel
    @State private var err : String = ""
    @StateObject var authViewModel = AuthViewModel()
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Image(tabViewModel.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 150)
                }
                Spacer()
                    .frame(height: 10)
                VStack(alignment: .leading,spacing: 8) {
                    Text(tabViewModel.title)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Text(tabViewModel.headline)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .padding()
                }
                Spacer()
                    .frame(height: 200)
                VStack {
                    Button(action: {
                        Task {
                            do {
                                await authViewModel.signIn()
                                openNextView = true
                            } catch {
                                print("Error signing in: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        Text("Get started")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundStyle(Color("button_text_color"))
                    }
                    .frame(width: UIScreen.main.bounds.width/1.1, height: 49)
                    .background(Color("button_background_color"))
                    .cornerRadius(30)
                }
                .padding(.vertical, 60)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primary.opacity(0.93))
    }
}
