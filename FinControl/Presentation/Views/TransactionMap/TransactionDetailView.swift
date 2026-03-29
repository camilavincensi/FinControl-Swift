//
//  TransactionDetailView.swift
//  FinControl
//
//  Created by Camila Vincensi on 08/01/26.
//

import SwiftUI
import CoreLocation

struct TransactionDetailView: View {

    let transaction: Transaction

    @StateObject private var geocodingVM = ReverseGeocodingViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text(transaction.description.isEmpty ? "Sem descrição" : transaction.description)
                .font(.title2)
                .bold()

            Text(transaction.formattedAmount)
                .font(.title)
                .foregroundColor(transaction.type == .expense ? .red : .green)

            Text(transaction.category)
                .font(.headline)

            Text(transaction.formattedDate)
                .foregroundColor(.gray)

            Divider()

            addressSection

            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
        .onAppear {
            if let location = transaction.location {
                geocodingVM.fetchAddress(from: location)
            }
        }
    }
}

private extension TransactionDetailView {

    var addressSection: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text("Local")
                .font(.headline)

            if geocodingVM.isLoading {
                ProgressView()
            } else {
                Text(geocodingVM.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
