//
//  SignUView.swift
//  FridgeBuddy
//
//  Created by Amandeep on 2022-07-22.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var signUpViewModel = SignUpViewModel()
    @EnvironmentObject var launchViewModel : LaunchViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            IconView()
            
            Spacer()
            
            TextFieldView(text: "Name", value: $signUpViewModel.name)
            
            TextFieldView(text: "Email", value: $signUpViewModel.email)
            
            SecureTextFieldView(text: "Password", value: $signUpViewModel.password)
            
            SecureTextFieldView(text: "Confirm Password", value: $signUpViewModel.confirmPassword)                
            
            Button {
                Task {
                    await signUpViewModel.signUp()
                    launchViewModel.checkLogin()
                }
            } label: {
                ButtonView(buttonText: "Sign Up")
            }
            
            Spacer()
        }
        .padding()
        .alert(signUpViewModel.alertItem.title, isPresented: $signUpViewModel.alertItem.showAlert) {
            Button(signUpViewModel.alertItem.buttonTitle) {}
        } message: {
            signUpViewModel.alertItem.message
        }
    }
}

struct SignUView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
