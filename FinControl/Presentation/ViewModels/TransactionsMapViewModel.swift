//
//  TransactionsMapViewModel.swift
//  FinControl
//
//  Created by Camila Vincensi on 08/01/26.
//

import MapKit

final class TransactionsMapViewModel: ObservableObject {

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: -23.5505,
            longitude: -46.6333
        ),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    func coordinate(from transaction: Transaction) -> CLLocationCoordinate2D? {
        guard
            let lat = transaction.latitude,
            let lon = transaction.longitude
        else { return nil }

        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
