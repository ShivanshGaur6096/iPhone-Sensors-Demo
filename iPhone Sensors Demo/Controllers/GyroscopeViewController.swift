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
    
    @IBOutlet weak var xAxisValueLabel: UILabel!
    @IBOutlet weak var yAxisValueLabel: UILabel!
    @IBOutlet weak var zAxisValueLabel: UILabel!
    
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
        
        // Labels.
        self.xAxisValueLabel.text = " -"
        self.yAxisValueLabel.text = " -"
        self.zAxisValueLabel.text = " -"
    }
    
    ///
    /// Setup the Gyroscope sensor.
    ///
    private func setupGyroscope() {
        if self.gyroscopeManager.isGyroAvailable {
            // Set the data update interval.
            self.gyroscopeManager.gyroUpdateInterval = 0.2 // Seconds
            
            // Start Gyroscope sensor data readout.
            self.gyroscopeManager.startGyroUpdates(to: OperationQueue.main) { (data, error) in
                if let data = data {
                    self.xAxisValueLabel.text = String(" \(data.rotationRate.x)".prefix(8)) + " rads/s" // Radians per second
                    self.yAxisValueLabel.text = String(" \(data.rotationRate.y)".prefix(8)) + " rads/s" // Radians per second
                    self.zAxisValueLabel.text = String(" \(data.rotationRate.z)".prefix(8)) + " rads/s" // Radians per second
                    
                }
            }
        } else {
            self.xAxisValueLabel.text = " Not Available"
            self.yAxisValueLabel.text = " Not Available"
            self.zAxisValueLabel.text = " Not Available"
        }
    }
    
}
