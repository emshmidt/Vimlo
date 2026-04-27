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
                .foregroundStyle(.green)

            Text("Completed")
                .foregroundStyle(.primary)

            Spacer()

            Text("\(completedCount)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(Color(.tertiarySystemFill))
                )
            
        if isEmphasized {
            Image(systemName: "chevron.right")
                           .font(.footnote.weight(.semibold))
                           .foregroundStyle(.tertiary)
            }
            
        }
        .padding(.horizontal, isEmphasized ? 14 : 0)
        .padding(.vertical, isEmphasized ? 12 : 0)
        .background {
            if isEmphasized {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            }
        }
        .overlay {
            if isEmphasized {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color(.separator), lineWidth: 1)
            }
        }
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
