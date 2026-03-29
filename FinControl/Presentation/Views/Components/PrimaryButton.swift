//
//  PrimaryButton.swift
//  FinControl
//
//  Created by Camila Vincensi on 05/01/26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let loading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(loading ? "Entrando..." : title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color("PrimaryGreen"))
                .cornerRadius(10)
        }
        .disabled(loading)
    }
}
