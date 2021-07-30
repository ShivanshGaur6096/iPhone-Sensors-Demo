//
//  GyroscopeViewController.swift
//  iPhone Sensors Demo
//
//  Created by Aitor Zubizarreta Perez on 28/07/2021.
//

import UIKit
import CoreMotion

class GyroscopeViewController: UIViewController {
    
    // MARK: - UI Elements
    
    // MARK: - Properties
    
    let gyroscopeManager = CMMotionManager()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        self.setupGyroscope()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        self.title = "Gyroscope"
    }
    
    ///
    /// Setup the Gyroscope sensor.
    ///
    private func setupGyroscope() {
        if self.gyroscopeManager.isGyroAvailable {
            // Set the data update interval.
            self.gyroscopeManager.gyroUpdateInterval = 1
            
            // Start Gyroscope sensor data readout.
            self.gyroscopeManager.startGyroUpdates(to: OperationQueue.main) { (data, error) in
                if let data = data {
                    print("Gyro x : \(data.rotationRate.x)")
                    print("Gyro y : \(data.rotationRate.y)")
                    print("Gyro z : \(data.rotationRate.z)")
                }
            }
        }
    }
    
}
