//
//  countDownTimerApp.swift
//  countDownTimer
//
//  Created by Aryan Verma on 21/03/26.
//

import SwiftUI

@main
struct countDownTimerApp: App {
    let timer = CountDownLogic()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(timer)
        }
    }
}
