//
//  VisualComponents.swift
//  iPhone Sensors Demo
//
//  Created by Shivansh Gaur on 23/09/2025.
//

import SwiftUI
import Charts
import CoreMotion

// MARK: - Pressure Gauge
struct PressureGaugeView: View {
    let pressure: Float
    let minPressure: Float = 95.0
    let maxPressure: Float = 105.0
    
    var body: some View {
        VStack {
            Text("Pressure Gauge")
                .font(.headline)
                .padding(.bottom, 10)
            
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                    .frame(width: 200, height: 200)
                
                // Pressure arc
                Circle()
                    .trim(from: 0, to: pressureProgress)
                    .stroke(
                        LinearGradient(
                            colors: [.green, .yellow, .red],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                
                // Center value
                VStack {
                    Text(String(format: "%.2f", pressure))
                        .font(.title)
                        .fontWeight(.bold)
                    Text("kPa")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private var pressureProgress: Double {
        let normalized = (pressure - minPressure) / (maxPressure - minPressure)
        return max(0, min(1, Double(normalized)))
    }
}

// MARK: - Compass View for Magnetometer
struct CompassView: View {
    let magneticField: CMMagneticField
    
    var body: some View {
        VStack {
            Text("Magnetic Field Compass")
                .font(.headline)
                .padding(.bottom, 10)
            
            ZStack {
                // Outer circle
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 200, height: 200)
                
                // North indicator
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 4, height: 100)
                    .offset(y: -50)
                
                // Magnetic field indicator
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 2, height: 80)
                    .offset(y: -40)
                    .rotationEffect(.degrees(calculateHeading()))
                
                // Center dot
                Circle()
                    .fill(Color.black)
                    .frame(width: 8, height: 8)
            }
            
            Text("Heading: \(String(format: "%.1f", calculateHeading()))°")
                .font(.caption)
                .padding(.top, 10)
        }
    }
    
    private func calculateHeading() -> Double {
        let heading = atan2(magneticField.y, magneticField.x) * 180 / .pi
        return heading
    }
}

// MARK: - Gyroscope 3D Visualization
struct Gyroscope3DView: View {
    let rotationRate: CMRotationRate
    
    var body: some View {
        VStack {
            Text("3D Rotation Visualization")
                .font(.headline)
                .padding(.bottom, 10)
            
            ZStack {
                // 3D cube representation
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .rotation3DEffect(
                        .degrees(rotationRate.x * 10),
                        axis: (x: 1, y: 0, z: 0)
                    )
                    .rotation3DEffect(
                        .degrees(rotationRate.y * 10),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .rotation3DEffect(
                        .degrees(rotationRate.z * 10),
                        axis: (x: 0, y: 0, z: 1)
                    )
            }
            .frame(height: 150)
        }
    }
}

// MARK: - Sensor Data Chart
struct SensorDataChart: View {
    let dataPoints: [SensorDataPoint]
    let title: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            
            if dataPoints.isEmpty {
                Text("No data recorded yet")
                    .foregroundColor(.secondary)
                    .frame(height: 200)
            } else {
                Chart(dataPoints) { point in
                    LineMark(
                        x: .value("Time", point.timestamp),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(color)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
                .frame(height: 200)
            }
        }
        .padding()
    }
}

// MARK: - Recording Controls
struct RecordingControlsView: View {
    @ObservedObject var dataRecorder: DataRecorder
    let onExport: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                if dataRecorder.isRecording {
                    dataRecorder.stopRecording()
                } else {
                    dataRecorder.startRecording()
                }
            }) {
                HStack {
                    Image(systemName: dataRecorder.isRecording ? "stop.circle.fill" : "record.circle")
                    Text(dataRecorder.isRecording ? "Stop" : "Record")
                }
                .foregroundColor(dataRecorder.isRecording ? .red : .green)
            }
            
            Button("Export") {
                onExport()
            }
            .disabled(dataRecorder.recordedData.isEmpty)
            
            Button("Clear") {
                dataRecorder.clearData()
            }
            .disabled(dataRecorder.recordedData.isEmpty)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    VStack(spacing: 20) {
        PressureGaugeView(pressure: 101.325)
        CompassView(magneticField: CMMagneticField(x: 0.1, y: 0.2, z: 0.3))
        Gyroscope3DView(rotationRate: CMRotationRate(x: 0.1, y: 0.2, z: 0.3))
    }
    .padding()
}
