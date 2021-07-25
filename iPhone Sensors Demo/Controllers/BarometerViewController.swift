//
//  BarometerViewController.swift
//  iPhone Sensors Demo
//
//  Created by Aitor Zubizarreta on 25/07/2021.
//

import UIKit

class BarometerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        self.title = "Barometer"
    }
}
