//
//  TestView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/23.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI

struct TestView: View {
    var body: some View {
        ZStack{
            VideoPlayer(player: AVPlayer(url: URL(string: "https://v-cdn.zjol.com.cn/276982.mp4")!))
                .edgesIgnoringSafeArea(.all)
                .aspectRatio(16/9, contentMode: .fit)
                .frame(width: 360)
                .cornerRadius(8)
}
    }
}

#Preview {
    TestView()
}
