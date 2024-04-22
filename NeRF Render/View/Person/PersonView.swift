//
//  PersonView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/18.
//

import SwiftUI

struct PersonView: View {
    @State private var showingSheet = false
    @State private var sheetType: SheetType = .settings
    
    enum SheetType {
        case login, register, settings
    }
    
    var body: some View {
        NavigationStack {
            List {
                Button(action: {
                    sheetType = .login
                    showingSheet = true
                }) {
                    HStack {
                        Image(systemName: "person.fill")
                        Text("登录")
                    }
                }
                Button(action: {
                    sheetType = .register
                    showingSheet = true
                }) {
                    HStack {
                        Image(systemName: "person.badge.plus")
                        Text("注册")
                    }
                }
                Button(action: {
                    //退出登录操作
                }) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.left")
                        Text("退出登录")
                    }
                }
            }
            .navigationTitle("个人中心")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        sheetType = .settings
                        showingSheet = true
                    }) {
                        Label("设置", systemImage: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingSheet) {
                sheetView(for: sheetType)
                    .presentationDetents([.medium])
            }
        }
    }

    private func buttonWithIcon(name: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: name)
                Text(label)
                Spacer()
            }
            .padding()
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
    
    @ViewBuilder
    private func sheetView(for type: SheetType) -> some View {
        switch type {
        case .login:
            Text("登录界面")
        case .register:
            Text("注册界面")
        case .settings:
            SettingsView()
        }
    }
}

#Preview {
    PersonView()
}
