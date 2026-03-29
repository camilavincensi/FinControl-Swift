import FirebaseFirestore
import FirebaseAuth

@MainActor
final class CategoriesProvider: ObservableObject {

    @Published var categories: [Category] = []
    @Published var isLoading = false

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    // MARK: - Public

    func loadCategories(type: CategoryType) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        isLoading = true

        // Remove listener antigo (evita duplicação)
        listener?.remove()

        listener = db.collection("users")
            .document(uid)
            .collection("categories")
            .whereField("type", isEqualTo: type.rawValue)
            .order(by: "createdAt")
            .addSnapshotListener { [weak self] snap, error in

                guard let self else { return }
                self.isLoading = false

                if let error {
                    print("❌ Erro ao carregar categorias:", error.localizedDescription)
                    return
                }

                guard let docs = snap?.documents else { return }

                // Usuário novo → cria categorias padrão
                if docs.isEmpty {
                    self.createDefaultCategoriesIfNeeded(for: uid)
                    return
                }

                self.categories = docs.compactMap { doc in
                    guard
                        let name = doc["name"] as? String,
                        let typeRaw = doc["type"] as? String,
                        let type = CategoryType(rawValue: typeRaw)
                    else { return nil }

                    return Category(
                        id: doc.documentID,
                        name: name,
                        type: type
                    )
                }
            }
    }

    // MARK: - Default Categories

    private func createDefaultCategoriesIfNeeded(for uid: String) {
        let ref = db.collection("users")
            .document(uid)
            .collection("categories")

        // Checa se já existem categorias (proteção extra)
        ref.limit(to: 1).getDocuments { snap, _ in
            guard snap?.isEmpty == true else { return }

            let defaultCategories: [(String, CategoryType)] = [
                ("Alimentação", .expense),
                ("Transporte", .expense),
                ("Moradia", .expense),
                ("Lazer", .expense),
                ("Salário", .income),
                ("Freelancer", .income),
                ("Outros", .income)
            ]

            let batch = self.db.batch()

            for (name, type) in defaultCategories {
                let doc = ref.document()
                batch.setData([
                    "name": name,
                    "type": type.rawValue,
                    "createdAt": Timestamp()
                ], forDocument: doc)
            }

            batch.commit { error in
                if let error {
                    print("❌ Erro ao criar categorias padrão:", error.localizedDescription)
                } else {
                    print("✅ Categorias padrão criadas")
                }
            }
        }
    }

    // MARK: - Cleanup

    deinit {
        listener?.remove()
    }
}
