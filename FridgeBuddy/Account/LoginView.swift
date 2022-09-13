//
//  LoginView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-22.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @EnvironmentObject var launchViewModel : LaunchViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                IconView()
                
                Spacer()
                
                TextFieldView(text: "Email", value: $loginViewModel.email)
                
                SecureTextFieldView(text: "Password", value: $loginViewModel.password)
                
                Button {
                    Task {
                        await loginViewModel.signIn()
                        launchViewModel.checkLogin()
                    }
                } label: {
                   ButtonView(buttonText: "Sign In")
                }
                
                Spacer()
                
                NavigationLink(destination: SignUpView().offset(y: -50)) {
                    Text("Want to create an account? Sign Up")
                }
            }
            .padding()
            .alert(loginViewModel.alertItem.title, isPresented: $loginViewModel.alertItem.showAlert) {
                Button(loginViewModel.alertItem.buttonTitle) {}
            } message: {
                loginViewModel.alertItem.message
            }
            .navigationBarHidden(true)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
