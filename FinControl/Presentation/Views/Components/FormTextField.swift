//
//  FormTextField.swift
//  FinControl
//
//  Created by Camila Vincensi on 05/01/26.
//

import SwiftUI

struct FormTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
            }
            .padding(14)
            .background(Color("InputBackground"))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(error == nil ? Color("BorderGray") : Color("ErrorRed"), lineWidth: 1)
            )
            .cornerRadius(10)

            if let error {
                Text(error)
                    .font(.system(size: 13))
                    .foregroundColor(Color("ErrorRed"))
            }
        }
    }
}
