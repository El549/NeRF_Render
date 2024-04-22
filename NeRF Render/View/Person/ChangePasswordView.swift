//
//  ChangePasswordView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/22.
//

import SwiftUI

struct ChangePasswordView: View {
    @ObservedObject var viewModel: PersonViewModel
    
    var body: some View {
        VStack {
            TextField("旧密码", text: $viewModel.inputOldPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("新密码", text: $viewModel.inputNewPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("提交") {
                viewModel.changePassword()
            }
        }
    }
}

#Preview {
    ChangePasswordView(viewModel: PersonViewModel())
}
