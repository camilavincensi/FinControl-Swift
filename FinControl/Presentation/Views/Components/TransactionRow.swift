//
//  TransactionRow.swift
//  FinControl
//
//  Created by Camila Vincensi on 05/01/26.
//

import SwiftUI

struct TransactionRow: View {

    let transaction: Transaction

    var body: some View {
        HStack {
            HStack(spacing: 12) {

                ZStack {
                    Circle()
                        .fill(transaction.type == .income
                              ? Color("GreenSoft")
                              : Color("RedSoft"))
                        .frame(width: 40, height: 40)

                    Image(systemName: transaction.type == .income
                          ? "arrow.up"
                          : "arrow.down")
                        .foregroundColor(transaction.type == .income
                                         ? Color("PrimaryGreen")
                                         : Color(.red))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.category)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("TextPrimary"))

                    Text(transaction.formattedDate)
                        .font(.system(size: 12))
                        .foregroundColor(Color("TextMuted"))
                }
            }

            Spacer()

            Text(transaction.formattedAmount)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(
                    transaction.type == .income
                    ? Color("PrimaryGreen")
                    : Color(.red)
                )
        }
        .padding(.vertical, 12)
        .overlay(
            Divider()
                .background(Color("BorderGray")),
            alignment: .bottom
        )
    }
}
