//
//  TaskHomeView.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 07.04.2026.
//

import SwiftData
import SwiftUI

struct TaskHomeView: View {
    @Query(filter: #Predicate<Task> { !$0.isCompleted }) var tasks: [Task]
    @Query(filter: #Predicate<Task> { $0.isCompleted }) var completedTasks: [Task]
    
    @State private var viewModel = TaskHomeViewModel()
    
    
    var body: some View {
        let sections = viewModel.makeSections(tasks: tasks)
        
        NavigationStack {
            ZStack {
                VimloTheme.backgroundGradient
                    .ignoresSafeArea()

                Group {
                    if viewModel.isEmpty(tasks: tasks) {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 20) {
                                if completedTasks.count > 0 {
                                    NavigationLink {
                                        CompletedTasksView()
                                    } label: {
                                        CompletedEntryRowView(
                                            completedCount: completedTasks.count,
                                            isEmphasized: true
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }

                                TaskHomeEmptyStateView {
                                    viewModel.tappedPlusButton()
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 12)
                            .padding(.bottom, 120)
                        }
                    } else {
                        List {
                            if completedTasks.count > 0 {
                                NavigationLink {
                                    CompletedTasksView()
                                } label: {
                                    CompletedEntryRowView(completedCount: completedTasks.count)
                                }
                                .buttonStyle(.plain)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 6, trailing: 20))
                            }

                            ForEach(sections) { section in
                                Section {
                                    ForEach(section.tasks) { task in
                                        TaskRowView(
                                            task: task,
                                            sectionType: section.type,
                                            onDelete: viewModel.delete,
                                            onComplete: viewModel.complete
                                        )
                                        .listRowBackground(Color.clear)
                                        .listRowSeparator(.hidden)
                                        .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                                    }
                                } header: {
                                    TaskSectionHeaderView(section: section)
                                }
                                .listSectionSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .bottom) {
                Button {
                    viewModel.tappedPlusButton()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        Text("New Task")
                    }
                    .font(VimloTheme.buttonFont)
                    .foregroundStyle(VimloTheme.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(VimloTheme.brandPink)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.white.opacity(0.7), lineWidth: 1)
                    )
                    .shadow(color: VimloTheme.shadow, radius: 16, y: 10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 8)
                .background(VimloTheme.background.opacity(0.94))
            }
            .sheet(isPresented: $viewModel.isAddTaskSheetPresented) {
                NavigationStack {
                    TaskEditorView()
                }
            }
        }
    }
}

#Preview {
    TaskHomeView()
}

private struct TaskSectionHeaderView: View {
    let section: SectionModel

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: VimloTheme.symbol(for: section.type))
                .font(.caption.weight(.bold))
                .foregroundStyle(VimloTheme.accent(for: section.type))
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(VimloTheme.surface(for: section.type))
                )

            Text(section.title)
                .font(VimloTheme.cardTitleFont)
                .foregroundStyle(VimloTheme.ink)

            Spacer()

            Text("\(section.tasks.count)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(VimloTheme.accent(for: section.type))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(VimloTheme.surface(for: section.type))
                )
        }
        .textCase(nil)
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

private struct TaskHomeEmptyStateView: View {
    let onAdd: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "checklist.checked")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(VimloTheme.pinkAccent)
                .frame(width: 72, height: 72)
                .background(
                    Circle()
                        .fill(VimloTheme.brandPink.opacity(0.82))
                )

            VStack(spacing: 8) {
                Text("No active tasks yet")
                    .font(VimloTheme.heroTitleFont)
                    .foregroundStyle(VimloTheme.ink)

                Text("Start with one small task and let Vimlo keep the day feeling soft and tidy.")
                    .font(.subheadline)
                    .foregroundStyle(VimloTheme.secondaryInk)
                    .multilineTextAlignment(.center)
            }

            Button(action: onAdd) {
                Text("Add your first task")
                    .font(VimloTheme.buttonFont)
                    .foregroundStyle(VimloTheme.ink)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(VimloTheme.butter)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(VimloTheme.cardBackground.opacity(0.96))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(Color.white.opacity(0.72), lineWidth: 1)
        )
        .shadow(color: VimloTheme.shadow, radius: 20, y: 12)
    }
}
