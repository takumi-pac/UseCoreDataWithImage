//
//  UseCoreDataWithImageApp.swift
//  UseCoreDataWithImage
//
//  Created by 松田拓海 on 2022/11/01.
//

import SwiftUI

@main
struct UseCoreDataWithImageApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
