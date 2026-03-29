//
//  BalanceCardView.swift
//  FinControl
//
//  Created by Camila Vincensi on 05/01/26.
//

import SwiftUI

struct BalanceCardView: View {

    let title: String
    let value: String
    let icon: String
    let color: Color
    let background: Color
    let width: CGFloat?
    let size: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(background)
                        .frame(width: width, height: 36)

                    Image(systemName: icon)
                        .foregroundColor(color)
                }

                Text(title)
                    .foregroundColor(Color("TextGray"))
            }

            Text(value)
                .font(.system(size: size, weight: .semibold))
                .foregroundColor(color)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
    }
}

