//
//  PersonViewModel.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/22.
//

import Foundation

class PersonViewModel: ObservableObject {
    @Published var user: User?  // Optional，因为未登录状态下没有用户
    
    @Published var inputEmail: String = ""
    @Published var inputPassword: String = ""
    
    @Published var inputOldPassword: String = ""
    @Published var inputNewPassword: String = ""
    
    @Published var showingLoginSheet: Bool = false
    @Published var showingRegisterSheet: Bool = false
    @Published var showingChangePasswordSheet: Bool = false
    @Published var showingSettingsSheet: Bool = false
    
    @Published var loginMessage: String = ""
    @Published var isLoggedIn = false
    
    
    func login() {
        APIManager.shared.login(email: inputEmail, password: inputPassword) { response, error in
            if let response = response, response.success {
                DispatchQueue.main.async {
                    self.user = response.data[0]
                    self.isLoggedIn = true
                }
                print("登录成功")
            } else {
                print("登录失败: \(error?.localizedDescription ?? "Unknown error")")
            }

        }
        // 清空输入并关闭表单
        inputEmail = ""
        inputPassword = ""
        showingLoginSheet = false
    }
    
    func logout() {
        APIManager.shared.logout() { response, error in
            if let response = response, response.success {
                DispatchQueue.main.async {
                    self.isLoggedIn = false
                }
                print("登出成功")
            } else {
                print("登出失败: \(error?.localizedDescription ?? "Unknown error")")
            }

        }
    }
    
    func register() {
        APIManager.shared.register(email: inputEmail, password: inputPassword) { response, error in
            if let response = response, response.success {
                DispatchQueue.main.async {
                    self.user = response.data[0]
                    self.isLoggedIn = true
                }
                print("注册成功")
            } else {
                print("注册失败: \(error?.localizedDescription ?? "Unknown error")")
            }

        }
        // 清空输入并关闭表单
        inputEmail = ""
        inputPassword = ""
        showingRegisterSheet = false
    }
    
    func changePassword() {
        APIManager.shared.changePassword(oldPassword: inputOldPassword, newPassword: inputNewPassword) { response, error in
            if let response = response, response.success {
                DispatchQueue.main.async {
                    self.isLoggedIn = false
                }
                print("修改密码成功，请重新登录")
            } else {
                print("修改密码失败: \(error?.localizedDescription ?? "Unknown error")")
            }

        }
        // 清空输入并关闭表单
        inputOldPassword = ""
        inputNewPassword = ""
        showingChangePasswordSheet = false
    }

}

