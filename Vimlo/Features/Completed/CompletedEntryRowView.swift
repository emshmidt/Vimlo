//
//  CompletedEntryRowView.swift
//  Vimlo
//
//  Created by Codex on 27.04.2026.
//

import SwiftUI

struct CompletedEntryRowView: View {
    let completedCount: Int
    var isEmphasized = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.headline)
                .foregroundStyle(VimloTheme.completedAccent)
                .frame(width: 38, height: 38)
                .background(
                    Circle()
                        .fill(VimloTheme.completedSurface)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("Completed")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(VimloTheme.ink)

                Text("A soft archive of what you already finished.")
                    .font(.caption)
                    .foregroundStyle(VimloTheme.secondaryInk)
            }

            Spacer()

            Text("\(completedCount)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(VimloTheme.completedAccent)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(VimloTheme.completedSurface)
                )

            if isEmphasized {
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(VimloTheme.secondaryInk)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, isEmphasized ? 18 : 16)
        .background(
            RoundedRectangle(cornerRadius: isEmphasized ? 28 : 24, style: .continuous)
                .fill(VimloTheme.cardBackground.opacity(isEmphasized ? 0.96 : 0.92))
        )
        .overlay(
            RoundedRectangle(cornerRadius: isEmphasized ? 28 : 24, style: .continuous)
                .stroke(VimloTheme.completedSurface, lineWidth: 1)
        )
        .shadow(color: VimloTheme.shadow, radius: 12, y: 8)
    }
}

#Preview {
    List {
        NavigationLink {
            Text("Completed")
        } label: {
            CompletedEntryRowView(completedCount: 3, isEmphasized: true)
        }
    }
}
