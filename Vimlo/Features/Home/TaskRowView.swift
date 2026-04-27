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
    @Environment(\.calendar) private var calendar

    let task: Task
    var sectionType: TaskType? = nil
    let onDelete: (Task, ModelContext) throws -> Void
    let onComplete: (Task, ModelContext) throws -> Void

    var body: some View {
        NavigationLink {
            TaskEditorView(task: task)
        } label: {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: style.symbol)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(style.accent)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(style.surface)
                    )

                VStack(alignment: .leading, spacing: 8) {
                    Text(task.title)
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(VimloTheme.ink)
                        .multilineTextAlignment(.leading)

                    if let note = task.note, !note.isEmpty {
                        Text(note)
                            .font(.subheadline)
                            .foregroundStyle(VimloTheme.secondaryInk)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }

                    Text(VimloTheme.dueDateLabel(for: task))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(style.accent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(style.surface)
                        )
                }

                Spacer(minLength: 12)

                //Image(systemName: "chevron.right")
                    //.font(.caption.weight(.bold))
                   // .foregroundStyle(VimloTheme.secondaryInk.opacity(0.8))
                    //.padding(.top, 4)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(VimloTheme.cardBackground.opacity(0.96))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(style.surface.opacity(0.95), lineWidth: 1)
            )
            .shadow(color: VimloTheme.shadow, radius: 12, y: 8)
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                perform(.default, action: onDelete)
            } label: {
                Image(systemName: "trash")
            }
            .tint(VimloTheme.roseAccent)
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
            .tint(task.isCompleted ? VimloTheme.mistAccent : VimloTheme.completedAccent)
        }
    }

    private var style: TaskRowStyle {
        if task.isCompleted {
            return TaskRowStyle(
                surface: VimloTheme.completedSurface,
                accent: VimloTheme.completedAccent,
                symbol: VimloTheme.completedSymbol
            )
        }

        let type = sectionType ?? inferredSectionType

        return TaskRowStyle(
            surface: VimloTheme.surface(for: type),
            accent: VimloTheme.accent(for: type),
            symbol: VimloTheme.symbol(for: type)
        )
    }

    private var inferredSectionType: TaskType {
        guard let dueDate = task.dueDate else {
            return .noDate
        }

        let today = calendar.startOfDay(for: .now)
        let normalizedDueDate = calendar.startOfDay(for: dueDate)

        if normalizedDueDate == today {
            return .today
        }

        if normalizedDueDate > today {
            return .upcoming
        }

        return .overdue
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

private struct TaskRowStyle {
    let surface: Color
    let accent: Color
    let symbol: String
}
