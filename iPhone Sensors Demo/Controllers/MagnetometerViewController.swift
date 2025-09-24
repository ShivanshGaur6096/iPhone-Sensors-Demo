//
//  MagnetometerViewController.swift
//  iPhone Sensors Demo
//
//  Created by Aitor Zubizarreta Perez on 27/07/2021.
//

import UIKit
import SwiftUI
import CoreMotion

class MagnetometerViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Properties
    
    let magnetometerManager = CMMotionManager()
    let dataRecorder = DataRecorder()
    let errorHandler = ErrorHandler()
    var magneticField = CMMagneticField(x: 0, y: 0, z: 0)
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.setupSwiftUIView()
        self.setupMagnetometer()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        self.title = "Magnetometer"
    }
    
    ///
    /// Setup the SwiftUI View.
    ///
    private func setupSwiftUIView() {
        
        let magneticFieldBinding = Binding<CMMagneticField>(
            get: { self.magneticField },
            set: { self.magneticField = $0 }
        )
        
        let swiftUIView = MagnetometerSwiftUIView(
            magneticField: magneticFieldBinding,
            dataRecorder: dataRecorder,
            errorHandler: errorHandler
        )
        
        let hostingController = UIHostingController(rootView: swiftUIView)
        addChild(hostingController)
        containerView.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }
    
    ///
    /// Setup the Magnetometer sensor.
    ///
    private func setupMagnetometer() {
        if self.magnetometerManager.isMagnetometerAvailable {
            // Set the data update internal.
            self.magnetometerManager.magnetometerUpdateInterval = 0.2 // Seconds
            
            // Start Magnetometer sensor data readout.
            self.magnetometerManager.startMagnetometerUpdates(to: OperationQueue.main) { (data, error) in
                self.errorHandler.handleSensorError(error, sensorName: "Magnetometer")
                
                if let magnetometerData = data {
                    self.magneticField = magnetometerData.magneticField
                    
                    // Record data if recording
                    if self.dataRecorder.isRecording {
                        let magnitude = sqrt(pow(magnetometerData.magneticField.x, 2) + pow(magnetometerData.magneticField.y, 2) + pow(magnetometerData.magneticField.z, 2))
                        self.dataRecorder.addDataPoint(magnitude)
                    }
                }
            }
        } else {
            self.errorHandler.handleError(NSError(domain: "MagnetometerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Magnetometer not available on this device"]), context: "Magnetometer Setup")
        }
    }
    
    deinit {
        magnetometerManager.stopMagnetometerUpdates()
    }
    
}
