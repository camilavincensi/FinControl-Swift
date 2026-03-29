//
//  HomeViewModel.swift
//  FinControl
//
//  Created by Camila Vincensi on 05/01/26.
//

import SwiftUI

final class HomeViewModel: ObservableObject {

    @Published var transactions: [Transaction] = []

    var income: Double {
        transactions.filter { $0.type == .income }.map(\.amount).reduce(0, +)
    }

    var expense: Double {
        transactions.filter { $0.type == .expense }.map(\.amount).reduce(0, +)
    }

    var balance: Double { income - expense }

    var expensesByCategory: [String: Double] {
        Dictionary(grouping: transactions.filter { $0.type == .expense }) {
            $0.category
        }.mapValues {
            $0.map(\.amount).reduce(0, +)
        }
    }

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
