//
//  BarometerViewController.swift
//  iPhone Sensors Demo
//
//  Created by Aitor Zubizarreta on 25/07/2021.
//

import UIKit
import CoreMotion

class BarometerViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var relativeAltitudeValueLabel: UILabel!
    @IBOutlet weak var pressureValueLabel: UILabel!
    
    // MARK: - Properties
    
    let altimeterManager = CMAltimeter()
    var relativeAltitude: Float = 0
    var pressure_kPa: Float = 0
    var pressure_atm: Float = 0
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        self.setupBarometer()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        self.title = "Barometer"
        
        // Labels.
        self.relativeAltitudeValueLabel.text = "-"
        self.pressureValueLabel.text = " -"
    }
    
    ///
    /// Setup the Barometer sensor.
    ///
    private func setupBarometer() {
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            // Start Altimeter sensor data readout.
            self.altimeterManager.startRelativeAltitudeUpdates(to: OperationQueue.main) { (data, error) in
                if let altimeterData = data {
                    self.relativeAltitude = altimeterData.relativeAltitude.floatValue
                    self.pressure_kPa = altimeterData.pressure.floatValue
                    self.pressure_atm = 0.00986923266 * self.pressure_kPa
                    
                    self.relativeAltitudeValueLabel.text = " \(self.relativeAltitude)"
                    self.pressureValueLabel.text = " \(self.pressure_kPa) kPa \n \(self.pressure_atm) atm"
                }
            }
        } else {
            self.relativeAltitudeValueLabel.text = " Not Available"
            self.pressureValueLabel.text = " Not Available"
        }
    }
    
}
