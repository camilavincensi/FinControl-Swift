//
//  TransactionsMapView.swift
//  FinControl
//
//  Created by Camila Vincensi on 08/01/26.
//

import SwiftUI
import MapKit

struct TransactionsMapView: View {

    let transactions: [Transaction]

    @StateObject private var viewModel = TransactionsMapViewModel()
    @State private var selectedTransaction: Transaction?

    var body: some View {
        Map(
            coordinateRegion: $viewModel.region,
            annotationItems: annotationItems
        ) { item in
            MapAnnotation(coordinate: item.coordinate) {
                Button {
                    selectedTransaction = item.transaction
                } label: {
                    Circle()
                        .fill(item.transaction.type == .expense ? .red : .green)
                        .frame(width: 14, height: 14)
                }
            }
        }
        .ignoresSafeArea()
        .sheet(item: $selectedTransaction) { transaction in
            TransactionDetailView(transaction: transaction)
        }
    }
}

private extension TransactionsMapView {

    var annotationItems: [MapAnnotationItem] {
        transactions.compactMap { transaction in
            guard let coord = viewModel.coordinate(from: transaction) else {
                return nil
            }
            return MapAnnotationItem(
                id: transaction.id,
                coordinate: coord,
                transaction: transaction
            )
        }
    }
}


struct MapAnnotationItem: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let transaction: Transaction
}
