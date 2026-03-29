//
//  RegisterView.swift
//  FinControl
//
//  Created by Camila Vincensi on 05/01/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {

    // MARK: - State
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    @State private var loading = false

    @State private var nameError: String?
    @State private var emailError: String?
    @State private var passwordError: String?

    // MARK: - Actions
    let onRegister: () -> Void
    let onBackToLogin: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {

                    Spacer(minLength: 60)

                    // 🟢 Title
                    Text("FinControl")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("PrimaryGreen"))
                        .padding(.bottom, 8)

                    Text("Crie sua conta gratuita")
                        .foregroundColor(Color("TextGray"))
                        .padding(.bottom, 24)

                    VStack(spacing: 16) {

                        FormTextField(
                            placeholder: "Nome completo",
                            text: $name,
                            error: nameError
                        )

                        FormTextField(
                            placeholder: "E-mail",
                            text: $email,
                            error: emailError
                        )

                        FormTextField(
                            placeholder: "Senha",
                            text: $password,
                            isSecure: true,
                            error: passwordError
                        )

                        // 🔹 Criar conta
                        PrimaryButton(
                            title: "Criar conta",
                            loading: loading,
                            action: handleSubmit
                        )

                        // 🔹 Voltar para login
                        Button(action: onBackToLogin) {
                            Text("Já tem uma conta? Entrar")
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

    // MARK: - Validation

    private func validateForm() -> Bool {
        nameError = nil
        emailError = nil
        passwordError = nil

        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            nameError = "Digite seu nome completo"
        }

        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            emailError = "Digite seu e-mail"
        } else if !email.contains("@") {
            emailError = "E-mail inválido"
        }

        if password.isEmpty {
            passwordError = "Digite sua senha"
        } else if password.count < 6 {
            passwordError = "A senha deve ter pelo menos 6 caracteres"
        }

        return nameError == nil &&
               emailError == nil &&
               passwordError == nil
    }

    // MARK: - Firebase

    private func handleSubmit() {
        guard validateForm() else { return }

        loading = true

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            loading = false

            if let error {
                print(error.localizedDescription)

                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .emailAlreadyInUse:
                        emailError = "Este e-mail já está cadastrado"
                    case .invalidEmail:
                        emailError = "E-mail inválido"
                    case .weakPassword:
                        passwordError = "A senha deve ter pelo menos 6 caracteres"
                    default:
                        emailError = "Não foi possível criar a conta"
                    }
                }
                return
            }

            guard let user = result?.user else { return }

            // 🔹 Atualiza nome no Auth
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges()

            // 🔹 Salva no Firestore
            Firestore.firestore()
                .collection("users")
                .document(user.uid)
                .setData([
                    "name": name,
                    "email": email,
                    "createdAt": Timestamp(date: Date())
                ])

            onRegister()
        }
    }
}
