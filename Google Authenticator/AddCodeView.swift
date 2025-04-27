//
//  AddCodeView.swift
//  Google Authenticator
//
//

import SwiftUI

struct AddCodeView: View {
    @State var showQRCodeView = false
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 30) {
                Image(systemName: "person")
                    .font(.system(size: 40))
                    .foregroundStyle(Color("button_background_color"))
                Text("Add an authenticator code")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                Text("To begin, either scan the QR code or manually enter\nthe setup key.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, UIScreen.main.bounds.width
            / 9)
            Spacer()
                .frame(height: 60)
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Image(systemName: "camera")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .padding()
                    Text("Scan a QR code")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                }
                .frame(width: UIScreen.main.bounds.width/1.2, height: 65, alignment: .leading)
                .background(Color("blue_backgound"))
                .roundedCorner(30, corners: [.topLeft, .topRight])
                .onTapGesture {
                    showQRCodeView = true
                }
                NavigationLink(destination: ScanQRCodeView(), isActive: $showQRCodeView){}
                HStack(spacing: 0) {
                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .padding()
                    Text("Enter a setup key")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                }
                .frame(width: UIScreen.main.bounds.width/1.2, height: 65, alignment: .leading)
                .background(Color("blue_backgound"))
                .roundedCorner(30, corners: [.bottomLeft, .bottomRight])
                
            }
            Spacer()
                .frame(height: 300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primary.opacity(0.93))
        .navigationBarTitle("", displayMode: .inline)
    }
}

#Preview {
    AddCodeView()
}
