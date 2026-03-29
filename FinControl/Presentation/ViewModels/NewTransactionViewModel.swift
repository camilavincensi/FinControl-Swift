import Foundation
import FirebaseAuth
import CoreLocation


import CoreLocation
import SwiftUI

class NewTransactionViewModel: ObservableObject {
    @Published var type: TransactionType = .expense
    @Published var category: String = ""
    @Published var amount: String = ""
    @Published var date: Date = Date()
    @Published var description: String = ""
    
    // 📍 Nova propriedade de localização
    @Published var location: CLLocationCoordinate2D? = nil
    @Published var manualAddress: String = ""
    
    var isValid: Bool {
        !category.isEmpty && !amount.isEmpty
    }
    
    func fetchAddress(
        from coordinate: CLLocationCoordinate2D,
        completion: @escaping (String?) -> Void
    ) {
        let geocoder = CLGeocoder()
        let location = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )

        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            let placemark = placemarks?.first
            let address = [
                placemark?.thoroughfare,
                placemark?.subThoroughfare,
                placemark?.locality
            ]
            .compactMap { $0 }
            .joined(separator: ", ")

            completion(address.isEmpty ? nil : address)
        }
    }


    func buildTransaction() -> Transaction? {
        guard let value = Double(amount.replacingOccurrences(of: ",", with: ".")) else {
            return nil
        }

        return Transaction(
            id: UUID().uuidString,
            category: category,
            amount: value,
            date: date,
            type: type,
            description: description,
            latitude: location?.latitude,
            longitude: location?.longitude
        )
    }
}
