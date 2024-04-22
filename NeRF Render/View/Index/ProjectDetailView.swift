//
//  ProjectDetailView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/18.
//

import SwiftUI

struct ProjectDetailView: View {
    @StateObject var viewModel: ProjectDetailViewModel

    var body: some View {
        VStack {
            ScrollView {
                projectInformationSectionView
                
                NavigationLink(destination: TrainRenderView(viewModel: viewModel)) {
                    Text("模型训练和视频渲染")
                }
                .padding()

            }
            
            actionButtonsSectionView
            
            Spacer()
            Spacer()
        }
        .padding()
        .background(Color("Background"))
        .navigationTitle("项目详情")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchImages()
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
                    ForEach(viewModel.projectImages, id: \.id) { image in
                        AsyncImage(url: URL(string: image.imageUrl)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 192, height: 108)
                        .cornerRadius(8)
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
