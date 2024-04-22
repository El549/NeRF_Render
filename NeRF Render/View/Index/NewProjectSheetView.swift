//
//  NewProjectSheetView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/21.
//

import SwiftUI

import SwiftUI

struct NewProjectSheetView: View {
    @ObservedObject var viewModel: ProjectsViewModel

    var body: some View {
        VStack {
            TextField("输入新项目标题", text: $viewModel.newProjectTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("添加项目") {
                viewModel.addProject()
            }
            .padding()
            .background(viewModel.newProjectTitle.isEmpty ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(viewModel.newProjectTitle.isEmpty)
        }
        .padding()
    }
}


#Preview {
    NewProjectSheetView(viewModel: ProjectsViewModel())
}
