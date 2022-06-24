//
//  DeviceTabBarController.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import UIKit
import DIoTSDK

class DeviceTabBarController: UITabBarController {
    
    static var device: DIoTBluetoothDevice? = nil
    private var progressDialog: ProgressDialog? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if let device = DeviceTabBarController.device {
            
            device.connectionService?.subscribe(subscriber: self)
            device.connectionService?.connect()
            
            //show loading
            progressDialog = ProgressDialog.showDialog(parentVC: self)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil {
            //"Back pressed" - disconnect
            if let device = DeviceTabBarController.device {
                device.connectionService?.disconnect()
                device.connectionService?.unsubscribe(subscriber: self)
                device.commandInterfaceService?.unsubscribe(subscriber: self.children[0] as! ServicesViewController)
                device.commandInterfaceService?.unsubscribe(subscriber: self.children[1] as! ChannelsViewController)
                device.commandInterfaceService?.unsubscribe(subscriber: self.children[2] as! RatesViewController)
                device.batteryService?.unsubscribe(subscriber: self.children[3] as! SystemViewController)
                device.deviceInformationService?.unsubscribe(subscriber: self.children[3] as! SystemViewController)
                device.connectionService?.unsubscribe(subscriber: self.children[3] as! SystemViewController)
            }
        }
    }
}

//MARK: - subscribe on bluetooth device actions
extension DeviceTabBarController: DIoTBluetoothDeviceConnectionServiceDelegate {
    func diotDevice(_ service: DIoTBluetoothDeviceConnectionServiceProtocol, didReceiveRSSI rssi: Double) {
        DispatchQueue.main.async {
            self.showToast(message: "DIoT Device RSSI received: \(rssi)", font: .systemFont(ofSize: 14.0))
        }
    }
    
    func diotDeviceDidConnect(_ service: DIoTBluetoothDeviceConnectionServiceProtocol) {
        DispatchQueue.main.async {
            self.showToast(message: "DIoT Device connected and discovered", font: .systemFont(ofSize: 14.0))
            
            //hide loading
            self.progressDialog?.dismiss(animated: true)
            
            if let device = DeviceTabBarController.device {
                device.commandInterfaceService?.subscribe(subscriber: self.children[0] as! ServicesViewController)
                device.commandInterfaceService?.subscribe(subscriber: self.children[1] as! ChannelsViewController)
                device.commandInterfaceService?.subscribe(subscriber: self.children[2] as! RatesViewController)
                device.batteryService?.subscribe(subscriber: self.children[3] as! SystemViewController)
                device.deviceInformationService?.subscribe(subscriber: self.children[3] as! SystemViewController)
                device.connectionService?.subscribe(subscriber: self.children[3] as! SystemViewController)
            }
            
            //initiate first data request
            (self.children[0] as! ServicesViewController).updateAll()
        }
    }
    
    func diotDeviceDidDisconnect(_ service: DIoTBluetoothDeviceConnectionServiceProtocol) {
        DispatchQueue.main.async {
            self.showToast(message: "DIoT Device disconnected", font: .systemFont(ofSize: 14.0))
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func diotDeviceDidFailToConnect(_ service: DIoTBluetoothDeviceConnectionServiceProtocol) {
        DispatchQueue.main.async {
            self.showToast(message: "DIoT Device connect fail", font: .systemFont(ofSize: 14.0))
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func diotDevice(_ service: DIoTBluetoothDeviceConnectionServiceProtocol, didReceiveError error: GeneralBluetoothDeviceError) {
        DispatchQueue.main.async {
            self.showToast(message: "DIoT Device error", font: .systemFont(ofSize: 14.0))
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
