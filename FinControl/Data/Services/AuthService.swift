//
//  AuthService.swift
//  FinControl
//
//  Created by Camila Vincensi on 04/01/26.
//

import Foundation
import FirebaseAuth

final class AuthService: ObservableObject {

    @Published var user: User?

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }

    deinit {
        if let handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
