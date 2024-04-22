//
//  Model.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/21.
//

import Foundation


// 定义一个泛型结构体来解析常见的API响应格式
struct ApiResponse<T: Codable>: Codable {
    var success: Bool
    var message: String
    var data: T
}

// 应定义一个替代Empty结构体，不包含数据
struct Empty: Codable {}

// 用户模型
struct User: Identifiable, Codable {
    var id: Int
    var email: String
    var password: String?
    var lastLogin: Date?
    
    // 提供示例数据
    static let example = User(
        id: 1,
        email: "user_first@qq.com",
        password: "user_passward",
        lastLogin: Date()
    )
    
    enum CodingKeys: String, CodingKey {
        case id, email, password, lastLogin = "last_login"
    }
}


// 项目模型
struct Project: Identifiable, Codable {
    var id: Int
    var title: String
    var createdAt: Date
    var ownerId: Int
    
    // 提供示例数据
    static let example = Project(
        id: 1,
        title: "示例项目",
        createdAt: Date(),
        ownerId: 1
    )

    enum CodingKeys: String, CodingKey {
        case id, title, createdAt = "created_at", ownerId = "owner_id"
    }
}


// 图片模型
struct ProjectImage: Identifiable, Codable {
    var id: Int
    var imageUrl: String
    var uploadedAt: Date
    var projectId: Int

    // 提供示例数据
    static let example = ProjectImage(
        id: 1,
        imageUrl: "http://example.com/image.png",
        uploadedAt: Date(),
        projectId: 1
    )

    enum CodingKeys: String, CodingKey {
        case id, imageUrl = "image_file", uploadedAt = "uploaded_at", projectId = "project_id"
    }
}

// 相机路径模型
struct CameraTrajectory: Identifiable, Codable {
    var id: Int
    var name: String
    var fileUrl: String
    var uploadedAt: Date

    // 提供示例数据
    static let example = CameraTrajectory(
        id: 1,
        name: "base",
        fileUrl: "http://example.com/trajectory.json",
        uploadedAt: Date()
    )

    enum CodingKeys: String, CodingKey {
        case id, name = "name", fileUrl = "file", uploadedAt = "uploaded_at"
    }
}

// 图片位姿模型
struct Pose: Identifiable, Codable {
    var id: Int
    var fileUrl: String
    var uploadedAt: Date
    var projectId: Int

    // 提供示例数据
    static let example = Pose(
        id: 1,
        fileUrl: "http://example.com/pose.json",
        uploadedAt: Date(),
        projectId: 1
    )

    enum CodingKeys: String, CodingKey {
        case id, fileUrl = "file", uploadedAt = "uploaded_at", projectId = "project_id"
    }
}

// NeRF模型快照模型
struct NerfModel: Identifiable, Codable {
    var id: Int
    var fileUrl: String
    var uploadedAt: Date
    var projectId: Int

    // 提供示例数据
    static let example = NerfModel(
        id: 1,
        fileUrl: "http://example.com/model.ingp",
        uploadedAt: Date(),
        projectId: 1
    )

    enum CodingKeys: String, CodingKey {
        case id, fileUrl = "file", uploadedAt = "uploaded_at", projectId = "project_id"
    }
}

// 视频模型
struct Video: Identifiable, Codable {
    var id: Int
    var videoUrl: String
    var renderedAt: Date
    var projectId: Int

    // 提供示例数据
    static let example = Video(
        id: 1,
        videoUrl: "http://example.com/video.mp4",
        renderedAt: Date(),
        projectId: 1
    )

    enum CodingKeys: String, CodingKey {
        case id, videoUrl = "video_file", renderedAt = "rendered_at", projectId = "project_id"
    }
}
