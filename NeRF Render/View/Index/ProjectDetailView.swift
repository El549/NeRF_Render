//
//  ProjectDetailView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/18.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI

struct ProjectDetailView: View {
    @StateObject var viewModel: ProjectDetailViewModel

    var body: some View {
        VStack {
            ScrollView {
                projectInformationSectionView
                
                NavigationLink(destination: TrainRenderView(viewModel: viewModel)) {
                    HStack {
                        Text("模型训练和视频渲染")
                        Image(systemName: "chevron.right")
                    }
                }
                .padding()
                
//                if let urlString = viewModel.videos.first?.videoUrl, let url = URL(string: urlString) {
//
//                    VideoPlayer(player: AVPlayer(url: URL(string: "https://v-cdn.zjol.com.cn/276982.mp4")!))
//                            .edgesIgnoringSafeArea(.all)
//                            .aspectRatio(16/9, contentMode: .fit)
//                            .frame(width: 360)
//                            .cornerRadius(8)
//                } else {
//                    Text("No video URL available")
//                }
            }
            
            actionButtonsSectionView
            
            Spacer()
            Spacer()
        }
        .padding()
        .navigationTitle("项目详情")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.projectImages.isEmpty {
                viewModel.fetchImages()
            }
//            viewModel.fetchVideo()
        }
    }

    // 项目详情展示视图
    private var projectInformationSectionView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(viewModel.project.title)
                .font(.title)
                .fontWeight(.bold)
            Text("创建于 \(viewModel.project.createdAt)")
                .font(.subheadline)
                .foregroundColor(.gray)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.projectImages.indices, id: \.self) { index in
                        let image = viewModel.projectImages[index]
                        AsyncImage(url: URL(string: image.imageUrl)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill) // 保持图片的长宽比
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 192, height: 108)
                        .cornerRadius(8)
                        .contextMenu {
                            
                            Button(role: .destructive, action: {
                                viewModel.deleteImage(at: index)
                            }) {
                                Label("删除", systemImage: "trash")
                            }

                            
                        }
                    }
                }
            }

        }
        .padding(.vertical)
    }
    

    // 按钮视图
    private var actionButtonsSectionView: some View {
        VStack {
            Button("拍摄照片", action: viewModel.capturePhoto).buttonStyle(ActionButtonStyle())
        }
    }
}

// 按钮结构体风格
struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(16)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}


#Preview {
    ProjectDetailView(viewModel: ProjectDetailViewModel(project: Project.example))
}
