//
//  ContentView.swift
//  countDownTimer
//
//  Created by Aryan Verma on 21/03/26.
//

import SwiftUI
import Observation

@Observable
class CountDownLogic {
    var sec: Int = 59
    var min: Int = 1
    var isRunning: Bool = false
    var timer: Timer?
    
    var displayTime: String {
        return String(format: "%02d:%02d", min, sec)
    }
    
    
    func startTimer() {
        if isRunning {
           timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
               if self.sec > 0 {
                   self.sec -= 1
               } else if self.min > 0 {
                    self.sec = 59
                   self.min -= 1
                } else {
                    self.pauseTimer()
                    self.isRunning.toggle()
                }
            }
        }
    }
    func pauseTimer() {
        isRunning.toggle()
        timer?.invalidate()
    }
    
    func resetTimer() {
        min = 1
        sec = 59
        pauseTimer()
    }
}

struct ContentView: View {
    @Environment(CountDownLogic.self) private var timer
    var body: some View {
        VStack {
            Text(timer.displayTime)
            
            Button("Start") {
                if !timer.isRunning {
                    timer.isRunning.toggle()
                    timer.startTimer()
                }
            }
            .padding()
            
            Button("Pause") {
                timer.pauseTimer()
            }
            .padding()
            
            Button("Reset") {
                timer.resetTimer()
            }
            .padding()
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environment(CountDownLogic())
}
