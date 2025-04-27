//
//  HomeView.swift
//  Google Authenticator
//
//

import SwiftUI
import GoogleSignIn
import GoogleDriveClient

struct HomeView: View {
    @State var searchText = ""
    @State var presentSideMenu = false
    @State var isOverLayOpened = false
    @State var showNextView = false
    @State var showScanCodeView = false
    @State var showGoogleDrive = false
    @StateObject var authViewModel = AuthViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        TextField("", text: $searchText)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Search...").foregroundColor(.white.opacity(0.5))
                            }
                            .padding(.leading, UIScreen.main.bounds.width/5)
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width/1.1, height: 55)
                            .background(.gray.opacity(0.1))
                            .cornerRadius(25)
                            .overlay {
                                HStack(spacing: UIScreen.main.bounds.width/1.99) {
                                    Button {
                                        presentSideMenu = true
                                    } label: {
                                        Image(systemName: "line.3.horizontal")
                                            .tint(Color.white)
                                    }
                                    HStack(spacing: UIScreen.main.bounds.width/9) {
                                        Button {
                                            openGoogleDrive()
                                        } label: {
                                            Image(systemName: "checkmark.icloud")
                                                .tint(Color.green)
                                        }
                                        
                                        Button {
                                            
                                        } label: {
                                            AsyncImage(url: URL(string: authViewModel.profilePicUrl)) { image in
                                                image.resizable()
                                                    .scaledToFill()
                                                    .frame(width: 30, height: 30)
                                                    .clipShape(Circle())
                                            } placeholder: {
                                                Image(systemName: "person.crop.circle.fill")
                                                    .font(.system(size: 30))
                                                    .foregroundColor(.gray)
                                                    .padding(.trailing, 10)
                                            }
                                        }
                                    }
                                }
                            }
                    }
                    Spacer()
                    VStack(spacing: 30) {
                        Image(systemName: "apple.meditate")
                            .font(.system(size: 100))
                            .foregroundStyle(.white)
                        Text("Looks like there aren't any Google Authenticator codes here yet.")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.white)
                        Button {
                            showNextView = true
                        } label: {
                            Text("Add a code")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(Color("button_text_color"))
                        }
                        .frame(width: UIScreen.main.bounds.width/1.1, height: 48)
                        .background(Color("button_background_color"))
                        .cornerRadius(30)
                    }
                    NavigationLink(destination: AddCodeView(), isActive: $showScanCodeView){}
                    NavigationLink(destination: AddCodeView(), isActive: $showNextView){}
                    Spacer()
                    VStack(alignment: .trailing) {
                        Button {
                            isOverLayOpened = true
                        } label: {
                            Group {
                                if isOverLayOpened {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 30))
                                        .tint(Color.white)
                                        .background(.clear)
                                } else {
                                    Image("google_plus")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .background(.clear)
                                }
                            }
                        }
                        .frame(width: 70, height: 70)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.leading, UIScreen.main.bounds.width/1.5)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.primary.opacity(0.93))
                .navigationTitle("")
                if presentSideMenu {
                    Color.black
                        .opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            presentSideMenu = false
                        }
                    VStack {
                        SideMenu(isShowing: $presentSideMenu)
                            .frame(width: UIScreen.main.bounds.width/1.1, height: UIScreen.main.bounds.height, alignment: .leading)
                            .background(Color("side_menu_background"))
                            .animation(.easeInOut, value: presentSideMenu)
                            .offset(x: -50)
                    }
                }
                if isOverLayOpened {
                    Color.clear
                        .edgesIgnoringSafeArea(.all)
                        .overlay {
                            ZStack {
                                Color.black.opacity(0.5)
                                    .edgesIgnoringSafeArea(.all)
                                    .onTapGesture {
                                        isOverLayOpened.toggle()
                                    }
                                TransparentOverlayView(showScanCodeView: $showScanCodeView)
                            }
                        }
                }
            }
        }
        .onAppear() {
            NotificationCenter.default.addObserver(forName: Notification.Name("NavigateToHome"), object: nil, queue: .main) { _ in
                self.showNextView = false
                self.showGoogleDrive = false
                self.presentSideMenu = false
            }
        }
        .onDisappear() {
            NotificationCenter.default.removeObserver(self, name: Notification.Name("NavigateToHome"), object: nil)
        }
    }
    func openGoogleDrive() {
        if let url = URL(string: "https://drive.google.com/drive/"){
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    if success {
                        DispatchQueue.main.async {
                            NotificationCenter.default.addObserver(forName: Notification.Name("NavigateToHome"), object: nil, queue: .main){_ in }
                        }
                    } else {
                        
                    }
                    NotificationCenter.default.post(name: Notification.Name("NavigateToHome"), object: nil)
                })
            }
        }
    }
}
#Preview {
    HomeView()
}

struct SideMenu: View {
    @Binding var isShowing: Bool
    var body: some View {
        VStack {
            VStack {
                SideMenuContents(isShowing: $isShowing)
            }
        }
    }
}

struct SideMenuContents: View {
    @Binding var isShowing: Bool
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 70)
            Text("Google Authenticator")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
            List {
                NavigationLink(destination: TransferCodesView())
                {
                    HStack {
                        Image(systemName: "arrow.left.arrow.right")
                            .foregroundColor(Color.white)
                            .padding()
                        Text("Transfer codes")
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: true, vertical: false)
                            .listRowSeparator(.hidden, edges: [.bottom])
                    }
                    
                }
                .navigationBarTitle("", displayMode: .inline)
                .listRowInsets(EdgeInsets(top: 20, leading: 30, bottom: 10, trailing: 0))
                .listRowBackground(Color("side_menu_background"))
                
                NavigationLink(destination: HowItWorksView()) {
                    HStack {
                        Image(systemName: "graduationcap")
                            .foregroundColor(Color.white)
                            .padding()
                        Text("How it works")
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: true, vertical: false)
                            .listRowSeparator(.hidden, edges: [.bottom])
                    }
                }
                .listRowInsets(EdgeInsets(top: 20, leading: 30, bottom: 10, trailing: 0))
                .listRowBackground(Color("side_menu_background"))
                
                NavigationLink(destination: SettingsView()) {
                    HStack {
                        Image(systemName: "gearshape")
                            .foregroundColor(Color.white)
                            .padding()
                        Text("Settings")
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: true, vertical: false)
                            .listRowSeparator(.hidden, edges: [.bottom])
                    }
                }
                .listRowInsets(EdgeInsets(top: 20, leading: 30, bottom: 10, trailing: 0))
                .listRowBackground(Color("side_menu_background"))
                
                NavigationLink(destination: HelpAndFeedbackView())
                {
                    HStack {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(Color.white)
                            .padding()
                        Text("Help & feedback")
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: true, vertical: false)
                            .listRowSeparator(.hidden, edges: [.bottom])
                    }
                }
                .listRowInsets(EdgeInsets(top: 20, leading: 30, bottom: 10, trailing: 0))
                .listRowBackground(Color("side_menu_background"))
            }
            .scrollContentBackground(.hidden)
            .background(Color("side_menu_background").edgesIgnoringSafeArea(.all))
            .listStyle(.plain)
        }
        .background(Color("side_menu_background"))
    }
}

struct TransparentOverlayView: View {
    @State var isPresented = false
    @Binding var showScanCodeView: Bool
    var body: some View {
        VStack(alignment: .trailing) {
            Spacer()
                .frame(height: 400)
            HStack(spacing: 20) {
                Text("Scan a QR code")
                    .font(.system(size: 20))
                    .foregroundStyle(Color("button_background_color"))
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Image(systemName: "camera")
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(.white)
                    .frame(width: 10, height: 10)
                    .padding()
                    .background(Color("blue_backgound"))
                    .cornerRadius(8)
            }
            .onTapGesture {
                showScanCodeView = true
                isPresented = true
            }
            Spacer()
                .frame(height: 20)
            HStack(spacing: 20) {
                Text("Enter a setup key")
                    .font(.system(size: 18, weight: .black))
                    .foregroundStyle(Color("button_background_color"))
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Image(systemName: "calendar")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .frame(width: 10, height: 10)
                    .padding()
                    .background(Color("blue_backgound"))
                    .cornerRadius(8)
            }
            .onTapGesture {
                isPresented = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
