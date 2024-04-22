//
//  ContentView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/18.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab = "index"
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            IndexView()
                .tabItem {
                    Image(systemName: "house")
                    Text("首页")
                }
                .tag("index")
            PersonView()
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
