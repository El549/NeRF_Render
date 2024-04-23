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
//                                Text(pose.fileUrl)
                                HStack {
                                    Image(systemName: "doc")
                                    Text("transforms.json")
                                }
                            }
                            .onDelete(perform: viewModel.deletePose)
                            
                            Button("重新计算", action: viewModel.computePose)
                                .disabled(viewModel.isProgressing)
                        } else {
//                            Button("未训练，无位姿文件", action: viewModel.computePose)
//                                .disabled(!viewModel.hasComputePoseFile)
                            Button("开始计算", action: viewModel.computePose)
                                .disabled(viewModel.isProgressing)
                        }
                    }
                    
                    Section("模型训练") {
                        trainingParametersSectionView
                        
                        if viewModel.hasNerfModel {
                            ForEach(viewModel.nerfModels, id: \.id) { nerfModel in
//                                Text(nerfModel.fileUrl)
                                HStack {
                                    Image(systemName: "doc")
                                    Text("snap.ingp")
                                }
                            }
                            .onDelete(perform: viewModel.deleteNerfModel)
                            
                            Button("重新训练", action: viewModel.startTraining)
                                .disabled(!viewModel.hasComputePoseFile)
                                .disabled(viewModel.isProgressing)
                        } else {
//                            Button("未训练，无模型文件", action: viewModel.startTraining)
//                                .disabled(!viewModel.hasNerfModel)
                            Button("开始训练", action: viewModel.startTraining)
                                .disabled(!viewModel.hasComputePoseFile)
                                .disabled(viewModel.isProgressing)
                        }
                    }
                    
                    Section("视频") {
                        renderingVideoParametersSectionView
                        Stepper("视频帧率: \(viewModel.video_fps)", value: $viewModel.video_fps, in: 1...60)
                        Stepper("视频时长: \(viewModel.video_n_seconds) 秒", value: $viewModel.video_n_seconds, in: 1...20)
                        
                        if viewModel.hasVedio {
                            Button("重新渲染", action: viewModel.startRendering)
                                .disabled(!viewModel.hasNerfModel)
                                .disabled(viewModel.isProgressing)
                        } else {
                            Button("开始渲染", action: viewModel.startRendering)
                                .disabled(!viewModel.hasNerfModel)
                                .disabled(viewModel.isProgressing)
                        }
                        
                    }
                    
                    Section("视频下载") {
                        if viewModel.hasVedio {
                            ForEach(viewModel.videos, id: \.id) { video in
//                                Text(video.videoUrl)
                                HStack {
                                    Image(systemName: "doc")
                                    Text("output_video.mp4")
                                }
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
                    if !viewModel.operationCompleted {
                        VStack {
                            HStack {
                                Spacer()
                                
                                Text("Received Message: ")
                                    .font(.headline)
                                
                                Spacer()
                                
                                ProgressView() // 默认的旋转指示器
                                    .progressViewStyle(CircularProgressViewStyle()) // 明确使用圆形样式
                                    .scaleEffect(1.5) // 放大指示器的大小
                                    .padding()
                                
                                Spacer()
                            }
                            Text(viewModel.receivedMessage)
                        }
                        .padding()
                    } else {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                                .font(.largeTitle)
                                .scaleEffect(1.5)  // 放大图标
                                .transition(.scale)  // 添加缩放动画
                        }
                        .padding()
                    }
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
