//
//  LoginView.swift
//  CryptoTracker
//
//  Created by Michael Winkler on 17.03.25.
//


import SwiftUI

struct AuthView: View {
    @StateObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.isRegistering ? "Registrieren" : "Anmelden")
                .font(.largeTitle)
                .bold()
            
            TextField("E-Mail", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal)
            
            SecureField("Passwort", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
            }
            
            Button(action: {
                Task {
                    if viewModel.isRegistering {
                        await viewModel.register()
                    } else {
                        await viewModel.signIn()
                    }
                }
            }) {
                Text(viewModel.isRegistering ? "Registrieren" : "Anmelden")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Button(action: {
                withAnimation {
                    viewModel.isRegistering.toggle()
                    viewModel.errorMessage = nil
                }
            }) {
                Text(viewModel.isRegistering ?
                     "Bereits einen Account? Jetzt anmelden" :
                     "Noch keinen Account? Jetzt registrieren")
                    .font(.footnote)
            }
            
            if !viewModel.isRegistering {
                Button("Passwort vergessen?") {
                    Task {
                        await viewModel.sendPasswordReset()
                    }
                }
                .font(.footnote)
            }
        }
        .padding()
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel())
}

