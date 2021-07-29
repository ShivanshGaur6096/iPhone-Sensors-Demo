//
//  GyroscopeViewController.swift
//  iPhone Sensors Demo
//
//  Created by Aitor Zubizarreta Perez on 28/07/2021.
//

import UIKit

class GyroscopeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        self.title = "Gyroscope"
    }
    
}
