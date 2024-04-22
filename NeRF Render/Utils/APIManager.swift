//
//  APIManager.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/18.
//

import Foundation


struct APIManager {
    static let shared = APIManager()
    private init() {}
    
    // JSONDecoder 实例化
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"  // 修改为与后端格式匹配
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    // MARK: - 用户操作
    
    // 登录
    func login(email: String, password: String, completion: @escaping (ApiResponse<User>?, Error?) -> Void) {
        let url = URL(string: "http://example.com/nerf/login/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email, "password": password]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let response = try self.decoder.decode(ApiResponse<User>.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    // 修改密码
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (ApiResponse<Empty>?, Error?) -> Void) {
        let url = URL(string: "http://example.com/nerf/change_password/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["old_password": oldPassword, "new_password": newPassword]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let response = try self.decoder.decode(ApiResponse<Empty>.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    // 注销
    func logout(completion: @escaping (ApiResponse<Empty>?, Error?) -> Void) {
        let url = URL(string: "http://example.com/nerf/logout/")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let response = try self.decoder.decode(ApiResponse<Empty>.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    // MARK: - 项目操作
    
    // 查询所有项目
    func fetchProjects(completion: @escaping (ApiResponse<[Project]>?, Error?) -> Void) {
        let url = URL(string: "http://127.0.0.1:4523/m2/4334433-3977645-default/165314656")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let response = try self.decoder.decode(ApiResponse<[Project]>.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    // 创建项目
    func createProject(title: String, completion: @escaping (ApiResponse<Project>?, Error?) -> Void) {
        let url = URL(string: "http://127.0.0.1:4523/m2/4334433-3977645-default/165314619")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["title": title]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let response = try self.decoder.decode(ApiResponse<Project>.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    // 删除项目
    func deleteProject(projectId: Int, completion: @escaping (ApiResponse<Empty>?, Error?) -> Void) {
        let url = URL(string: "http://127.0.0.1:4523/m2/4334433-3977645-default/165314871")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["project_id": projectId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                completion(nil, error)
                return
            }
            if httpResponse.statusCode == 204 {
                completion(ApiResponse(success: true, message: "Project deleted successfully", data: Empty()), nil)  // No content to return, just indicate success
            } else {
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to delete the project"])
                completion(nil, error)
            }
        }.resume()
    }
    
    // 上传视频轨迹
    func uploadVideoTrajectory(projectId: Int, trajectoryData: Data, completion: @escaping (ApiResponse<CameraTrajectory>?, Error?) -> Void) {
        let url = URL(string: "http://example.com/nerf/project/upload_video_trajectory/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")

        // 创建multipart/form-data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // 添加项目ID部分
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"project_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(projectId)\r\n".data(using: .utf8)!)

        // 添加轨迹文件部分
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"trajectory_file\"; filename=\"trajectory.json\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
        body.append(trajectoryData)
        body.append("\r\n".data(using: .utf8)!)

        // 结束标记
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let response = try self.decoder.decode(ApiResponse<CameraTrajectory>.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    // 上传图片
    func uploadImage(projectId: Int, imageData: Data, completion: @escaping (ApiResponse<ProjectImage>?, Error?) -> Void) {
        let url = URL(string: "http://example.com/nerf/project/upload_image/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // 创建multipart/form-data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // 添加项目ID部分
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"project_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(projectId)\r\n".data(using: .utf8)!)

        // 添加图片文件部分
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image_file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        // 结束标记
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let response = try self.decoder.decode(ApiResponse<ProjectImage>.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }

    // 删除单张图片
    func deleteImage(imageId: Int, completion: @escaping (ApiResponse<Empty>?, Error?) -> Void) {
        let url = URL(string: "http://example.com/nerf/project/delete_image/")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["id": imageId]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { _, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                completion(nil, error)
                return
            }
            if httpResponse.statusCode == 204 {
                completion(ApiResponse(success: true, message: "Image deleted successfully", data: Empty()), nil)
            } else {
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to delete image"])
                completion(nil, error)
            }
        }.resume()
    }
    
    // 删除项目的所有图片
    func deleteAllImages(projectId: Int, completion: @escaping (ApiResponse<Empty>?, Error?) -> Void) {
        let url = URL(string: "http://example.com/nerf/project/delete_all_images/")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["project_id": projectId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                completion(nil, error)
                return
            }
            if httpResponse.statusCode == 204 {
                completion(ApiResponse(success: true, message: "All images deleted successfully", data: Empty()), nil)
            } else {
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to delete images"])
                completion(nil, error)
            }
        }.resume()
    }
    
    // 获取项目的所有图片
    func getProjectImages(projectId: Int, completion: @escaping (ApiResponse<[ProjectImage]>?, Error?) -> Void) {
        let url = URL(string: "http://127.0.0.1:4523/m2/4334433-3977645-default/165811946")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["project_id": projectId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let response = try self.decoder.decode(ApiResponse<[ProjectImage]>.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    // 获取特定项目的模型快照
    func getProjectModelSnapshots(projectId: Int, completion: @escaping (ApiResponse<[NerfModel]>?, Error?) -> Void) {
        let url = URL(string: "http://example.com/nerf/project/get_nerf_snapshots/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["project_id": projectId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let response = try self.decoder.decode(ApiResponse<[NerfModel]>.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    // 删除特定项目的模型快照
    func deleteProjectModelSnapshots(projectId: Int, completion: @escaping (ApiResponse<Empty>?, Error?) -> Void) {
        let url = URL(string: "http://example.com/nerf/project/delete_nerf_snapshots/")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["project_id": projectId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                completion(nil, error)
                return
            }
            if httpResponse.statusCode == 204 {
                completion(ApiResponse(success: true, message: "Nerf snapshots deleted successfully", data: Empty()), nil)
            } else {
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to delete Nerf snapshots"])
                completion(nil, error)
            }
        }.resume()
    }
    
    // 获取项目的所有图片位姿
    func getProjectPoses(projectId: Int, completion: @escaping (ApiResponse<[Pose]>?, Error?) -> Void) {
        let url = URL(string: "http://example.com/nerf/project/get_poses/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["project_id": projectId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let response = try self.decoder.decode(ApiResponse<[Pose]>.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    // 删除项目的所有图片位姿
    func deleteProjectPoses(projectId: Int, completion: @escaping (ApiResponse<Empty>?, Error?) -> Void) {
        let url = URL(string: "http://example.com/nerf/project/delete_poses/")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["project_id": projectId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                completion(nil, error)
                return
            }
            if httpResponse.statusCode == 204 {
                completion(ApiResponse(success: true, message: "Poses deleted successfully", data: Empty()), nil)
            } else {
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to delete poses"])
                completion(nil, error)
            }
        }.resume()
    }
    
    // 获取项目的所有渲染视频文件
    func getProjectVideos(projectId: Int, completion: @escaping (ApiResponse<[Video]>?, Error?) -> Void) {
        let url = URL(string: "http://example.com/nerf/project/get_videos/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["project_id": projectId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                let response = try self.decoder.decode(ApiResponse<[Video]>.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    // 删除项目的所有渲染视频文件
    func deleteProjectVideos(projectId: Int, completion: @escaping (ApiResponse<Empty>?, Error?) -> Void) {
        let url = URL(string: "http://example.com/nerf/project/delete_videos/")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["project_id": projectId]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                completion(nil, error)
                return
            }
            if httpResponse.statusCode == 204 {
                completion(ApiResponse(success: true, message: "Videos deleted successfully", data: Empty()), nil)
            } else {
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to delete videos"])
                completion(nil, error)
            }
        }.resume()
    }
}
