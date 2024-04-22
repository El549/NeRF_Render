//
//  TrainRenderView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/22.
//

import SwiftUI

struct TrainRenderView: View {
    @StateObject var viewModel: ProjectDetailViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                
                List {
                    Section("位姿计算") {
                        if viewModel.hasComputePoseFile {
                            ForEach(viewModel.poses, id: \.id) { pose in
                                Text(pose.fileUrl)
                            }
                            .onDelete(perform: viewModel.deletePose)
                            
                            Button("重新计算", action: viewModel.computePose)
                        } else {
//                            Button("未训练，无位姿文件", action: viewModel.computePose)
//                                .disabled(!viewModel.hasComputePoseFile)
                            Button("开始计算", action: viewModel.computePose)
                        }
                    }
                    
                    Section("模型训练") {
                        trainingParametersSectionView
                        
                        if viewModel.hasNerfModel {
                            ForEach(viewModel.nerfModels, id: \.id) { nerfModel in
                                Text(nerfModel.fileUrl)
                            }
                            .onDelete(perform: viewModel.deleteNerfModel)
                            
                            Button("重新训练", action: viewModel.startTraining)
                                .disabled(!viewModel.hasComputePoseFile)
                        } else {
//                            Button("未训练，无模型文件", action: viewModel.startTraining)
//                                .disabled(!viewModel.hasNerfModel)
                            Button("开始训练", action: viewModel.startTraining)
                                .disabled(!viewModel.hasComputePoseFile)
                        }
                    }
                    
                    Section("视频") {
                        renderingVideoParametersSectionView
                        Stepper("视频帧率: \(viewModel.video_fps)", value: $viewModel.video_fps, in: 1...60)
                        Stepper("视频时长: \(viewModel.video_n_seconds) 秒", value: $viewModel.video_n_seconds, in: 1...20)
                        
                        if viewModel.hasVedio {
                            Button("重新渲染", action: viewModel.startRendering)
                                .disabled(!viewModel.hasNerfModel)
                        } else {
                            Button("开始渲染", action: viewModel.startRendering)
                                .disabled(!viewModel.hasNerfModel)
                        }
                        
                    }
                    
                    Section("视频下载") {
                        if viewModel.hasVedio {
                            ForEach(viewModel.videos, id: \.id) { video in
                                Text(video.videoUrl)
                            }
                            .onDelete(perform: viewModel.deleteVideo)
                        } else {
//                            Button("未渲染，无视频文件", action: viewModel.startRendering)
//                                .disabled(!viewModel.hasVedio)
                        }
                        
                        Button("下载", action: viewModel.DownloadVideo)
                            .disabled(!viewModel.hasVedio)
                    }
                }
                .onAppear {
                    viewModel.fetchPoses()
                    viewModel.fetchNerfModel()
                    viewModel.fetchVideo()
                }

                
                if viewModel.isProgressing {
                    ProgressView("正在处理...", value: viewModel.progressAmount, total: 100)
                        .onReceive(viewModel.timer) { _ in
                            if viewModel.progressAmount < 100 {
                                viewModel.progressAmount += 1
                            }
                            if viewModel.progressAmount == 100 {
                                viewModel.isProgressing = false
                            }
                        }
                        .padding()
                }
            }
        }
        .navigationTitle("模型训练和视频渲染")
    }
    
    // 训练参数选择视图
    private var trainingParametersSectionView: some View {
        HStack {
            Picker("训练步数", selection: $viewModel.n_steps) {
                ForEach(viewModel.n_steps_arrays, id: \.self) {
                    Text($0, format: .number)
                }
            }
            .pickerStyle(.menu)
            Spacer()
        }
    }

    // 视频渲染参数选择视图
    private var renderingVideoParametersSectionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("视频轨迹")
            Picker("视频轨迹", selection: $viewModel.selected_trajectory) {
                ForEach(viewModel.trajectories, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)

        }
    }
    
}

#Preview {
    TrainRenderView(viewModel: ProjectDetailViewModel(project: Project.example))
}
