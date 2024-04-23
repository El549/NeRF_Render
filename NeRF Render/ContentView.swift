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
    @StateObject private var projectsViewModel = ProjectsViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            if personViewModel.isLoggedIn {
                IndexView(projectsViewModel: projectsViewModel)
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
            PersonView(personViewModel: personViewModel, projectsViewModel: projectsViewModel)
                .tabItem {
                    Image(systemName: "person")
                    Text("个人中心")
                }
                .tag("person")
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            performActionForSelectedTab(newValue)
        }
    }
    private func performActionForSelectedTab(_ tab: String) {
        // 根据选中的标签执行不同的操作
        switch tab {
        case "index":
            print("首页被选中")
            projectsViewModel.fetchProjects()
        case "person":
            print("个人中心被选中")
            // 可以在这里执行更多的逻辑，比如验证用户登录状态等
        default:
            break
        }
    }
}

#Preview {
    ContentView()
}
