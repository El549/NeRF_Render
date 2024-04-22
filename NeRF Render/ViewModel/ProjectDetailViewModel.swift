//
//  ProjectDetailViewModel.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/21.
//

import Foundation

class ProjectDetailViewModel: ObservableObject {
    @Published var projectImages: [ProjectImage] = []
    @Published var progressAmount: Double = 0.0
    @Published var isProgressing: Bool = false
    
    let project: Project
    var n_steps: Int = 5000
    let n_steps_arrays = [1000, 5000, 15000, 20000, 50000]

    var selected_trajectory = "1"
    let trajectories = ["1", "2", "3", "4"]

    var video_fps = 30
    var video_n_seconds = 10

    init(project: Project) {
        self.project = project
    }

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
    }

    func startTraining() {
        startProgress()
        // 开始训练函数实现
    }

    func startRendering() {
        startProgress()
        // 开始渲染函数实现
    }
}
