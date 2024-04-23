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
            Image(systemName: "person.badge.key.fill")
                .resizable()
                .frame(width: 50, height: 50)
            
            TextField("旧密码", text: $viewModel.inputOldPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.asciiCapable) // ASCII 键盘保证只有英文字符
                .autocapitalization(.none) // 关闭首字母大写
                .disableAutocorrection(true) // 关闭自动语法检测
            
            SecureField("新密码", text: $viewModel.inputNewPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.asciiCapable) // ASCII 键盘保证只有英文字符
                .autocapitalization(.none) // 关闭首字母大写
                .disableAutocorrection(true) // 关闭自动语法检测
            
            Button("提交") {
                viewModel.changePassword()
            }
        }
        .padding()
    }
}

#Preview {
    ChangePasswordView(viewModel: PersonViewModel())
}
