//
//  AccelerometerSwiftUIView.swift
//  iPhone Sensors Demo
//
//  Created by Shivansh Gaur on 22/09/2025.
//

import SwiftUI
import CoreMotion

struct AccelerometerSwiftUIView: View {
    @Binding var acceleration: CMAcceleration
    @ObservedObject var dataRecorder: DataRecorder
    @ObservedObject var errorHandler: ErrorHandler
    @State private var showingExportAlert = false
    @State private var exportText = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Acceleration Vector Visualization
                AccelerometerVectorView(acceleration: acceleration)
                
                // Data Cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    SensorDataView(
                        title: "X-Axis",
                        value: String(format: "%.3f", acceleration.x),
                        unit: "g",
                        color: .red
                    )
                    
                    SensorDataView(
                        title: "Y-Axis",
                        value: String(format: "%.3f", acceleration.y),
                        unit: "g",
                        color: .green
                    )
                    
                    SensorDataView(
                        title: "Z-Axis",
                        value: String(format: "%.3f", acceleration.z),
                        unit: "g",
                        color: .blue
                    )
                    
                    SensorDataView(
                        title: "Magnitude",
                        value: String(format: "%.3f", calculateMagnitude()),
                        unit: "g",
                        color: .purple
                    )
                }
                
                // Recording Controls
                RecordingControlsView(dataRecorder: dataRecorder) {
                    exportText = dataRecorder.exportData()
                    showingExportAlert = true
                }
                
                // Data Chart
                if !dataRecorder.recordedData.isEmpty {
                    SensorDataChart(
                        dataPoints: dataRecorder.recordedData,
                        title: "Acceleration Magnitude Over Time",
                        color: .purple
                    )
                }
                
                // Educational Content
                EducationalCardView(
                    title: "Accelerometer",
                    description: "The accelerometer measures linear acceleration in three dimensions (X, Y, Z). It detects changes in velocity and gravity, measured in g-force units (1g = 9.8 m/s²). When at rest, the Z-axis typically shows ~1g due to gravity, while X and Y show ~0g. This sensor is used for device orientation, motion detection, and fitness tracking.",
                    icon: "move.3d"
                )
                
                // Error Display
                if errorHandler.hasError {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text("Error")
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                        
                        Text(errorHandler.lastError ?? "Unknown error")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Button("Dismiss") {
                            errorHandler.clearError()
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .alert("Export Data", isPresented: $showingExportAlert) {
            Button("Copy to Clipboard") {
                UIPasteboard.general.string = exportText
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Data has been prepared for export. You can copy it to clipboard or share it.")
        }
    }
    
    private func calculateMagnitude() -> Double {
        return sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))
    }
}

// MARK: - Acceleration Vector Visualization
struct AccelerometerVectorView: View {
    let acceleration: CMAcceleration
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Acceleration Vector")
                .font(.headline)
                .foregroundColor(.primary)
            
            // Main vector visualization
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    .frame(width: 200, height: 200)
                
                // Center point
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
                
                // X-axis arrow (red)
                ArrowView(
                    direction: .horizontal,
                    magnitude: acceleration.x,
                    color: .red,
                    label: "X"
                )
                
                // Y-axis arrow (green)
                ArrowView(
                    direction: .vertical,
                    magnitude: acceleration.y,
                    color: .green,
                    label: "Y"
                )
                
                // Z-axis indicator (blue dot - represents depth)
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.6))
                        .frame(width: 12, height: 12)
                        .offset(x: acceleration.z * 20, y: acceleration.z * 20)
                    
                    Text("Z")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .offset(x: acceleration.z * 20 + 15, y: acceleration.z * 20 - 15)
                }
            }
            .frame(height: 220)
            
            // Magnitude indicator
            VStack(spacing: 5) {
                Text("Total Magnitude")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(String(format: "%.2f g", calculateMagnitude()))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private func calculateMagnitude() -> Double {
        return sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))
    }
}

// MARK: - Arrow View Component
struct ArrowView: View {
    enum Direction {
        case horizontal, vertical
    }
    
    let direction: Direction
    let magnitude: Double
    let color: Color
    let label: String
    
    var body: some View {
        let normalizedMagnitude = max(-1, min(1, magnitude)) // Clamp between -1 and 1
        let arrowLength = abs(normalizedMagnitude) * 80 // Max length of 80 points
        let arrowOffset = normalizedMagnitude * 40 // Center offset
        
        ZStack {
            // Arrow line
            Rectangle()
                .fill(color)
                .frame(
                    width: direction == .horizontal ? arrowLength : 3,
                    height: direction == .horizontal ? 3 : arrowLength
                )
                .offset(
                    x: direction == .horizontal ? arrowOffset : 0,
                    y: direction == .vertical ? -arrowOffset : 0
                )
            
            // Arrow head
            if arrowLength > 10 {
                Triangle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                    .offset(
                        x: direction == .horizontal ? arrowOffset + (normalizedMagnitude > 0 ? arrowLength/2 : -arrowLength/2) : 0,
                        y: direction == .vertical ? -arrowOffset + (normalizedMagnitude > 0 ? -arrowLength/2 : arrowLength/2) : 0
                    )
            }
            
            // Label
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)
                .offset(
                    x: direction == .horizontal ? arrowOffset + (normalizedMagnitude > 0 ? arrowLength/2 + 15 : -arrowLength/2 - 15) : 0,
                    y: direction == .vertical ? -arrowOffset + (normalizedMagnitude > 0 ? -arrowLength/2 - 15 : arrowLength/2 + 15) : 0
                )
        }
    }
}

// MARK: - Triangle Shape for Arrow Head
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    AccelerometerSwiftUIView(
        acceleration: .constant(CMAcceleration(x: 0.1, y: 0.2, z: 0.9)),
        dataRecorder: DataRecorder(),
        errorHandler: ErrorHandler()
    )
}
