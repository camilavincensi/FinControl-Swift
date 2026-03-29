//
//  ReportView.swift
//  FinControl
//
//  Created by Camila Vincensi on 07/01/26.
//

import SwiftUI

struct ReportsView: View {

    @StateObject private var viewModel = ReportsViewModel()

    var body: some View {
        VStack {

            headerBackground

            ScrollView {
                VStack {

                    periodSelector
                        .padding(.top, 5) // 🔥 flutua sobre o verde

                    
                    chartCard

                    categoriesList
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color("Background"))
        .navigationBarHidden(true)
    }
}


private extension ReportsView {

    var headerBackground: some View {
        ZStack {
            Color("PrimaryGreen")
                .frame(height: 130)

            HStack {
    
                Text("Relatórios")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)

                

                Color.clear
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 10)
            .padding(.top, 40)
        }
        .ignoresSafeArea(edges: .top)
    }
}

private extension ReportsView {

    var periodSelector: some View {
        HStack {
            Button(action: viewModel.previousMonth) {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text(viewModel.currentPeriod)
                .font(.system(size: 16, weight: .semibold))

            Spacer()

            Button(action: viewModel.nextMonth) {
                Image(systemName: "chevron.right")
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 6, y: 4)
    }
}


private extension ReportsView {

    var chartCard: some View {
        PieChartView(expensesByCategory: viewModel.expensesByCategory)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 6, y: 4)
    }
}

private extension ReportsView {

    var categoriesList: some View {
        VStack(spacing: 20) {

            categorySection(
                title: "Despesas por categoria",
                items: viewModel.expenseCategoriesSummary
            )

            categorySection(
                title: "Receitas por categoria",
                items: viewModel.incomeCategoriesSummary
            )
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 6, y: 4)
    }

}


private func categorySection(
    title: String,
    items: [CategoryReportItem]
) -> some View {

    VStack(alignment: .leading, spacing: 20) {

        Text(title)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(Color("TextPrimary"))

        if items.isEmpty {
            VStack {
                Spacer()

                Text("Nenhuma movimentação")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Spacer()
            }
        } else {
            ForEach(items) { item in
                HStack {
                    Text(item.category)
                        .font(.system(size: 14))

                    Spacer()

                    Text(item.formattedAmount)
                        .font(.system(size: 14, weight: .semibold))
                }

                Divider()
            }
        }
    }
    .padding(16)
    .frame(minWidth: 180) // ✅ ALTURA FIXA DO QUADRO
    .background(Color.white)
    .cornerRadius(16)
    .shadow(color: Color.black.opacity(0.05), radius: 6, y: 4)
}

