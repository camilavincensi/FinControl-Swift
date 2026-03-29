import Foundation
import FirebaseFirestore
import FirebaseAuth

final class ReportsViewModel: ObservableObject {

    // MARK: - State
    @Published var currentDate = Date()
    @Published var transactions: [Transaction] = []
    @Published var expenseCategoriesSummary: [CategoryReportItem] = []
    @Published var incomeCategoriesSummary: [CategoryReportItem] = []


    private let db = Firestore.firestore()

    init() {
        loadTransactions()
    }

    // MARK: - Firebase

    func loadTransactions() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let range = monthRange(for: currentDate)

        db.collection("users")
            .document(uid)
            .collection("transactions")
            .whereField("date", isGreaterThanOrEqualTo: range.start)
            .whereField("date", isLessThan: range.end)
            .addSnapshotListener { snap, _ in
                guard let docs = snap?.documents else { return }

                let transactions = docs.compactMap {
                    Transaction(id: $0.documentID, data: $0.data())
                }

                self.transactions = transactions
                self.expenseCategoriesSummary = self.buildCategorySummary(
                    from: transactions.filter { $0.type == .expense }
                )

                self.incomeCategoriesSummary = self.buildCategorySummary(
                    from: transactions.filter { $0.type == .income }
                )

            }
    }


    // MARK: - Period
    
    private func monthRange(for date: Date) -> (start: Date, end: Date) {

        let calendar = Calendar.current

        let start = calendar.date(
            from: calendar.dateComponents([.year, .month], from: date)
        )!

        let end = calendar.date(byAdding: .month, value: 1, to: start)!

        return (start, end)
    }


    func previousMonth() {
        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        loadTransactions()
    }

    func nextMonth() {
        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        loadTransactions()
    }

    var currentPeriod: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate).capitalized
    }

    // MARK: - Calculations

    var income: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }

    var expense: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + abs($1.amount) }
    }

    var balance: Double {
        income - expense
    }

    var expensesByCategory: [String: Double] {
        Dictionary(
            grouping: transactions.filter { $0.type == .expense },
            by: { $0.category }
        )
        .mapValues {
            $0.reduce(0) { $0 + abs($1.amount) }
        }
    }

    // MARK: - Category Summary

    private func buildCategorySummary(
        from transactions: [Transaction]
    ) -> [CategoryReportItem] {

        let grouped = Dictionary(grouping: transactions, by: { $0.category })

        return grouped.map { key, values in
            let total = values.reduce(0) { $0 + abs($1.amount) }

            return CategoryReportItem(
                category: key,
                total: total
            )
        }
        .sorted { $0.total > $1.total }
    }

    // MARK: - Formatter

    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: value)) ?? "R$ 0,00"
    }
}

struct CategoryReportItem: Identifiable {
    let id = UUID()
    let category: String
    let total: Double

    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: total)) ?? "R$ 0,00"
    }
}
