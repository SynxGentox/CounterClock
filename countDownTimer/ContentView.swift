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
    var totalSec: Int = 0
    var remaining: Int = 0
    
    func startTimer() {
        if minors == 0 && sec == 0 {
            minors = 1
            sec = 59
        }
        totalSec = (60 * minors) + sec
        remaining = totalSec
        
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
                    }
                    self.remaining = (60 * self.minors) + self.sec
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
    
    var progress: Double {
        guard totalSec > 0 else {return 1.0}
        return Double(remaining) / Double(totalSec)
    }
}

struct ContentView: View {
    @Environment(CountDownLogic.self) private var timer
    var body: some View {
        @Bindable var timeCook = timer
        ZStack {
            
            TabView {
                Tab.init("Clock", systemImage: "clock.fill") {
                    
                }
                
                Tab.init(
                    "Alarm",
                    systemImage: "alarm.waves.left.and.right.fill"
                ) {
                    
                }
                
                Tab.init("FastTrack", systemImage: "hare.fill") {
                    NavigationStack {
                        ZStack {
                            SineWave(prog: timer.progress)
                                .animation(.linear(duration: 1.0), value: timer.progress)
                                .frame(
                                    maxWidth: .infinity,
                                    maxHeight: .infinity,
                                    alignment: .bottom
                                )
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
                            .padding(.bottom, 30)
                            .padding(.horizontal, 15)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .center
                            )
                            
                            TimeController()
                                .frame(
                                    maxWidth: .infinity,
                                    maxHeight: .infinity,
                                    alignment: .bottom
                                )
                                .offset(x: 0, y: -96)
                        }
                        .ignoresSafeArea()
                        .navigationTitle("CountDown")
                    }
                }
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
                .pickerStyle(.wheel)
                .padding()
                .frame(maxWidth: 120)
                .disabled(timer.isRunning)
                Text(title)
                    .font(.title3.weight(.medium))
                    .fontDesign(.monospaced)
                    .background(.clear)
            }
        }
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
                    systemName: "arrow.trianglehead.2.clockwise.rotate.90"
                )
                .resizable()
                .scaledToFit()
                .fontWeight(.heavy)
                .foregroundStyle(
                    !timer.isRunning ? Color(UIColor.label) : Color(
                        UIColor.secondaryLabel
                    )
                )
                .frame(maxWidth: 35, maxHeight: 35)
            }
            .frame(maxWidth: 60, maxHeight: 60)
            .glassEffect(.clear.interactive(), in: .circle)
            .padding(20)
            .disabled(timer.isRunning)
            
            
            if timer.isRunning{
                Button {
                    withAnimation(.bouncy) {
                        timer.pauseTimer()
                    }
                } label: {
                    Image(
                        systemName: "pause.fill"
                    )
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color(UIColor.label))
                    .frame(maxWidth: 30, maxHeight: 30)
                }
                .frame(maxWidth: 60, maxHeight: 60)
                .glassEffect(.clear.interactive(), in: .circle)
                .padding(20)
                .clipShape(.circle)
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
                    Image(
                        systemName: "play.fill"
                    )
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color(UIColor.label))
                    .frame(maxWidth: 30, maxHeight: 30)
                    .padding(.leading, 5)
                }
                .frame(maxWidth: 60, maxHeight: 60)
                .glassEffect(.clear.interactive(), in: .circle)
                .padding(20)
            }
        }
        .shadow(color: .black.opacity(0.08), radius: 10)
        .frame(maxWidth: 200, maxHeight: 100, alignment: .bottom)
    }
}

#Preview {
    ContentView()
        .environment(CountDownLogic())
}
