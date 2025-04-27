//
//  TransferCodesView.swift
//  Google Authenticator
//
//

import SwiftUI

struct TransferCodesView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 30) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 30))
                    .foregroundStyle(Color("button_background_color"))
                Text("Transfer codes")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                Text("You can transfer your codes to a new device that has\nGoogle Authenticator.")
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
                    Image(systemName: "iphone.and.arrow.forward.outward")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .padding()
                    Text("Export codes\nCreate a QR code to export your codes")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white)
                }
                .frame(width: UIScreen.main.bounds.width/1.2, height: 65, alignment: .leading)
                .background(Color("blue_backgound"))
                .roundedCorner(30, corners: [.topLeft, .topRight])
                HStack(spacing: 0) {
                    Image(systemName: "iphone.and.arrow.forward.inward")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .padding()
                    Text("Import codes\nScan a QR code to bring new codes in")
                        .font(.system(size: 12, weight: .medium))
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
    }
}

#Preview {
    TransferCodesView()
}
