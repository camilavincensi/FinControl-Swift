//
//  AddButtonView.swift
//  FinControl
//
//  Created by Camila Vincensi on 05/01/26.
//
import SwiftUI

struct AddButtonView: View {

    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color("PrimaryGreen"))
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .padding(.trailing, 24)
        .padding(.bottom, 30)
    }
}
