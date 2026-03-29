//
//  MainTabView.swift
//  FinControl
//
//  Created by Camila Vincensi on 04/01/26.
//

import SwiftUI

struct MainTabView: View {

    @StateObject private var transactionsViewModel = TransactionsViewModel()

    var body: some View {
        NavigationStack {
            TabView {

                HomeView()
                    .tabItem {
                        Label("Início", systemImage: "house.fill")
                    }

                TransactionsView()
                    .tabItem {
                        Label("Transações", systemImage: "dollarsign.circle.fill")
                    }

                ReportsView()
                    .tabItem {
                        Label("Relatórios", systemImage: "chart.bar.fill")
                    }

                // 🗺️ MAPA
                TransactionsMapView(
                    transactions: transactionsViewModel.transactions
                )
                .tabItem {
                    Label("Mapa", systemImage: "map")
                }
            }
            .environmentObject(transactionsViewModel) // 🔥 COMPARTILHADO
            .tint(Color("PrimaryGreen"))
        }
    }
}
