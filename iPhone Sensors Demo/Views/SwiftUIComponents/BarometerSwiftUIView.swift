//
//  BarometerSwiftUIView.swift
//  iPhone Sensors Demo
//
//  Created by Shivansh Gaur on 23/09/2025.
//

import SwiftUI

struct BarometerSwiftUIView: View {
    @Binding var relativeAltitude: Float
    @Binding var pressure_kPa: Float
    @Binding var pressure_atm: Float
    @ObservedObject var dataRecorder: DataRecorder
    @ObservedObject var errorHandler: ErrorHandler
    @State private var showingExportAlert = false
    @State private var exportText = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Pressure Gauge
                PressureGaugeView(pressure: pressure_kPa)
                
                // Data Cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    SensorDataView(
                        title: "Relative Altitude",
                        value: String(format: "%.2f", relativeAltitude),
                        unit: "m",
                        color: .blue
                    )
                    
                    SensorDataView(
                        title: "Pressure",
                        value: String(format: "%.2f", pressure_kPa),
                        unit: "kPa",
                        color: .green
                    )
                    
                    SensorDataView(
                        title: "Atmosphere",
                        value: String(format: "%.4f", pressure_atm),
                        unit: "atm",
                        color: .orange
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
                        title: "Pressure Over Time",
                        color: .green
                    )
                }
                
                // Educational Content
                EducationalCardView(
                    title: "Barometer",
                    description: "The barometer measures atmospheric pressure and relative altitude changes. It uses the device's barometric pressure sensor to detect changes in air pressure, which can indicate weather changes or altitude variations.",
                    icon: "barometer"
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
}

#Preview {
    BarometerSwiftUIView(
        relativeAltitude: .constant(10.5),
        pressure_kPa: .constant(101.325),
        pressure_atm: .constant(1.0),
        dataRecorder: DataRecorder(),
        errorHandler: ErrorHandler()
    )
}
