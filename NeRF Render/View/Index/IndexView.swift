//
//  IndexView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/18.
//

import SwiftUI


struct IndexView: View {
    @StateObject var projectsViewModel: ProjectsViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                // 项目列表
                List {
                    ForEach(projectsViewModel.projects, id: \.id) { project in
                        NavigationLink(destination: ProjectDetailView(viewModel: ProjectDetailViewModel(project: project))) {
                            Text(project.title)
                        }
                    }
                    .onDelete(perform: projectsViewModel.deleteProject)
                }
                .navigationTitle("项目列表")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                .sheet(isPresented: $projectsViewModel.showingAddProjectSheet) {
                    NewProjectSheetView(viewModel: projectsViewModel)
                        .presentationDetents([.medium])
                }
                .onAppear {
                    projectsViewModel.fetchProjects()
                }
                
                // 添加新项目按钮
                VStack {
                    Spacer()
                    Button("添加新项目") {
                        projectsViewModel.showingAddProjectSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
        }
    }
}


#Preview {
    IndexView(projectsViewModel: ProjectsViewModel())
}
