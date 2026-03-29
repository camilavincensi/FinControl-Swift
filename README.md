# FinControl-Swift
O FinControl é um aplicativo mobile desenvolvido para auxiliar usuários no controle de suas finanças pessoais. O sistema permite cadastrar receitas e despesas, visualizar saldo total, consultar relatórios por categoria, acompanhar transações recentes e visualizar movimentações em mapa. O projeto foi desenvolvido com foco em boas práticas de engenharia de software, adotando arquitetura MVVM, injeção de dependência, testes unitários e princípios de Clean Code.

### 1. CLEAN CODE
O requisito de Clean Code foi atendido por meio de nomes descritivos, propriedades com acesso controlado (private(set)), separação de responsabilidades, uso de métodos menores e organização do código em extensões privadas para melhorar a legibilidade e manutenção.

> Exemplo 1: ViewModel com nomes claros e responsabilidade organizada
```
@MainActor
final class HomeViewModel: ObservableObject {

    @Published private(set) var transactions: [Transaction] = []
    @Published private(set) var expensesByCategory: [String: Double] = [:]
    @Published private(set) var errorMessage: String?

    private let transactionsProvider: TransactionsProviding

    init(transactionsProvider: TransactionsProviding) {
        self.transactionsProvider = transactionsProvider
        observeTransactions()
    }

    var totalIncome: Double {
        incomeTransactions
            .map(\.amount)
            .reduce(0, +)
    }

    var totalExpense: Double {
        expenseTransactions
            .map(\.amount)
            .reduce(0, +)
    }

    var balance: Double {
        totalIncome - totalExpense
    }
}

```
> Exemplo 2: componente organizado em extensões privadas
```
private extension TransactionRow {

    var amountText: some View {
        Text(transaction.formattedAmount)
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(amountColor)
    }

    var isIncome: Bool {
        transaction.type == .income
    }

    var iconName: String {
        isIncome ? "arrow.up" : "arrow.down"
    }
}
```

### 2. ARQUITETURA DE SOFTWARE
O projeto foi desenvolvido com arquitetura MVVM. As Views são responsáveis pela interface, as ViewModels concentram estado e lógica de apresentação, e os Models representam os dados do sistema. Essa separação reduz o acoplamento e melhora a manutenção e a testabilidade.

> Exemplo 1: uma View
LoginView
```
@MainActor
struct LoginView: View {

    @StateObject private var viewModel: AuthViewModel

    let onLogin: (_ userId: String) -> Void
    let onRegister: () -> Void

    init(
        onLogin: @escaping (_ userId: String) -> Void,
        onRegister: @escaping () -> Void
    ) {
        self.onLogin = onLogin
        self.onRegister = onRegister

        _viewModel = StateObject(
            wrappedValue: DIContainer.shared.makeAuthViewModel()
        )
    }
}
```
> Exemplo 2: a ViewModel correspondente
AuthViewModel

```
@MainActor
final class AuthViewModel: ObservableObject {

    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""

    @Published private(set) var isLoading = false

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    func login(onSuccess: @escaping (String) -> Void) {
        guard validateLoginForm() else { return }
        isLoading = true
        clearMessages()

        authService.login(email: email, password: password) { [weak self] result in
            guard let self else { return }
            self.isLoading = false
        }
    }
}
```
> Exemplo 3: Model
Transaction

```
struct Transaction: Identifiable, Codable {

    let id: String
    let category: String
    let amount: Double
    let date: Date
    let type: TransactionType
    let description: String
    let latitude: Double?
    let longitude: Double?
}
```

### 3. INJEÇÃO DE DEPENDÊNCIA
A injeção de dependência foi implementada por meio de um DIContainer, responsável por centralizar a criação de serviços, providers e ViewModels. As dependências passaram a ser fornecidas via construtor, tornando o código mais modular, desacoplado e testável.

> Exemplo 1: DIContainer

```
@MainActor
final class DIContainer {
    
    static let shared = DIContainer()
    
    private init() {}
    
    lazy var authService = AuthService()
    lazy var pushService = PushNotificationService()
    lazy var locationManager = LocationManager()

    lazy var transactionsProvider: TransactionsProviding = TransactionsProvider()
    lazy var categoriesProvider = CategoriesProvider()
    lazy var addressResolver: AddressResolving = AddressResolver()
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            transactionsProvider: transactionsProvider
        )
    }
    
    func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel(
            authService: authService
        )
    }
}
```
> Exemplo 2: construtor com dependência injetada

```
final class TransactionsViewModel: ObservableObject {

    @Published private(set) var transactions: [Transaction] = []

    private let transactionsProvider: TransactionsProviding

    init(transactionsProvider: TransactionsProviding) {
        self.transactionsProvider = transactionsProvider
        observeTransactions()
    }
}
```

### 4. TESTES UNITÁRIOS
O projeto possui testes unitários implementados com XCTest. Os testes validam regras de negócio de ViewModels, como cálculo de saldo, filtragem de transações, navegação do onboarding e agrupamento de despesas por categoria. Para isso, foram usados mocks que simulam dependências externas sem precisar acessar Firebase.

> Exemplo 1: mock usado nos testes

```
final class MockTransactionsProvider: TransactionsProviding {

    var transactionsToReturn: [Transaction] = []

    func observeTransactions(
        onUpdate: @escaping ([Transaction]) -> Void
    ) {
        onUpdate(transactionsToReturn)
    }

    func add(
        _ transaction: Transaction,
        completion: @escaping (Error?) -> Void
    ) {
        completion(nil)
    }
}
```

> Exemplo 2: teste da HomeViewModel

```
@MainActor
final class HomeViewModelTests: XCTestCase {

    func testShouldCalculateBalanceCorrectly() {
        let mockProvider = MockTransactionsProvider()
        mockProvider.transactionsToReturn = [
            Transaction(id: "1", category: "Salário", amount: 2500, date: Date(), type: .income, description: ""),
            Transaction(id: "2", category: "Lazer", amount: 400, date: Date(), type: .expense, description: "")
        ]

        let viewModel = HomeViewModel(transactionsProvider: mockProvider)

        XCTAssertEqual(viewModel.balance, 2100)
    }
}
```
> Exemplo 3: teste da TransactionsViewModel

```
func testShouldReturnOnlyIncomeTransactionsWhenFilterIsIncome() {
    let mockProvider = MockTransactionsProvider()
    mockProvider.transactionsToReturn = [
        Transaction(id: "1", category: "Salário", amount: 2000, date: Date(), type: .income, description: ""),
        Transaction(id: "2", category: "Mercado", amount: 300, date: Date(), type: .expense, description: "")
    ]

    let viewModel = TransactionsViewModel(transactionsProvider: mockProvider)
    viewModel.selectedFilter = .income

    XCTAssertEqual(viewModel.filteredTransactions.count, 1)
}
```

### 5. DESIGN PATTERNS
Foram utilizados diferentes padrões de design no projeto. O padrão MVVM organiza as camadas da aplicação, o padrão Coordinator centraliza a navegação no AppCoordinator, o padrão Factory foi aplicado no DIContainer para criação de ViewModels, e o padrão Observer foi utilizado por meio de ObservableObject e @Published, permitindo atualização reativa da interface. Providers também foram usados para encapsular acesso a dados externos.

> Exemplo 1: Coordinator

```
@MainActor
final class AppCoordinator: ObservableObject {

    @Published var route: AppRoute = .onboarding

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    func start() {
        route = authService.isUserLoggedIn ? .mainTabs : .onboarding
    }

    func handleLogin(userId: String) {
        PushNotificationService.initPush(userId: userId)
        route = .mainTabs
    }

    func handleLogout() {
        route = .onboarding
    }
}
```
> Exemplo 2: Factory no DIContainer

```
func makeReportsViewModel() -> ReportsViewModel {
    ReportsViewModel(
        transactionsProvider: transactionsProvider
    )
}
```

> Exemplo 3: Observer com ObservableObject e @Published

```
@MainActor
final class ReportsViewModel: ObservableObject {

    @Published var currentDate: Date = Date()
    @Published private(set) var transactions: [Transaction] = []
    @Published private(set) var expenseCategoryItems: [CategoryReportItem] = []
    @Published private(set) var incomeCategoryItems: [CategoryReportItem] = []
}
```

### 6. INTERFACE
O aplicativo possui contexto definido de controle financeiro pessoal e apresenta mais de três telas funcionais, incluindo onboarding, login, cadastro, dashboard, transações, relatórios, mapa e cadastro de nova transação. Essas telas estão integradas por navegação controlada e fluxo funcional completo.

> Onboarding 
<img width="250" height="520" alt="simulator_screenshot_BE6E576D-8EC3-4947-81FB-B3C12012F4DB" src="https://github.com/user-attachments/assets/3411f972-4d24-44de-8426-1631cd403939" />
<img width="250" height="520" alt="simulator_screenshot_3C7C81BD-63BE-4FEC-BFB7-39B2385747D8" src="https://github.com/user-attachments/assets/922b3c62-6b1b-47c8-b5ed-645100fcd7a5" />
<img width="250" height="520" alt="simulator_screenshot_BB7B946D-7E97-4A2D-A830-7C979DF37DED" src="https://github.com/user-attachments/assets/6fb814b3-8b4d-4504-99d3-4ba24066625a" />

<br>

> Login - Cadastre-se
<img width="250" height="520" alt="simulator_screenshot_14A5C853-0BBD-46F8-AF94-DADA06AAC455" src="https://github.com/user-attachments/assets/5e062bce-0544-4ce2-b2fb-5f20f579cf72" />
<img width="250" height="520" alt="simulator_screenshot_79DD51B6-D30B-44EB-8A75-506EF2B3ED9D" src="https://github.com/user-attachments/assets/906c2cd1-3d16-4904-ac4a-88e3815766f5" />

<br> 

> Home/Dashboard - Transações - Novas Transações
<img width="250" height="520" alt="simulator_screenshot_8274406E-F8D9-4E50-AA66-6C7E6645A4BD" src="https://github.com/user-attachments/assets/f3df3012-47b2-4a0f-a2c5-1532638e696e" />
<img width="250" height="520" alt="simulator_screenshot_D2BF754A-E7F9-4A7D-A546-5F0F11266815" src="https://github.com/user-attachments/assets/154317de-fa11-406d-b6fb-089c256cd9a0" />
<img width="250" height="520" alt="simulator_screenshot_825B1928-3571-4FFE-BB41-2DDDCD604976" src="https://github.com/user-attachments/assets/da5dc282-b8d5-4ca2-8f39-0e4cb066046b" />

<br> 

> Relatórios - Mapa
<img width="250" height="520" alt="simulator_screenshot_C1C5B3B1-2EF8-468C-A7B9-825AF2689EDC" src="https://github.com/user-attachments/assets/8a8b9737-e3c0-4c39-b763-ac76f4c48232" />
<img width="250" height="520" alt="simulator_screenshot_A7F7C0EA-2DD8-4EB3-B399-6FEA8EBD9034" src="https://github.com/user-attachments/assets/1fbf9aaf-8897-4a47-8d48-1e61605149a7" />
