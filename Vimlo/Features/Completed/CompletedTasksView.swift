//
//  CompletedTasksView.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 23.04.2026.
//

import SwiftUI
import SwiftData

struct CompletedTasksView: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<Task> { $0.isCompleted }) var tasks: [Task]
    @State private var viewModel = CompletedTasksViewModel()
    
    var body: some View {
        ZStack {
            VimloTheme.backgroundGradient
                .ignoresSafeArea()

            Group {
                if viewModel.isEmpty(tasks: tasks) {
                    CompletedEmptyStateView()
                        .padding(.horizontal, 20)
                } else {
                    List {
                        Section {
                            ForEach(viewModel.sortedTasks(tasks: tasks)) { task in
                                TaskRowView(
                                    task: task,
                                    onDelete: viewModel.delete,
                                    onComplete: viewModel.reactivate
                                )
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                            }
                        } header: {
                            CompletedHeaderView(completedCount: tasks.count)
                        }
                        .listSectionSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationTitle("Completed")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    CompletedTasksView()
}

private struct CompletedHeaderView: View {
    let completedCount: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Finished tasks")
                    .font(VimloTheme.cardTitleFont)
                    .foregroundStyle(VimloTheme.ink)

                Text("A calm record of your progress.")
                    .font(.caption)
                    .foregroundStyle(VimloTheme.secondaryInk)
            }

            Spacer()

            Text("\(completedCount)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(VimloTheme.completedAccent)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(VimloTheme.completedSurface)
                )
        }
        .textCase(nil)
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

private struct CompletedEmptyStateView: View {
    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "sparkles")
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(VimloTheme.completedAccent)
                .frame(width: 72, height: 72)
                .background(
                    Circle()
                        .fill(VimloTheme.completedSurface)
                )

            VStack(spacing: 8) {
                Text("No completed tasks yet")
                    .font(VimloTheme.heroTitleFont)
                    .foregroundStyle(VimloTheme.ink)

                Text("Once you finish something, it will land here like a little archive of wins.")
                    .font(.subheadline)
                    .foregroundStyle(VimloTheme.secondaryInk)
                    .multilineTextAlignment(.center)
            }
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
