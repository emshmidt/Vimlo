//
//  TaskRowView.swift
//  Vimlo
//
//  Created by Codex on 27.04.2026.
//

import SwiftData
import SwiftUI

struct TaskRowView: View {
    @Environment(\.modelContext) private var modelContext

    let task: Task
    let onDelete: (Task, ModelContext) throws -> Void
    let onComplete: (Task, ModelContext) throws -> Void

    var body: some View {
        NavigationLink {
            TaskEditorView(task: task)
        }label: {
            Text(task.title)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                perform(.default, action: onDelete)
            } label: {
                Image(systemName: "trash")
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                perform(.spring(), action: onComplete)
            } label: {
                if task.isCompleted {
                    Image(systemName: "arrow.uturn.backward")
                } else {
                    
                    Image(systemName: "checkmark.seal")
                }
            }
            .tint(task.isCompleted ? .blue : .green)
        }
    }

    private func perform(
        _ animation: Animation?,
        action: (Task, ModelContext) throws -> Void
    ) {
        do {
            try withAnimation(animation) {
                try action(task, modelContext)
            }
        } catch {
            assertionFailure("Task row action failed: \(error.localizedDescription)")
        }
    }
}
