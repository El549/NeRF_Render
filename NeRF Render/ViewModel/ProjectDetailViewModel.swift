//
//  ProjectDetailViewModel.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/21.
//

import Foundation
import UIKit

class ProjectDetailViewModel: ObservableObject {
    @Published var projectImages: [ProjectImage] = []
    @Published var poses: [Pose] = []
    @Published var nerfModels:[NerfModel] = []
    @Published var videos: [Video] = []
    
    @Published var progressAmount: Double = 0.0
    @Published var isProgressing: Bool = false
    @Published var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    let project: Project
    @Published var n_steps: Int = 1000
    let n_steps_arrays = [1000, 5000, 15000, 20000, 50000]

    @Published var selected_trajectory = "1"
    let trajectories = ["1", "2", "3", "4"]

    @Published var video_fps = 5
    @Published var video_n_seconds = 1
    
//    @Published var isComputePoseCompleted = false
//    @Published var isTrainingCompleted = false
//    @Published var isRenderingCompleted = false
    
    @Published var hasComputePoseFile = false
    @Published var hasNerfModel = false
    @Published var hasVedio = false
    
    @Published var receivedMessage: String = ""
    @Published var operationCompleted: Bool = false  // 新增操作完成标志

    init(project: Project) {
        self.project = project
    }
    
    // 查询位姿文件列表
    func fetchPoses() {
        // 清空位姿文件列表
        poses.removeAll()
        // 实现从数据源获取项目的逻辑
        APIManager.shared.getProjectPoses(projectId: project.id) { response, error in
            if let poses = response?.data {
                DispatchQueue.main.async {
                    self.poses = poses
                    
                    if poses.first != nil {
                        self.hasComputePoseFile = true
                    }
                }
            } else {
                print("An error occurred: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    // 删除位姿文件
    func deletePose(at offsets: IndexSet) {
        offsets.forEach { index in
            let projectId = poses[index].projectId
            APIManager.shared.deleteProjectPoses(projectId: projectId) { response, error in
                if response?.success == true {
                    DispatchQueue.main.async {
                        self.poses.remove(atOffsets: offsets)
                        self.hasComputePoseFile = false
                    }
                    print("Pose deleted successfully")
                    
                } else {
                    print("Failed to delete Pose: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    // 查询模型文件
    func fetchNerfModel() {
        // 清空模型文件列表
        nerfModels.removeAll()
        // 实现从数据源获取项目的逻辑
        APIManager.shared.getProjectModelSnapshots(projectId: project.id) { response, error in
            if let nerfModels = response?.data {
                DispatchQueue.main.async {
                    self.nerfModels = nerfModels
                    
                    if nerfModels.first != nil {
                        self.hasNerfModel = true
                    }
                }
            } else {
                print("An error occurred: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    // 删除模型文件
    func deleteNerfModel(at offsets: IndexSet) {
        offsets.forEach { index in
            let projectId = nerfModels[index].projectId
            APIManager.shared.deleteProjectModelSnapshots(projectId: projectId) { response, error in
                if response?.success == true {
                    DispatchQueue.main.async {
                        self.nerfModels.remove(atOffsets: offsets)
                        self.hasNerfModel = false
                    }
                    print("NerfModel deleted successfully")
                    
                } else {
                    print("Failed to delete NerfModel: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }

    // 查询视频文件
    func fetchVideo() {
        // 清空视频文件列表
        videos.removeAll()
        // 实现从数据源获取项目的逻辑
        APIManager.shared.getProjectVideos(projectId: project.id) { response, error in
            if let videos = response?.data {
                DispatchQueue.main.async {
                    self.videos = videos
                    
                    if videos.first != nil {
                        self.hasVedio = true
                    }
                }
            } else {
                print("An error occurred: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    // 删除视频文件
    func deleteVideo(at offsets: IndexSet) {
        offsets.forEach { index in
            let projectId = videos[index].projectId
            APIManager.shared.deleteProjectVideos(projectId: projectId) { response, error in
                if response?.success == true {
                    DispatchQueue.main.async {
                        self.videos.remove(atOffsets: offsets)
                        self.hasVedio = false
                    }
                    print("Videos deleted successfully")
                    
                } else {
                    print("Failed to delete Videos: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    // 查询图片
    func fetchImages() {
        // 清空图片列表
        projectImages.removeAll()
        
        APIManager.shared.getProjectImages(projectId: project.id) { response, error in
            DispatchQueue.main.async {
                if let images = response?.data {
                    self.projectImages = images
                } else {
                    print("Failed to fetch images: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }

    func startProgress() {
        isProgressing = true
        progressAmount = 0
    }

    func capturePhoto() {
        // 拍摄照片函数实现
    }

    func computePose() {
        startProgress()

        let urlString = "ws://192.168.31.161:8000/ws/pose/"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        WebSocketManager.shared.connect(to: url) {
            print("Connection established.")
        }

        WebSocketManager.shared.onReceivedMessage = { [weak self] message in
            var shouldDisconnect = false  // 初始设为不断开连接
            DispatchQueue.main.async {
                if message.contains("success") {
                    self?.receivedMessage = message
                    
                    self?.operationCompleted = true  // 标记操作已完成
                    shouldDisconnect = true  // 收到成功消息，需要断开连接
                    
                    // 操作成功，重新加载位姿数据
                    self?.fetchPoses()
                } else {
                    self?.receivedMessage = "In progress: \(message)"
                }
                if shouldDisconnect {
                    WebSocketManager.shared.disconnect()
                    // 设置一个计时器来清除勾选标志
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.operationCompleted = false  // 2秒后清除勾选标志
                        self?.isProgressing = false //关闭窗口
                    }
                }
            }
            return shouldDisconnect  // 返回是否需要断开连接的布尔值
        }

        let message = [
            "project_id": "\(project.id)",
            "colmap_matcher": "exhaustive",
            "aabb_scale": "4"
        ]
        WebSocketManager.shared.send(data: message)
    }


    func startTraining() {
        startProgress()
        
        // 开始训练函数实现
        let urlString = "ws://192.168.31.161:8000/ws/train/"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        WebSocketManager.shared.connect(to: url) {
            print("Connection established.")
        }

        WebSocketManager.shared.onReceivedMessage = { [weak self] message in
            var shouldDisconnect = false  // 初始设为不断开连接
            DispatchQueue.main.async {
                if message.contains("success") {
                    self?.receivedMessage = message
                    
                    self?.operationCompleted = true  // 标记操作已完成
                    shouldDisconnect = true  // 收到成功消息，需要断开连接
                    
                    // 操作成功，重新加载位姿数据
                    self?.fetchNerfModel()
                } else {
                    self?.receivedMessage = "In progress: \(message)"
                }
                if shouldDisconnect {
                    WebSocketManager.shared.disconnect()
                    // 设置一个计时器来清除勾选标志
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.operationCompleted = false  // 2秒后清除勾选标志
                        self?.isProgressing = false //关闭窗口
                    }
                }
            }
            return shouldDisconnect  // 返回是否需要断开连接的布尔值
        }

        let message = [
            "project_id": "\(project.id)",
            "n_steps": "\(n_steps)"
        ]
        WebSocketManager.shared.send(data: message)
    }

    func startRendering() {
        startProgress()
        
        // 开始渲染函数实现
        let urlString = "ws://192.168.31.161:8000/ws/render/"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        WebSocketManager.shared.connect(to: url) {
            print("Connection established.")
        }

        WebSocketManager.shared.onReceivedMessage = { [weak self] message in
            var shouldDisconnect = false  // 初始设为不断开连接
            DispatchQueue.main.async {
                if message.contains("success") {
                    self?.receivedMessage = message
                    
                    self?.operationCompleted = true  // 标记操作已完成
                    shouldDisconnect = true  // 收到成功消息，需要断开连接
                    
                    // 操作成功，重新加载位姿数据
                    self?.fetchVideo()
                } else {
                    self?.receivedMessage = "In progress: \(message)"
                }
                if shouldDisconnect {
                    WebSocketManager.shared.disconnect()
                    // 设置一个计时器来清除勾选标志
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.operationCompleted = false  // 2秒后清除勾选标志
                        self?.isProgressing = false //关闭窗口
                    }
                }
            }
            return shouldDisconnect  // 返回是否需要断开连接的布尔值
        }

        let message = [
            "project_id": "\(project.id)",
            "trajectory_name": "base",
            "video_fps": "\(video_fps)",
            "video_n_seconds": "\(video_n_seconds)",
            "video_spp": "8",
            "video_output": "output_video.mp4"
        ]
        WebSocketManager.shared.send(data: message)

    }
    
    func DownloadVideo() {
        // 下载视频函数实现
        guard let urlString = videos.first?.videoUrl, let url = URL(string: urlString) else {
            print("Invalid URL or no video available")
            return
        }

        // 确保在主线程中执行UI操作
        DispatchQueue.main.async {
            UIApplication.shared.open(url)
        }
    }
    
}
