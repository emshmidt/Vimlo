//
//  VimloTheme.swift
//  Vimlo
//
//  Created by Codex on 27.04.2026.
//

import SwiftUI

enum VimloTheme {
    static let background = Color(hex: "FFF9F6")
    static let cardBackground = Color(hex: "FFFFFF")
    static let brandPink = Color(hex: "F7C9D7")
    static let butter = Color(hex: "FFE3A8")
    static let mist = Color(hex: "CFE7FF")
    static let sage = Color(hex: "CFE9CF")
    static let oat = Color(hex: "F4DDC8")
    static let rose = Color(hex: "F3C1CB")
    static let ink = Color(hex: "6D5762")
    static let secondaryInk = Color(hex: "927A85")
    static let line = Color(hex: "EDD7DB")
    static let shadow = Color(hex: "CFAFBB").opacity(0.14)

    static let pinkAccent = Color(hex: "D77E9C")
    static let butterAccent = Color(hex: "C69234")
    static let mistAccent = Color(hex: "6E9DCC")
    static let sageAccent = Color(hex: "6E9A76")
    static let oatAccent = Color(hex: "A77E67")
    static let roseAccent = Color(hex: "CA6E86")

    static let backgroundGradient = LinearGradient(
        colors: [
            brandPink.opacity(0.42),
            background,
            mist.opacity(0.20),
            butter.opacity(0.28)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func surface(for type: TaskType) -> Color {
        switch type {
        case .overdue:
            return rose.opacity(0.92)
        case .today:
            return butter.opacity(0.9)
        case .upcoming:
            return mist.opacity(0.9)
        case .noDate:
            return oat.opacity(0.88)
        }
    }

    static func accent(for type: TaskType) -> Color {
        switch type {
        case .overdue:
            return roseAccent
        case .today:
            return butterAccent
        case .upcoming:
            return mistAccent
        case .noDate:
            return oatAccent
        }
    }

    static func symbol(for type: TaskType) -> String {
        switch type {
        case .overdue:
            return "exclamationmark.circle.fill"
        case .today:
            return "sun.max.fill"
        case .upcoming:
            return "cloud.fill"
        case .noDate:
            return "moon.stars.fill"
        }
    }

    static let completedSurface = sage.opacity(0.9)
    static let completedAccent = sageAccent
    static let completedSymbol = "checkmark.circle.fill"

    static let heroTitleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let cardTitleFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let buttonFont = Font.system(.headline, design: .rounded).weight(.semibold)

    static func dueDateLabel(for task: Task) -> String {
        if task.isCompleted, let completedAt = task.completedAt {
            return "Done \(completedAt.formatted(.dateTime.month(.abbreviated).day()))"
        }

        guard let dueDate = task.dueDate else {
            return "Anytime"
        }

        let today = Calendar.current.startOfDay(for: .now)
        let normalized = Calendar.current.startOfDay(for: dueDate)

        if normalized == today {
            return "Today"
        }

        if normalized < today {
            return "Due \(dueDate.formatted(.dateTime.month(.abbreviated).day()))"
        }

        return dueDate.formatted(.dateTime.month(.abbreviated).day())
    }
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)

        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255

        self.init(red: red, green: green, blue: blue)
    }
}
