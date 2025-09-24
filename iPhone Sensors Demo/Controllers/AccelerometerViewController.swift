//
//  AccelerometerViewController.swift
//  iPhone Sensors Demo
//
//  Created by Shivansh Gaur on 22/09/2025.
//

import UIKit
import SwiftUI
import CoreMotion

class AccelerometerViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Properties
    
    let accelerometerManager = CMMotionManager()
    let dataRecorder = DataRecorder()
    let errorHandler = ErrorHandler()
    var acceleration = CMAcceleration(x: 0, y: 0, z: 0)
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupSwiftUIView()
        self.setupAccelerometer()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        self.title = "Accelerometer"
    }
    
    ///
    /// Setup the SwiftUI View.
    ///
    private func setupSwiftUIView() {
        let accelerationBinding = Binding<CMAcceleration>(
            get: { self.acceleration },
            set: { self.acceleration = $0 }
        )
        
        let swiftUIView = AccelerometerSwiftUIView(
            acceleration: accelerationBinding,
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
    /// Setup the Accelerometer sensor.
    ///
    private func setupAccelerometer() {
        if self.accelerometerManager.isAccelerometerAvailable {
            // Set the data update interval.
            self.accelerometerManager.accelerometerUpdateInterval = 0.1 // Seconds
            
            // Start Accelerometer sensor data readout.
            self.accelerometerManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                self.errorHandler.handleSensorError(error, sensorName: "Accelerometer")
                
                if let accelerometerData = data {
                    self.acceleration = accelerometerData.acceleration
                    
                    // Record data if recording
                    if self.dataRecorder.isRecording {
                        let magnitude = sqrt(pow(accelerometerData.acceleration.x, 2) + pow(accelerometerData.acceleration.y, 2) + pow(accelerometerData.acceleration.z, 2))
                        self.dataRecorder.addDataPoint(magnitude)
                    }
                }
            }
        } else {
            self.errorHandler.handleError(NSError(domain: "AccelerometerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Accelerometer not available on this device"]), context: "Accelerometer Setup")
        }
    }
    
    deinit {
        accelerometerManager.stopAccelerometerUpdates()
    }
}
