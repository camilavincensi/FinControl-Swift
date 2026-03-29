//
//  TransactionsProvider.swift
//  FinControl
//
//  Created by Camila Vincensi on 06/01/26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class TransactionsProvider {

    private let db = Firestore.firestore()

    func add(_ transaction: Transaction, completion: ((Error?) -> Void)? = nil) {

        guard let user = Auth.auth().currentUser else {
            print("❌ NÃO HÁ USUÁRIO LOGADO")
            completion?(NSError(domain: "", code: 401))
            return
        }

        print("✅ Salvando transação para UID:", user.uid)
        print("📦 Dados:", transaction.toFirestore)

        db.collection("users")
            .document(user.uid)
            .collection("transactions")
            .document(transaction.id)
            .setData(transaction.toFirestore) { error in
                if let error = error {
                    print("❌ Erro Firestore:", error.localizedDescription)
                } else {
                    print("✅ Transação salva com sucesso")
                }
                completion?(error)
            }
    }
    
    func listen(completion: @escaping ([Transaction]) -> Void) {

            guard let uid = Auth.auth().currentUser?.uid else {
                print("❌ Usuário não logado")
                return
            }

            db.collection("users")
                .document(uid)
                .collection("transactions")
                .order(by: "date", descending: true)
                .addSnapshotListener { snapshot, error in

                    if let error = error {
                        print("❌ Erro ao ouvir transações:", error)
                        return
                    }

                    let transactions = snapshot?.documents.compactMap {
                        Transaction(id: $0.documentID, data: $0.data())
                    } ?? []

                    print("📥 Transações carregadas:", transactions.count)
                    completion(transactions)
                }
        }
}
