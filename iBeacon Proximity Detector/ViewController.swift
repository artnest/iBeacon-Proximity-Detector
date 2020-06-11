//
//  ViewController.swift
//  iBeacon Proximity Detector
//
//  Created by Artyom Nesterenko on 11/6/20.
//  Copyright © 2020 artnest. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet private var uuidTextField: UITextField!
    @IBOutlet private var scanButton: UIButton!
    
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    scanButton.isEnabled = true
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if !beacons.isEmpty {
            updateDistance(beacons[0].proximity)
        } else {
            updateDistance(.unknown)
        }
    }
    
    @IBAction private func scanButtonTapped(_ sender: UIButton) {
        uuidTextField.resignFirstResponder()
        startScanning()
    }
    
    private func startScanning() {
        guard let regionUUID = uuidTextField.text else { return }
        
        let uuid = UUID(uuidString: regionUUID)!
        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: "Kontakt.io Beacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid))
    }
    
    private func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = .gray
            case .far:
                self.view.backgroundColor = .blue
            case .near:
                self.view.backgroundColor = .orange
            case .immediate:
                self.view.backgroundColor = .red
            @unknown default:
                self.view.backgroundColor = .gray
            }
        }
    }
}
