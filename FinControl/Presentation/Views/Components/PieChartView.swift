//
//  PieChartView.swift
//  FinControl
//
//  Created by Camila Vincensi on 05/01/26.
//

import SwiftUI

struct PieChartView: View {

    let expensesByCategory: [String: Double]

    private var slices: [PieSlice] {
        let total = expensesByCategory.values.reduce(0, +)
        var currentAngle: Double = 0

        return expensesByCategory.map { category, value in
            let angle = value / total * 360
            let slice = PieSlice(
                startAngle: .degrees(currentAngle),
                endAngle: .degrees(currentAngle + angle),
                color: colorForCategory(category),
                category: category,
                value: value
            )
            currentAngle += angle
            return slice
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Distribuição de Gastos")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("TextPrimary"))

            if expensesByCategory.isEmpty {
                Text("Nenhuma despesa registrada")
                    .foregroundColor(Color("TextMuted"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                HStack(spacing: 16) {

                    ZStack {
                        ForEach(slices.indices, id: \.self) { index in
                            PieSliceShape(
                                startAngle: slices[index].startAngle,
                                endAngle: slices[index].endAngle
                            )
                            .fill(slices[index].color)
                        }
                    }
                    .frame(width: 120, height: 120)

                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(slices, id: \.category) { slice in
                            HStack {
                                Circle()
                                    .fill(slice.color)
                                    .frame(width: 10, height: 10)

                                Text(slice.category)
                                    .font(.system(size: 13))
                                    .foregroundColor(Color("TextPrimary"))

                                Spacer()

                                Text("R$ \(slice.value, specifier: "%.2f")")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color("TextMuted"))
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
    }

    // 🎨 cores fixas por categoria
    private func colorForCategory(_ category: String) -> Color {
        let colors: [Color] = [
            Color("PrimaryGreen"),
            .blue,
            .orange,
            .purple,
            .pink,
            .yellow,
            .red
        ]

        let index = abs(category.hashValue) % colors.count
        return colors[index]
    }
}
