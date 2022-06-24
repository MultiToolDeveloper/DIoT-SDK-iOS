//
//  SystemViewController.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import UIKit
import DIoTSDK

class SystemViewController: UIViewController {
    
    @IBOutlet weak var softwareLabel: UILabel!
    @IBOutlet weak var firmwareLabel: UILabel!
    @IBOutlet weak var hardwareLabel: UILabel!
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var manufacturerLable: UILabel!
    @IBOutlet weak var updateInfoButton: UIButton!
    
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var updateBatteryButton: UIButton!
    
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var showDebugButton: UIButton!
    
    @IBOutlet weak var firmwareUpdateLabel: UILabel!
    @IBOutlet weak var launchUpdateButton: UIButton!
    
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var rssiButton: UIButton!
    
    var isActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateInfoButton.addTarget(self, action: #selector(updateInfo), for: .touchUpInside)
        updateBatteryButton.addTarget(self, action: #selector(updateBattery), for: .touchUpInside)
        showDebugButton.addTarget(self, action: #selector(launchDebug), for: .touchUpInside)
        launchUpdateButton.addTarget(self, action: #selector(launchUpdate), for: .touchUpInside)
        rssiButton.addTarget(self, action: #selector(updateRSSI), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isActive = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isActive = false
    }


    //MARK: - updateInfo
    @objc func updateInfo(){
        if let device = DeviceTabBarController.device {
            device.deviceInformationService?.fetchModelNumber()
            device.deviceInformationService?.fetchFirmwareVersion()
            device.deviceInformationService?.fetchSoftwareVersion()
            device.deviceInformationService?.fetchHardwareVersion()
            device.deviceInformationService?.fetchManufactureName()
        }
    }
    
    //MARK: - updateBattery
    @objc func updateBattery(){
        if let device = DeviceTabBarController.device {
            device.batteryService?.fetchBatteryLevel()
        }
    }
    
    //MARK: - launchDebug
    @objc func launchDebug(){
        if let device = DeviceTabBarController.device {
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DebugViewController") as! DebugViewController
            viewController.device = device
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    //MARK: - launchUpdate
    @objc func launchUpdate(){
        if let device = DeviceTabBarController.device {
            
        }
    }
    
    //MARK: - updateRSSI
    @objc func updateRSSI(){
        if let device = DeviceTabBarController.device {
            device.connectionService?.readRSSI()
        }
    }
}


//MARK: - GeneralBatteryBluetoothServiceDelegate
extension SystemViewController: GeneralBatteryBluetoothServiceDelegate {
    func batteryService(_ service: GeneralBatteryBluetoothServiceProtocol, subscriptionStatusChange enabled: Bool) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.showToast(message: "Battery service supsribtion: \(enabled)", font: .systemFont(ofSize: 14.0))
        }
    }
    
    func batteryService(_ service: GeneralBatteryBluetoothServiceProtocol, didReceiveLevel level: UInt) {
        DispatchQueue.main.async {
            self.batteryLabel.text = "Battery: \(level)"
        }
    }
}

//MARK: - GeneralDeviceInformationBluetoothServiceDelegate
extension SystemViewController: GeneralDeviceInformationBluetoothServiceDelegate {
    func deviceInformationService(_ service: GeneralDeviceInformationBluetoothServiceProtocol, didReceiveFirmwareRevision firmwareRevision: String) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.firmwareLabel.text = "Firmware: \(firmwareRevision)"
        }
    }
    
    func deviceInformationService(_ service: GeneralDeviceInformationBluetoothServiceProtocol, didReceiveHardwareRevision hardwareRevision: String) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.hardwareLabel.text = "Hardware: \(hardwareRevision)"
        }
    }
    
    func deviceInformationService(_ service: GeneralDeviceInformationBluetoothServiceProtocol, didReceiveSoftwareRevision softwareRevision: String) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.softwareLabel.text = "Software: \(softwareRevision)"
        }
    }
    
    func deviceInformationService(_ service: GeneralDeviceInformationBluetoothServiceProtocol, didReceiveManufactureName manufactureName: String) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.manufacturerLable.text = "Manufacturer: \(manufactureName)"
        }
    }
    
    func deviceInformationService(_ service: GeneralDeviceInformationBluetoothServiceProtocol, didReceiveModelNumber modelNumber: String) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.deviceLabel.text = "Device: \(modelNumber)"
        }
    }
}

extension SystemViewController: DIoTBluetoothDeviceConnectionServiceDelegate {
    func diotDevice(_ service: DIoTBluetoothDeviceConnectionServiceProtocol, didReceiveRSSI rssi: Double) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.rssiLabel.text = "RSSI: \(rssi)"
        }
    }
    
    func diotDeviceDidConnect(_ service: DIoTBluetoothDeviceConnectionServiceProtocol) {
        //do nothing
    }
    
    func diotDeviceDidDisconnect(_ service: DIoTBluetoothDeviceConnectionServiceProtocol) {
        //do nothing
    }
    
    func diotDeviceDidFailToConnect(_ service: DIoTBluetoothDeviceConnectionServiceProtocol) {
        //do nothing
    }
    
    func diotDevice(_ service: DIoTBluetoothDeviceConnectionServiceProtocol, didReceiveError error: GeneralBluetoothDeviceError) {
        //do nothing
    }
    
}
