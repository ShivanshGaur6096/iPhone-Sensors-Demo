//
//  MagnetometerViewController.swift
//  iPhone Sensors Demo
//
//  Created by Aitor Zubizarreta Perez on 27/07/2021.
//

import UIKit

class MagnetometerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        self.title = "Magnetometer"
    }
    
}
