//
//  MainViewController.swift
//  iPhone Sensors Demo
//
//  Created by Aitor Zubizarreta on 24/07/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    let sensorList: [String] = ["Barometer", "Magnetometer", "Gyroscope", "Accelerometer"]
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupTableView()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        self.title = "Sensors"
    }
    
    ///
    /// Setup the Table View.
    ///
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

// MARK: - UITable View Delegate

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // Barometer
            self.navigationController?.pushViewController(BarometerViewController(nibName: "BarometerViewController", bundle: nil), animated: true)
        case 1: // Magnetometer
            self.navigationController?.pushViewController(MagnetometerViewController(nibName: "MagnetometerViewController", bundle: nil), animated: true)
        case 2: // Gyroscope
            self.navigationController?.pushViewController(GyroscopeViewController(nibName: "GyroscopeViewController", bundle: nil), animated: true)
        case 3: // Accelerometer
            self.navigationController?.pushViewController(AccelerometerViewController(nibName: "AccelerometerViewController", bundle: nil), animated: true)
//            self.navigationController?.pushViewController(AccelerometerViewController(), animated: true)
        default:
            print("Unknown sensor selected")
        }
    }
    
}

// MARK: - UITable View Data Source

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sensorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        cell.textLabel?.text = self.sensorList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
}
