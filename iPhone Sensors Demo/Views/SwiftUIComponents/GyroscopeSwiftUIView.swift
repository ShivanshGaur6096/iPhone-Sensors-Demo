//
//  GyroscopeSwiftUIView.swift
//  iPhone Sensors Demo
//
//  Created by Shivansh Gaur on 24/09/2025.
//

import SwiftUI
import CoreMotion

struct GyroscopeSwiftUIView: View {
    @Binding var rotationRate: CMRotationRate
    @ObservedObject var dataRecorder: DataRecorder
    @ObservedObject var errorHandler: ErrorHandler
    @State private var showingExportAlert = false
    @State private var exportText = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 3D Visualization
                Gyroscope3DView(rotationRate: rotationRate)
                
                // Data Cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    SensorDataView(
                        title: "X-Axis",
                        value: String(format: "%.3f", rotationRate.x),
                        unit: "rad/s",
                        color: .red
                    )
                    
                    SensorDataView(
                        title: "Y-Axis",
                        value: String(format: "%.3f", rotationRate.y),
                        unit: "rad/s",
                        color: .green
                    )
                    
                    SensorDataView(
                        title: "Z-Axis",
                        value: String(format: "%.3f", rotationRate.z),
                        unit: "rad/s",
                        color: .blue
                    )
                    
                    SensorDataView(
                        title: "Magnitude",
                        value: String(format: "%.3f", calculateMagnitude()),
                        unit: "rad/s",
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
                        title: "Rotation Magnitude Over Time",
                        color: .purple
                    )
                }
                
                // Educational Content
                EducationalCardView(
                    title: "Gyroscope",
                    description: "The gyroscope measures the device's rotation rate around three axes (X, Y, Z). It detects how fast the device is rotating in 3D space, measured in radians per second. This is useful for detecting device orientation changes and motion gestures.",
                    icon: "gyroscope"
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
        return sqrt(pow(rotationRate.x, 2) + pow(rotationRate.y, 2) + pow(rotationRate.z, 2))
    }
}

#Preview {
    GyroscopeSwiftUIView(
        rotationRate: .constant(CMRotationRate(x: 0.1, y: 0.2, z: 0.3)),
        dataRecorder: DataRecorder(),
        errorHandler: ErrorHandler()
    )
}
