//
//  HomeView.swift
//  FinControl
//
//  Created by Camila Vincensi on 05/01/26.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel = HomeViewModel()
    @State private var showNewTransaction = false   // ✅ AQUI
    @State private var showTransactions = false


    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            ScrollView {
                VStack(spacing: 0) {

                    header
                    balanceCards

                    VStack(spacing: 16) {
                        PieChartView(expensesByCategory: viewModel.expensesByCategory)

                        TransactionsPreviewView(
                            transactions: viewModel.transactions,
                            onSeeAll: {
                                showTransactions = true
                            }
                        )
                        .navigationDestination(isPresented: $showTransactions) {
                            TransactionsView()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 120)
                }
            }
            .ignoresSafeArea(edges: .top)
            
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
    }
}


private extension HomeView {

    var header: some View {
        ZStack(alignment: .top) {

            Color("PrimaryGreen")
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                .ignoresSafeArea(edges: .top) // 🔥 ISSO AQUI

            VStack(spacing: 16) {
                HStack {
                    Text("Dashboard")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()

                    Image(systemName: "bell")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }

                VStack(spacing: 4) {
                    Text("Saldo Total")
                        .foregroundColor(.white.opacity(0.8))

                    Text(viewModel.formattedBalance)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(viewModel.balance < 0 ? .red : .white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 60) // espaço da status bar
        }
    }


    // ✅ AGORA O viewModel EXISTE AQUI
    var balanceCards: some View {
        HStack(spacing: 20) {
            BalanceCardView(
                title: "Receitas",
                value: viewModel.formattedIncome,
                icon: "arrow.up",
                color: Color("PrimaryGreen"),
                background: Color("GreenSoft"),
                width: 36,
                size: 18
                
            )

            BalanceCardView(
                title: "Despesas",
                value: viewModel.formattedExpense,
                icon: "arrow.down",
                color: .red,
                background: Color("RedSoft"),
                width: 36,
                size: 18
            )
        }
        .padding(.horizontal, 20)
        .offset(y: -40)
    }
}
