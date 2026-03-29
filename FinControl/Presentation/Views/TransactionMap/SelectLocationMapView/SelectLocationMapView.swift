//
//  SelectLocationMapView.swift
//  FinControl
//
//  Created by Camila Vincensi on 08/01/26.
//

import SwiftUI
import MapKit

struct SelectLocationMapView: View {
    
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Environment(\.dismiss) private var dismiss

    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -23.5, longitude: -46.6),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $region,
                interactionModes: .all,
                annotationItems: selectedLocation != nil ? [LocationAnnotation(coordinate: selectedLocation!)] : []
            ) { item in
                MapMarker(coordinate: item.coordinate, tint: .green)
            }
                .frame(height: 250)
            .cornerRadius(12)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Button("Selecionar esta localização") {
                    selectedLocation = region.center
                    dismiss() // 👈 FECHA A TELA
                }

                .padding()
                .background(Color("PrimaryGreen"))
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.bottom)
            }
        }
        .navigationTitle("Selecionar no mapa")
    }
    
    private var annotation: [LocationAnnotation] {
        if let selected = selectedLocation {
            return [LocationAnnotation(coordinate: selected)]
        } else {
            return []
        }
    }
}

struct LocationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
