//
//  BarometerViewController.swift
//  iPhone Sensors Demo
//
//  Created by Aitor Zubizarreta on 25/07/2021.
//

import UIKit
import SwiftUI
import CoreMotion

class BarometerViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var relativeAltitudeTitleLabel: UILabel!
    @IBOutlet weak var relativeAltitudeValueLabel: UILabel!
    @IBOutlet weak var pressureTitleLabel: UILabel!
    @IBOutlet weak var pressureValueLabel: UILabel!
    
    // MARK: - Properties
    
    let altimeterManager = CMAltimeter()
    let dataRecorder = DataRecorder()
    let errorHandler = ErrorHandler()
    var relativeAltitude: Float = 0
    var pressure_kPa: Float = 0
    var pressure_atm: Float = 0
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupSwiftUIView()
        self.setupBarometer()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        self.title = "Barometer"
        
        self.relativeAltitudeValueLabel.isHidden = true
        self.pressureValueLabel.isHidden = true
        
        self.pressureValueLabel.isHidden = true
        self.relativeAltitudeTitleLabel.isHidden = true
        
//         Labels.
        self.relativeAltitudeValueLabel.text = "-"
        self.pressureValueLabel.text = " -"
    }
    
    ///
    /// Setup the SwiftUI View.
    ///
    private func setupSwiftUIView() {
        let relativeAltitudeBinding = Binding<Float>(
            get: { self.relativeAltitude },
            set: { self.relativeAltitude = $0 }
        )
        
        let pressure_kPaBinding = Binding<Float>(
            get: { self.pressure_kPa },
            set: { self.pressure_kPa = $0 }
        )
        
        let pressure_atmBinding = Binding<Float>(
            get: { self.pressure_atm },
            set: { self.pressure_atm = $0 }
        )
        
        let swiftUIView = BarometerSwiftUIView(
            relativeAltitude: relativeAltitudeBinding,
            pressure_kPa: pressure_kPaBinding,
            pressure_atm: pressure_atmBinding,
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
    /// Setup the Barometer sensor.
    ///
    private func setupBarometer() {
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            // Start Altimeter sensor data readout.
            self.altimeterManager.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
                self.errorHandler.handleSensorError(error, sensorName: "Barometer")
                
                if let altimeterData = data {
                    self.relativeAltitude = altimeterData.relativeAltitude.floatValue
                    self.pressure_kPa = altimeterData.pressure.floatValue
                    self.pressure_atm = 0.00986923266 * self.pressure_kPa
                    
                    // Update legacy labels
//                    self.relativeAltitudeValueLabel.text = " \(self.relativeAltitude)"
//                    self.pressureValueLabel.text = " \(self.pressure_kPa) kPa \n \(self.pressure_atm) atm"
                    
                    // Record data if recording
                    if self.dataRecorder.isRecording {
                        self.dataRecorder.addDataPoint(Double(self.pressure_kPa))
                    }
                }
            }
        } else {
            self.relativeAltitudeValueLabel.text = " Not Available"
            self.pressureValueLabel.text = " Not Available"
            self.errorHandler.handleError(NSError(domain: "BarometerError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Barometer not available on this device"]), context: "Barometer Setup")
        }
    }
    
    deinit {
        altimeterManager.stopRelativeAltitudeUpdates()
    }
    
}
