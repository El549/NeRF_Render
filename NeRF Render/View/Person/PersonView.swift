//
//  PersonView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/18.
//

import SwiftUI

struct PersonView: View {
    @StateObject var personViewModel:PersonViewModel
    @StateObject var projectsViewModel: ProjectsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    if personViewModel.isLoggedIn {
                        Text("Email: \(personViewModel.user?.email ?? "未登录")")
                        
                        Button(action: {
                            personViewModel.showingChangePasswordSheet = true
                        }) {
                            HStack {
                                Image(systemName: "person.badge.key.fill")
                                Text("修改密码")
                            }
                        }
                        
                    } else {
                        Button(action: {
                            personViewModel.showingLoginSheet = true
                        }) {
                            HStack {
                                Image(systemName: "person.fill")
                                Text("登录")
                            }
                        }
                        
                        Button(action: {
                            personViewModel.showingRegisterSheet = true
                        }) {
                            HStack {
                                Image(systemName: "person.fill.badge.plus")
                                Text("注册")
                            }
                        }
                    }
                }
                
                Section {
                    if personViewModel.isLoggedIn {
                        Button(action: {
                            personViewModel.logout()
                        }) {
                            HStack {
                                Spacer()
                                Text("退出登录")
                                    .foregroundColor(.red)
                                Spacer()
                            }
                        }
                    }
                }
                
                
            }
            .navigationTitle("个人中心")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        personViewModel.showingSettingsSheet = true
                    }) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                        }
                    }
                }
            }
            .sheet(isPresented: $personViewModel.showingLoginSheet) {
                LoginView(viewModel: personViewModel)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $personViewModel.showingRegisterSheet) {
                RegisterView(viewModel: personViewModel)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $personViewModel.showingChangePasswordSheet) {
                ChangePasswordView(viewModel: personViewModel)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $personViewModel.showingSettingsSheet) {
                SettingsView()
                    .presentationDetents([.medium])
            }
            
        }
    }
    
}


#Preview {
    PersonView(personViewModel: PersonViewModel(), projectsViewModel: ProjectsViewModel())
}
