//
//  DataRecorder.swift
//  iPhone Sensors Demo
//
//  Created by Shivansh Gaur on 23/09/2025.
//

import Foundation
import CoreMotion

class DataRecorder: ObservableObject {
    @Published var isRecording = false
    @Published var recordedData: [SensorDataPoint] = []
    
    private var recordingTimer: Timer?
    
    func startRecording() {
        isRecording = true
        recordedData.removeAll()
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            // This will be called from each sensor controller
        }
    }
    
    func stopRecording() {
        isRecording = false
        recordingTimer?.invalidate()
        recordingTimer = nil
    }
    
    func addDataPoint(_ value: Double, timestamp: Date = Date()) {
        let dataPoint = SensorDataPoint(timestamp: timestamp, value: value)
        recordedData.append(dataPoint)
        
        // Keep only last 1000 points to prevent memory issues
        if recordedData.count > 1000 {
            recordedData.removeFirst()
        }
    }
    
    func exportData() -> String {
        var csvString = "Timestamp,Value\n"
        for point in recordedData {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            csvString += "\(formatter.string(from: point.timestamp)),\(point.value)\n"
        }
        return csvString
    }
    
    func clearData() {
        recordedData.removeAll()
    }
}

struct SensorDataPoint: Identifiable {
    let id = UUID()
    let timestamp: Date
    let value: Double
}
