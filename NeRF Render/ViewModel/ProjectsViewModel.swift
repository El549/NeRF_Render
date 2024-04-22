//
//  ProjectsViewModel.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/21.
//

import Foundation

class ProjectsViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var newProjectTitle: String = ""
    @Published var showingAddProjectSheet: Bool = false

    func fetchProjects() {
        // 实现从数据源获取项目的逻辑
        APIManager.shared.fetchProjects { response, error in
            if let projects = response?.data {
                DispatchQueue.main.async {
                    self.projects = projects
                }
            } else {
                print("An error occurred: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func addProject() {
        if newProjectTitle.isEmpty {
            return
        }
        // 添加项目到数据源的逻辑
        APIManager.shared.createProject(title: newProjectTitle) { response, error in
            if let response = response, response.success {
                DispatchQueue.main.async {
                    self.projects.append(response.data)  // Assuming response.data is the new project
                    self.newProjectTitle = ""
                    self.showingAddProjectSheet = false
                }
                print("Project created successfully")
            } else {
                print("Failed to create project: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        // 清空输入并关闭表单
        newProjectTitle = ""
        showingAddProjectSheet = false
        fetchProjects()
    }

    func deleteProject(at offsets: IndexSet) {
        // 删除项目的逻辑
        offsets.forEach { index in
            let projectId = projects[index].id
            APIManager.shared.deleteProject(projectId: projectId) { response, error in
                if response?.success == true {
                    DispatchQueue.main.async {
                        self.projects.remove(atOffsets: offsets)
                    }
                    print("Project deleted successfully")
                } else {
                    print("Failed to delete project: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
}
