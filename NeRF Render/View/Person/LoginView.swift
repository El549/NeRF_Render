//
//  LoginView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/22.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: PersonViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 50, height: 50)
            TextField("电子邮件", text: $viewModel.inputEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.emailAddress) // 使用电子邮件键盘，仅英文字符
                .autocapitalization(.none) // 关闭首字母大写
                .disableAutocorrection(true) // 关闭自动语法检测
            
            SecureField("密码", text: $viewModel.inputPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.asciiCapable) // ASCII 键盘保证只有英文字符
                .autocapitalization(.none) // 关闭首字母大写
                .disableAutocorrection(true) // 关闭自动语法检测
            
            Button("登录") {
                viewModel.login()
            }
        }
        .padding()
    }
}

#Preview {
    LoginView(viewModel: PersonViewModel())
}
