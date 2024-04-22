//
//  RegisterView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/22.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: PersonViewModel
    
    var body: some View {
        VStack {
            TextField("电子邮件", text: $viewModel.inputEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("密码", text: $viewModel.inputPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("注册") {
                viewModel.register()
            }
        }
    }
}

#Preview {
    RegisterView(viewModel: PersonViewModel())
}
