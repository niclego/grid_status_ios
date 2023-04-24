//
//  GridStatusApp.swift
//  GridStatus
//
//  Created by Nicolas Le Gorrec on 4/23/23.
//

import SwiftUI

@main
struct GridStatusApp: App {

    var body: some Scene {
        WindowGroup {
            Dashboard(vm: ViewModel(
                networkManager: NetworkManagerMock(),
                sleeper: Sleeper(durationInSeconds: 5)
            ))
        }
    }
}
