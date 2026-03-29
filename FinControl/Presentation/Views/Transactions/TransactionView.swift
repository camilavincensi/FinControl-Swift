//
//  TransactionView.swift
//  FinControl
//
//  Created by Camila Vincensi on 07/01/26.
//

import SwiftUI

struct TransactionsView: View {

    @StateObject private var viewModel = TransactionsViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showNewTransaction = false

    var body: some View {
        VStack(spacing: 0) {

            header

            filterSegment

            ScrollView {
                VStack(spacing: 0) {
                    if viewModel.filteredTransactions.isEmpty {
                        emptyState
                    } else {
                        ForEach(viewModel.filteredTransactions) { transaction in
                            TransactionRow(transaction: transaction)
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
            AddButtonView {
                showNewTransaction = true
            }
            .sheet(isPresented: $showNewTransaction) {   // 🔥 O PONTO AQUI
                NewTransactionView(
                    isEditing: false,
                    transactionToEdit: nil,
                    onClose: {
                        showNewTransaction = false
                    },
                    onSave: { transaction in
                        viewModel.add(transaction)
                        showNewTransaction = false
                    }
                )
            }
        }
        
        .background(Color("Background"))
        .navigationBarHidden(true)
    }
}

private extension TransactionsView {

    var header: some View {
        ZStack {
            Color("PrimaryGreen")
                //.frame(maxWidth: .infinity)
                .frame(height: 150)
               

            HStack {
                // ⬅️ Botão voltar
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }

                Spacer()

                // 📝 Título centralizado de verdade
                Text("Transações")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                // 👻 Espaço fantasma (mesma largura do botão)
                Color.clear
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 10)
            .padding(.top, 40)
        }
        .ignoresSafeArea(edges: .top)
    }
}


private extension TransactionsView {

    var filterSegment: some View {
        Picker("", selection: $viewModel.filter) {
            Text("Todas").tag(TransactionType?.none)
            Text("Receitas").tag(TransactionType?.some(.income))
            Text("Despesas").tag(TransactionType?.some(.expense))
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
        .background(Color.white)
    }
}

private extension TransactionsView {

    var emptyState: some View {
        VStack(spacing: 8) {
            Text("Nenhuma transação encontrada")
                .font(.system(size: 14))
                .foregroundColor(Color("TextMuted"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}
