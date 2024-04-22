//
//  ContentView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/18.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab = "index"
    
    @StateObject private var personViewModel = PersonViewModel() // 创建视图模型的实例
    
    var body: some View {
        TabView(selection: $selectedTab) {
            if personViewModel.isLoggedIn {
                IndexView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("首页")
                    }
                    .tag("index")
            } else {
                Text("请先进入个人中心登录")
                    .tabItem {
                        Image(systemName: "house")
                        Text("首页")
                    }
                    .tag("index")
            }
            PersonView(viewModel: personViewModel)
                .tabItem {
                    Image(systemName: "person")
                    Text("个人中心")
                }
                .tag("person")
        }
    }
}

#Preview {
    ContentView()
}
