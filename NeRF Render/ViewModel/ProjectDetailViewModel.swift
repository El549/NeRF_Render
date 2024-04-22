//
//  ProjectDetailViewModel.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/21.
//

import Foundation

class ProjectDetailViewModel: ObservableObject {
    @Published var projectImages: [ProjectImage] = []
    @Published var poses: [Pose] = []
    @Published var nerfModels:[NerfModel] = []
    @Published var videos: [Video] = []
    
    @Published var progressAmount: Double = 0.0
    @Published var isProgressing: Bool = false
    @Published var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    let project: Project
    @Published var n_steps: Int = 5000
    let n_steps_arrays = [1000, 5000, 15000, 20000, 50000]

    @Published var selected_trajectory = "1"
    let trajectories = ["1", "2", "3", "4"]

    @Published var video_fps = 30
    @Published var video_n_seconds = 10
    
//    @Published var isComputePoseCompleted = false
//    @Published var isTrainingCompleted = false
//    @Published var isRenderingCompleted = false
    
    @Published var hasComputePoseFile = false
    @Published var hasNerfModel = false
    @Published var hasVedio = false

    init(project: Project) {
        self.project = project
    }
    
    // 查询位姿文件列表
    func fetchPoses() {
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
        // 位姿计算函数实现
        fetchPoses()
    }

    func startTraining() {
        startProgress()
        // 开始训练函数实现
        fetchNerfModel()
    }

    func startRendering() {
        startProgress()
        // 开始渲染函数实现
        fetchVideo()
    }
    
    func DownloadVideo() {
        startProgress()
        // 下载视频函数实现
    }
}
