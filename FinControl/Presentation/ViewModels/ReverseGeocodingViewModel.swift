//
//  ReverseGeocodingViewModel.swift
//  FinControl
//
//  Created by Camila Vincensi on 08/01/26.
//

import Foundation
import CoreLocation

final class ReverseGeocodingViewModel: ObservableObject {

    @Published var address: String = "Carregando endereço…"
    @Published var isLoading = false

    private let geocoder = CLGeocoder()

    func fetchAddress(from coordinate: CLLocationCoordinate2D) {
        isLoading = true

        let location = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )

        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error = error {
                    print("❌ Reverse geocoding error:", error.localizedDescription)
                    self?.address = "Endereço indisponível"
                    return
                }

                guard let placemark = placemarks?.first else {
                    self?.address = "Endereço não encontrado"
                    return
                }

                self?.address = Self.formatAddress(from: placemark)
            }
        }
    }

    private static func formatAddress(from placemark: CLPlacemark) -> String {
        [
            placemark.thoroughfare,
            placemark.subThoroughfare,
            placemark.subLocality,
            placemark.locality,
            placemark.administrativeArea
        ]
        .compactMap { $0 }
        .joined(separator: ", ")
    }
}
