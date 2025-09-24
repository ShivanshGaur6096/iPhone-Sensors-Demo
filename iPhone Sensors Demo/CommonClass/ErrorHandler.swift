//
//  ErrorHandler.swift
//  iPhone Sensors Demo
//
//  Created by Shivansh Gaur on 24/09/2025.
//

import Foundation
import CoreMotion

class ErrorHandler: ObservableObject {
    @Published var lastError: String?
    @Published var hasError: Bool = false
    
    func handleError(_ error: Error?, context: String) {
        DispatchQueue.main.async {
            if let error = error {
                self.lastError = "\(context): \(error.localizedDescription)"
                self.hasError = true
                print("❌ \(context): \(error.localizedDescription)")
            } else {
                self.hasError = false
                self.lastError = nil
            }
        }
    }
    
    func handleSensorError(_ error: Error?, sensorName: String) {
        handleError(error, context: "\(sensorName) Sensor Error")
    }
    
    func clearError() {
        hasError = false
        lastError = nil
    }
}
