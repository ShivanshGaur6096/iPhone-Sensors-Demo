//
//  MagnetometerSwiftUIView.swift
//  iPhone Sensors Demo
//
//  Created by Shivansh Gaur on 24/09/2025.
//

import SwiftUI
import CoreMotion

struct MagnetometerSwiftUIView: View {
    @Binding var magneticField: CMMagneticField
    @ObservedObject var dataRecorder: DataRecorder
    @ObservedObject var errorHandler: ErrorHandler
    @State private var showingExportAlert = false
    @State private var exportText = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Compass Visualization
                CompassView(magneticField: magneticField)
                
                // Data Cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    SensorDataView(
                        title: "X-Axis",
                        value: String(format: "%.2f", magneticField.x),
                        unit: "µT",
                        color: .red
                    )
                    
                    SensorDataView(
                        title: "Y-Axis",
                        value: String(format: "%.2f", magneticField.y),
                        unit: "µT",
                        color: .green
                    )
                    
                    SensorDataView(
                        title: "Z-Axis",
                        value: String(format: "%.2f", magneticField.z),
                        unit: "µT",
                        color: .blue
                    )
                    
                    SensorDataView(
                        title: "Magnitude",
                        value: String(format: "%.2f", calculateMagnitude()),
                        unit: "µT",
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
                        title: "Magnetic Field Magnitude Over Time",
                        color: .purple
                    )
                }
                
                // Educational Content
                EducationalCardView(
                    title: "Magnetometer",
                    description: "The magnetometer measures the Earth's magnetic field in three dimensions (X, Y, Z). It detects magnetic fields in microteslas (µT) and is used for compass functionality, detecting metal objects, and measuring magnetic interference. The Earth's magnetic field typically ranges from 25-65 µT.",
                    icon: "location.north"
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
        return sqrt(pow(magneticField.x, 2) + pow(magneticField.y, 2) + pow(magneticField.z, 2))
    }
}

#Preview {
    MagnetometerSwiftUIView(
        magneticField: .constant(CMMagneticField(x: 25.0, y: 30.0, z: 40.0)),
        dataRecorder: DataRecorder(),
        errorHandler: ErrorHandler()
    )
}
