//
//  PersonView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/18.
//

import SwiftUI

struct PersonView: View {
    @StateObject var viewModel:PersonViewModel
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    if viewModel.isLoggedIn {
                        Text("Email: \(viewModel.user?.email ?? "未登录")")
                        Button(action: {
                            viewModel.logout()
                        }) {
                            HStack {
                                Image(systemName: "person.fill")
                                Text("注销")
                            }
                        }
                        
                        Button(action: {
                            viewModel.showingChangePasswordSheet = true
                        }) {
                            HStack {
                                Image(systemName: "person.fill")
                                Text("修改密码")
                            }
                        }
                        
                    } else {
                        Button(action: {
                            viewModel.showingLoginSheet = true
                        }) {
                            HStack {
                                Image(systemName: "person.fill")
                                Text("登录")
                            }
                        }
                        
                        Button(action: {
                            viewModel.showingRegisterSheet = true
                        }) {
                            HStack {
                                Image(systemName: "person.fill")
                                Text("注册")
                            }
                        }
                    }
                }
                
                
            }
            .navigationTitle("个人中心")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showingSettingsSheet = true
                    }) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingLoginSheet) {
                LoginView(viewModel: viewModel)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $viewModel.showingRegisterSheet) {
                RegisterView(viewModel: viewModel)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $viewModel.showingChangePasswordSheet) {
                ChangePasswordView(viewModel: viewModel)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $viewModel.showingSettingsSheet) {
                SettingsView()
                    .presentationDetents([.medium])
            }
            
        }
    }
    
}


#Preview {
    PersonView(viewModel: PersonViewModel())
}
