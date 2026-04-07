//
//  VimloApp.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 06.04.2026.
//

import SwiftData
import SwiftUI

@main
struct VimloApp: App {
    var body: some Scene {
        WindowGroup {
            TaskHomeView()
        }
        .modelContainer(for: Task.self)
    }
}
