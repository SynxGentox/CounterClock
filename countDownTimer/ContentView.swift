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
    var minors: Int = 0
    var sec: Int = 0
    var isRunning: Bool = false
    var timer: Timer?
    
    var displayTime: String {
        return String(format: "%02d:%02d", minors, sec)
    }
    
    
    func startTimer() {
        if minors == 0 && sec == 0 {
            minors = 1
            sec = 59
        }
        if isRunning {
            timer = Timer
                .scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if self.sec > 0 {
                        self.sec -= 1
                    } else if self.minors > 0 {
                        self.sec = 59
                        self.minors -= 1
                    } else {
                        self.pauseTimer()
                        self.isRunning.toggle()
                    }
                }
        }
    }
    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
    }
    
    func resetTimer() {
        minors = 0
        sec = 0
        pauseTimer()
    }
}

struct ContentView: View {
    @Environment(CountDownLogic.self) private var timer
    var body: some View {
        @Bindable var timeCook = timer

        TabView {
            Tab.init("Clock", systemImage: "clock.fill") {
                
            }
            
            Tab.init("Alarm", systemImage: "alarm.waves.left.and.right.fill") {
                
            }
            
            Tab.init("FastTrack", systemImage: "hare.fill") {
                ZStack{
                    HStack{
                        CountDownView(
                            value: $timeCook.minors,
                            range: 0..<60,
                            title: "Minutes"
                        )
                    
                        CountDownView(
                            value: $timeCook.sec,
                            range: 0..<60,
                            title: "Seconds"
                        )
                    }
                    TimeController()
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .bottom
                        )
                }
                .navigationTitle("CountDown")
            }
        }
    }
}

struct CountDownView: View {
    @Environment(CountDownLogic.self) private var timer
    @Binding var value: Int
    let range: Range<Int>
    let title: String
    
    var body: some View {
        ZStack {
            VStack {
                Picker("", selection: $value) {
                    ForEach(range, id: \.self) { value in
                        Text(String(format: "%02d", value))
                            .font(.title2.weight(.medium))
                            .fontDesign(.monospaced)
                            .tag(value)
                    }
                }
                .frame(width: 120)
                .pickerStyle(.wheel)
                .disabled(timer.isRunning)
                Text(title)
                    .font(.title3.weight(.medium))
                    .fontDesign(.monospaced)
                    .background(.clear)
            }
        }
        .navigationTitle("CountDown")
    }
}

struct TimeController: View {
    @Environment(CountDownLogic.self) private var timer
    var body: some View {
        HStack {
            Button {
                withAnimation(.bouncy) {
                    timer.resetTimer()
                }
            } label: {
                Image(
                    systemName: "arrow.trianglehead.2.clockwise.rotate.90.circle.fill"
                )
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color(UIColor.systemBackground))
                .background(
                    Circle()
                        .fill(Color(UIColor.systemRed))
                        .shadow(color: .black.opacity(0.25), radius: 10)
                        .padding(1)
                )
            }
            .frame(maxWidth: 55, maxHeight: 55)
            .buttonStyle(.borderless)
            .padding(12)
            
            if timer.isRunning{
                Button {
                    withAnimation(.bouncy) {
                        timer.pauseTimer()
                    }
                } label: {
                    Image(systemName: "pause.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color(UIColor.systemBackground))
                        .background(
                            Circle()
                                .fill(Color(UIColor.secondaryLabel))
                                .shadow(color: .black.opacity(0.25), radius: 10)
                                .padding(1)
                        )
                }
                .frame(maxWidth: 55, maxHeight: 55)
                .buttonStyle(.borderless)
                .padding(12)
            }
            else {
                Button {
                    withAnimation(.bouncy) {
                        if !timer.isRunning {
                            timer.isRunning = true
                            timer.startTimer()
                        }
                    }
                } label: {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color(UIColor.systemBackground))
                        .background(
                            Circle()
                                .fill(Color(UIColor.systemBlue))
                                .shadow(color: .black.opacity(0.25), radius: 10)
                                .padding(1)
                        )
                }
                .frame(maxWidth: 55, maxHeight: 55)
                .buttonStyle(.borderless)
                .padding(12)
            }
        }
        .frame(maxWidth: 200, maxHeight: 100)
        
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
    .environment(CountDownLogic())
}
