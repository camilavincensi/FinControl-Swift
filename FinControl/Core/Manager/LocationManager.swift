//
//  LocationManager.swift
//  FinControl
//
//  Created by Camila Vincensi on 08/01/26.
//

import CoreLocation
import SwiftUI

import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()

    @Published var coordinate: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        let status = manager.authorizationStatus

        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        } else {
            print("❌ Permissão de localização negada")
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        coordinate = locations.first?.coordinate
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Erro de localização:", error.localizedDescription)
    }
}
