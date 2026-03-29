//
//  TransactionsViewModel.swift
//  FinControl
//
//  Created by Camila Vincensi on 07/01/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class TransactionsViewModel: ObservableObject {

    @Published var transactions: [Transaction] = []
    @Published var filter: TransactionType? = nil

    private let db = Firestore.firestore()
    private let provider = TransactionsProvider()

    init() {
        loadTransactions()
    }

    func loadTransactions() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users")
            .document(uid)
            .collection("transactions")
            .order(by: "date", descending: true)
            .addSnapshotListener { snap, _ in
                guard let docs = snap?.documents else { return }

                self.transactions = docs.compactMap {
                    Transaction(id: $0.documentID, data: $0.data())
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

    var filteredTransactions: [Transaction] {
        guard let filter else { return transactions }
        return transactions.filter { $0.type == filter }
    }
}
