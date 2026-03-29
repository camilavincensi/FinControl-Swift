import SwiftUI

@MainActor
struct LoginView: View {

    @StateObject private var viewModel: AuthViewModel

    let onLogin: (_ userId: String) -> Void
    let onRegister: () -> Void

    init(
        onLogin: @escaping (_ userId: String) -> Void,
        onRegister: @escaping () -> Void
    ) {
        self.onLogin = onLogin
        self.onRegister = onRegister

        _viewModel = StateObject(
            wrappedValue: DIContainer.shared.makeAuthViewModel()
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {

                    Spacer(minLength: 60)

                    Text("FinControl")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("PrimaryGreen"))
                        .padding(.bottom, 8)

                    Text("Entre na sua conta")
                        .foregroundColor(Color("TextGray"))
                        .padding(.bottom, 24)

                    VStack(spacing: 16) {

                        FormTextField(
                            placeholder: "E-mail",
                            text: $viewModel.email,
                            error: viewModel.emailError
                        )

                        FormTextField(
                            placeholder: "Senha",
                            text: $viewModel.password,
                            isSecure: true,
                            error: viewModel.passwordError
                        )

                        Button("Esqueceu sua senha?") {
                            viewModel.resetPassword()
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("PrimaryGreen"))
                        .frame(maxWidth: .infinity, alignment: .trailing)

                        PrimaryButton(
                            title: "Entrar",
                            loading: viewModel.isLoading,
                            action: {
                                viewModel.login { userId in
                                    onLogin(userId)
                                }
                            }
                        )

                        if let generalError = viewModel.generalError {
                            Text(generalError)
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        if let successMessage = viewModel.successMessage {
                            Text(successMessage)
                                .font(.system(size: 14))
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Button(action: onRegister) {
                            Text("Ainda não tem conta? Cadastre-se")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color("PrimaryGreen"))
                        }
                        .padding(.top, 16)
                    }
                }
                .padding(.horizontal, 24)
            }
            .background(Color("Background"))
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}
