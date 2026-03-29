//
//  HomeViewModel.swift
//  FinControl
//
//  Created by Camila Vincensi on 05/01/26.
//

import SwiftUI

final class HomeViewModel: ObservableObject {

    @Published var transactions: [Transaction] = []
    @Published var expensesByCategory: [String: Double] = [:]

    var income: Double {
        transactions.filter { $0.type == .income }.map(\.amount).reduce(0, +)
    }
    
    private let provider = TransactionsProvider()
    
    init() {
            loadTransactions()
        }

        func loadTransactions() {
            provider.listen { [weak self] transactions in
                DispatchQueue.main.async {
                    self?.transactions = transactions
                    self?.calculateExpensesByCategory()
                }
            }
        }

    func add(_ transaction: Transaction) {
        print("🚀 HomeViewModel.add chamado")

        provider.add(transaction) { error in
            if let error = error {
                print("❌ Erro ao salvar:", error.localizedDescription)
            } else {
                print("🎉 Salvou no Firestore")
            }
        }
    }
    
    private func calculateExpensesByCategory() {
        let expenses = transactions.filter { $0.type == .expense }

        expensesByCategory = Dictionary(
            grouping: expenses,
            by: { $0.category }
        )
        .mapValues { $0.reduce(0) { $0 + $1.amount } }
    }

    var expense: Double {
        transactions.filter { $0.type == .expense }.map(\.amount).reduce(0, +)
    }

    var balance: Double { income - expense }


    var formattedBalance: String {
        "R$ \(balance.formatted(.number.precision(.fractionLength(2))))"
    }

    var formattedIncome: String {
        "R$ \(income.formatted(.number.precision(.fractionLength(2))))"
    }

    var formattedExpense: String {
        "R$ \(expense.formatted(.number.precision(.fractionLength(2))))"
    }
}
