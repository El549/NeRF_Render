//
//  IndexView.swift
//  NeRF Render
//
//  Created by LIU HengYu on 2024/4/18.
//

import SwiftUI

import SwiftUI

struct IndexView: View {
    @StateObject private var viewModel = ProjectsViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.projects, id: \.id) { project in
                        NavigationLink(destination: ProjectDetailView(viewModel: ProjectDetailViewModel(project: project))) {
                            Text(project.title)
                        }
                    }
                    .onDelete(perform: viewModel.deleteProject)
                }
                .navigationTitle("项目列表")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                .sheet(isPresented: $viewModel.showingAddProjectSheet) {
                    NewProjectSheetView(viewModel: viewModel)
                }
                .onAppear {
                    viewModel.fetchProjects()
                }

                VStack {
                    Spacer()
                    Button("添加新项目") {
                        viewModel.showingAddProjectSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
        }
    }
}


#Preview {
    IndexView()
}
