//
//  WebSocketManager.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/23.
//

import Foundation

class WebSocketManager {
    static let shared = WebSocketManager()
    private var webSocketTask: URLSessionWebSocketTask?
    
    var onReceivedMessage: ((String) -> Bool)?

    func connect(to url: URL, completion: @escaping () -> Void) {
        disconnect()
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        listen(completion: completion)
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
    }

    func sendMessage(_ message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error sending message: \(error)")
            }
        }
    }

    func send(data: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                sendMessage(jsonString)
            }
        } catch {
            print("Failed to encode JSON data: \(error)")
        }
    }

    private func listen(completion: @escaping () -> Void) {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error receiving message: \(error)")
            case .success(let message):
                if case .string(let text) = message {
                    print("Received message: \(text)")
                    if self?.onReceivedMessage?(text) ?? false {
                        completion()
                    }
                }
                self?.listen(completion: completion) // Continue listening for messages
            }
        }
    }
}
