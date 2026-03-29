//
//  OnboardingView.swift
//  FinControl
//
//  Created by Camila Vincensi on 04/01/26.
//

import SwiftUI

@MainActor
struct OnboardingView: View {

    @StateObject private var viewModel: OnboardingViewModel

    let onRegister: () -> Void
    let onLogin: () -> Void

    init(
        onRegister: @escaping () -> Void,
        onLogin: @escaping () -> Void
    ) {
        self.onRegister = onRegister
        self.onLogin = onLogin

        _viewModel = StateObject(
            wrappedValue: OnboardingViewModel()
        )
    }

    var body: some View {
        VStack {
            appTitle

            Spacer()

            slideContent

            Spacer()

            pageIndicator

            actionSection
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 0)
        }
    }
}

private extension OnboardingView {

    var currentSlide: OnboardingSlide {
            viewModel.slides[viewModel.currentSlideIndex]
        }

    var appTitle: some View {
        Text("FinControl")
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(Color("PrimaryGreen"))
            .padding(.top, 24)
    }

    var slideContent: some View {
        VStack(spacing: 16) {
            Image(systemName: currentSlide.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(Color("PrimaryGreen"))

            Text(currentSlide.title)
                .font(.title3)
                .multilineTextAlignment(.center)

            Text(currentSlide.description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
    }
}

private extension OnboardingView {

    var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.slides.indices, id: \.self) { index in
                Capsule()
                    .fill(
                        index == viewModel.currentSlideIndex
                        ? Color("PrimaryGreen")
                        : Color.gray.opacity(0.3)
                    )
                    .frame(
                        width: index == viewModel.currentSlideIndex ? 20 : 8,
                        height: 8
                    )
                    .onTapGesture {
                        viewModel.goToSlide(at: index)
                    }
            }
        }
        .padding(.bottom, 16)
    }
}

private extension OnboardingView {

    @ViewBuilder
    var actionSection: some View {
        if viewModel.isLastSlide {
            finalActionButtons
        } else {
            nextButton
        }
    }

    var finalActionButtons: some View {
        VStack(spacing: 12) {
            Button(action: onRegister) {
                Text("Criar Conta")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("PrimaryGreen"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Button(action: onLogin) {
                Text("Entrar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("PrimaryGreen"), lineWidth: 2)
                    )
                    .foregroundColor(Color("PrimaryGreen"))
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }

    var nextButton: some View {
        Button("Próximo") {
            viewModel.goToNextSlide()
        }
        .foregroundColor(Color("PrimaryGreen"))
        .padding(.bottom, 16)
    }
}
