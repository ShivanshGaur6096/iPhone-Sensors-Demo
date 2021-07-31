//
//  MagnetometerViewController.swift
//  iPhone Sensors Demo
//
//  Created by Aitor Zubizarreta Perez on 27/07/2021.
//

import UIKit
import CoreMotion

class MagnetometerViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var xAxisValueLabel: UILabel!
    @IBOutlet weak var yAxisValueLabel: UILabel!
    @IBOutlet weak var zAxisValueLabel: UILabel!
    
    // MARK: - Properties
    
    let magnetometerManager = CMMotionManager()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        
        self.setupMagnetometer()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        self.title = "Magnetometer"
        
        // Labels.
        self.xAxisValueLabel.text = " -"
        self.yAxisValueLabel.text = " -"
        self.zAxisValueLabel.text = " -"
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
                if let magnetometerData = data {
                    self.xAxisValueLabel.text = " \(magnetometerData.magneticField.x) µT" // Microtesla
                    self.yAxisValueLabel.text = " \(magnetometerData.magneticField.y) µT" // Microtesla
                    self.zAxisValueLabel.text = " \(magnetometerData.magneticField.z) µT" // Microtesla
                }
            }
        } else {
            self.xAxisValueLabel.text = " Not Available"
            self.yAxisValueLabel.text = " Not Available"
            self.zAxisValueLabel.text = " Not Available"
        }
    }
    
}
