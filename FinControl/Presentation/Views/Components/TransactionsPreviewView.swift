//
//  TransactionsPreviewView.swift
//  FinControl
//
//  Created by Camila Vincensi on 05/01/26.
//
import SwiftUI

struct TransactionsPreviewView: View {

    let transactions: [Transaction]
    let onSeeAll: () -> Void

    var body: some View {
        VStack(spacing: 16) {

            HStack {
                Text("Transações Recentes")
                    .font(.system(size: 16, weight: .semibold))

                Spacer()

                Button("Ver todas", action: onSeeAll)
                    .foregroundColor(Color("PrimaryGreen"))
            }

            if transactions.isEmpty {
                Text("Nenhuma transação")
                    .foregroundColor(Color("TextMuted"))
                    .padding(.vertical, 20)
            } else {
                ForEach(transactions.prefix(4)) { transaction in
                    TransactionRow(transaction: transaction)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
    }
}
