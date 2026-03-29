//
//  SineWave.swift
//  countDownTimer
//
//  Created by Aryan Verma on 29/03/26.
//

import SwiftUI

struct SineWave: View {
    var prog: Double
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            
            WaveShape(progress: prog, phase: time * 7, amplitude: 12, frequency: 1)
                .fill(.blue.opacity(0.7))
        }
        .ignoresSafeArea()
    }
}

struct WaveShape: Shape {
    var progress: Double
    var phase: Double
    var amplitude: Double
    var frequency: Double
    var animatableData: AnimatablePair<Double, Double>  {
        get { AnimatablePair(phase, progress) }
        set {
            phase = newValue.first
            progress = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let midHeight = rect.height * (1 - progress)
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: rect.width, by: 1) {
            let normalizedX = Double(x) / rect.width
            let y = amplitude * sin(
                normalizedX * 2 * .pi * frequency + phase
            ) + midHeight
            
            path.addLine(to: CGPoint(x: Double(x), y: y))
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

