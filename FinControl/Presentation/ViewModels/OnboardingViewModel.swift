//
//  OnboardingViewModel.swift
//  FinControl
//
//  Created by Camila Vincensi on 04/01/26.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    @Published var currentSlide: Int = 0

    let slides: [OnboardingSlide] = [
        OnboardingSlide(
            icon: "doc.text",
            title: "Organize suas finanças com facilidade",
            description: "Registre e acompanhe todas as suas transações em um só lugar"
        ),
        OnboardingSlide(
            icon: "chart.bar",
            title: "Acompanhe seus gastos e economias",
            description: "Visualize relatórios detalhados sobre suas finanças"
        ),
        OnboardingSlide(
            icon: "bell",
            title: "Receba alertas e mantenha o controle",
            description: "Defina metas e limites para manter suas finanças em dia"
        )
    ]

    var isLastSlide: Bool {
        currentSlide == slides.count - 1
    }

    func next() {
        guard currentSlide < slides.count - 1 else { return }
        currentSlide += 1
    }

    func goToSlide(_ index: Int) {
        currentSlide = index
    }
}
