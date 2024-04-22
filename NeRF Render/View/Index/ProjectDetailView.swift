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
                trainingParametersSectionView
                renderingVideoParametersSectionView
                if viewModel.isProgressing {
                    ProgressView("正在处理...", value: viewModel.progressAmount, total: 100)
                        .padding()
                }
            }
            if !viewModel.isProgressing {
                actionButtonsSectionView
            }
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

    private var trainingParametersSectionView: some View {
        HStack {
            Text("训练步数").font(.headline)
            Picker("训练步数", selection: $viewModel.n_steps) {
                ForEach(viewModel.n_steps_arrays, id: \.self) {
                    Text($0, format: .number)
                }
            }
            .pickerStyle(.menu)
            Spacer()
        }
    }

    private var renderingVideoParametersSectionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("视频轨迹").font(.headline)
            Picker("视频轨迹", selection: $viewModel.selected_trajectory) {
                ForEach(viewModel.trajectories, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom)

            Stepper("视频帧率: \(viewModel.video_fps)", value: $viewModel.video_fps, in: 1...60)
            Stepper("视频时长: \(viewModel.video_n_seconds) 秒", value: $viewModel.video_n_seconds, in: 1...20)
        }
        .padding(.vertical)
    }

    private var actionButtonsSectionView: some View {
        VStack {
            Button("拍摄照片", action: viewModel.capturePhoto).buttonStyle(ActionButtonStyle())
            HStack(spacing: 20) {
                Button("位姿计算", action: viewModel.computePose).buttonStyle(ActionButtonStyle())
                Button("开始训练", action: viewModel.startTraining).buttonStyle(ActionButtonStyle())
                Button("开始渲染", action: viewModel.startRendering).buttonStyle(ActionButtonStyle())
            }
        }
    }
}

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

// Usage in your app
// ProjectDetailView(viewModel: ProjectDetailViewModel(project: Project.example))



#Preview {
    ProjectDetailView(viewModel: ProjectDetailViewModel(project: Project.example))
}
