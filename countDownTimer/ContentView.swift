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
    var sec: Int = 0
    var min: Int = 0
    var isRunning: Bool = false
    var timer: Timer?
    
    var displayTime: String {
        return String(format: "%02d:%02d", min, sec)
    }
    
    
    func startTimer() {
        if isRunning {
            timer = Timer
                .scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
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
        TabView {
            Tab.init("Clock", systemImage: "clock.fill") {
                
            }
            
            Tab.init("Alarm", systemImage: "alarm.waves.left.and.right.fill") {
                
            }
            
            Tab.init("StopWatch", systemImage: "stopwatch.fill") {
                CountDownView(selection: timer.sec) {
                    ForEach (0...59,id: \.self) { value in
                        
                        Text(timer.displayTime)
                    }
                }
            }
        }
    }
}

struct CountDownView<Content: View, Selection: Hashable>: View {
    @Environment(CountDownLogic.self) private var timer
    @State var selection: Selection
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack {
            Picker("", selection: $selection) {
                content
               // timer.sec = Int(selection)
                
            }
            .pickerStyle(.wheel)
            
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
        .navigationTitle("StopWatch")
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
    .environment(CountDownLogic())
}
