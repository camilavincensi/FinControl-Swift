import SwiftUI
import MapKit

struct NewTransactionView: View {

    @StateObject private var viewModel = NewTransactionViewModel()
    @StateObject private var categoriesProvider = CategoriesProvider()
    @StateObject private var locationManager = LocationManager()
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var selectedAddress: String?
    @State private var showLocationPicker = false



    let isEditing: Bool
    let transactionToEdit: Transaction?
    let onClose: () -> Void
    let onSave: (Transaction) -> Void

    var body: some View {
        NavigationStack {
            Form {

                // 🔹 TIPO
                Picker("Tipo", selection: $viewModel.type) {
                    ForEach(TransactionType.allCases) { type in
                        Text(type.title).tag(type)
                    }
                }
                .pickerStyle(.segmented)


                // 🔹 VALOR
                TextField("Valor", text: $viewModel.amount)
                    .keyboardType(.decimalPad)

                // 🔹 CATEGORIA (AGORA PICKER 👇)
                Picker("Categoria", selection: $viewModel.category) {
                    if categoriesProvider.isLoading {
                        Text("Carregando categorias…").tag("")
                    } else {
                        ForEach(categoriesProvider.categories) { category in
                            Text(category.name).tag(category.name)
                        }
                    }
                }
                .disabled(categoriesProvider.isLoading)

                // 🔹 DATA
                DatePicker("Data", selection: $viewModel.date, displayedComponents: .date)

                // 🔹 DESCRIÇÃO
                TextField("Descrição", text: $viewModel.description)
                
                locationSection
            }
            .navigationTitle(isEditing ? "Editar Transação" : "Nova Transação")
            .toolbar {

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar", action: onClose)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        if let transaction = viewModel.buildTransaction() {
                            onSave(transaction)
                            onClose()
                        }
                    }
                    .disabled(!viewModel.isValid)
                }
            }
            .onAppear {
                // 🔥 CARREGA CATEGORIAS INICIAL
                categoriesProvider.loadCategories(
                    type: viewModel.type == .income ? .income : .expense
                )
            }
            .onReceive(locationManager.$coordinate) { coord in
                guard let coord else { return }

                viewModel.location = coord
                viewModel.fetchAddress(from: coord) { address in
                    selectedAddress = address
                }
            }
            .onChange(of: selectedCoordinate?.latitude) { _ in
                guard let coord = selectedCoordinate else { return }

                viewModel.location = coord
                viewModel.fetchAddress(from: coord) { address in
                    selectedAddress = address
                }
            }


        }
    }
}

private extension NewTransactionView {

    var locationSection: some View {
        Section {

            // 🔹 Localização atual
            Button {
                locationManager.requestLocation()
            } label: {
                Label("Usar localização atual", systemImage: "location.fill")
            }

            // 🔹 Endereço manual
            TextField("Digite o endereço", text: $viewModel.manualAddress)

            // 🔹 Selecionar no mapa
            Button {
                showLocationPicker = true
            } label: {
                Label("Selecionar endereço", systemImage: "map")
            }
            .sheet(isPresented: $showLocationPicker) {
                SelectLocationMapView(
                    selectedLocation: $selectedCoordinate
                )
            }

            // 📍 Endereço resolvido
            if let address = selectedAddress {
                Text(address)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

        } header: {
            Text("Local da transação")
        }
    }
}
