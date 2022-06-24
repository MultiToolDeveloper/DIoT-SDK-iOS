//
//  ViewController.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 04.04.2022.
//

import UIKit
import DIoTSDK

class ScaningViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var scaningTableAdapter = ScaningTableAdapter()
    private var scaningTableHeader = ScaningTableViewHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let logo = UILabel()
        logo.text = "DIoT Platform"
        self.navigationItem.titleView = logo
        self.navigationItem.setHidesBackButton(false, animated: false)
                
        //setup table
        tableView.delegate = scaningTableAdapter
        tableView.dataSource = scaningTableAdapter
        tableView.register(
            UINib(nibName: "ScaningTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ScaningTableViewCell"
        )
        tableView.tableHeaderView = scaningTableHeader
        tableView.sectionHeaderHeight = ScaningTableViewHeader.getHeight()
                
        //setup table header
        scaningTableHeader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: ScaningTableViewHeader.getHeight())
        scaningTableHeader.scanButton.addTarget(self, action: #selector(scanPressed), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tableView.addGestureRecognizer(tapGesture)
        
        //add connection delegate
        scaningTableAdapter.connectionDelegate = { [weak self] device in
            guard let self = self else { return }
            
            if self.isScaning {
                self.scanPressed()
            }

            //go next screen
            self.goNext(device: device)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DIoT.bluetoothManager.subscribe(self, to: .state)
    }
    
    //MARK: - scaning
    private var isScaning = false
    
    @objc func scanPressed(){
        
        dismissKeyboard()
        
        //show alert if bluetooth is disabled
        DIoT.bluetoothManager.fetchBluetoothPowerState()
        
        if !isScaning {
            //start scan
            DIoT.bluetoothManager.subscribe(self, to: .scan)
            DIoT.bluetoothManager.scanForPeripherals(withServices: nil, allowDuplicates: true)
            scaningTableHeader.scanButton.setTitle("Stop", for: .normal)
        } else {
            //stop scan
            DIoT.bluetoothManager.stopScanningForPeripherals()
            DIoT.bluetoothManager.unsubscribe(self, from: .scan)
            scaningTableHeader.scanButton.setTitle("Scan", for: .normal)
            
            //clean array
            self.scaningTableAdapter.devices.removeAll(keepingCapacity: false)
            self.tableView.reloadData()
        }
        isScaning = !isScaning
    }
}

//MARK: - subscribe on ble scaning
extension ScaningViewController: DIoTBluetoothScanningManagerDelegate {
    func bluetoothManager(_ manager: DIoTBluetoothScanningManagerProtocol, didDiscoverDevice device: DIoTBluetoothDeviceProtocol, rssi: Double) {
        //do something
        DispatchQueue.main.async {

            //checking dublicates
            if !self.scaningTableAdapter.devices.contains(device as! DIoTBluetoothDevice) {
                //checking filter
                if let filter = self.scaningTableHeader.scaningFilterTextField.text, filter != "" {
                    if device.name.contains(filter) || device.deviceId.uuid.uuidString.contains(filter) {
                        self.scaningTableAdapter.devices.append(device as! DIoTBluetoothDevice)
                        self.scaningTableAdapter.scanRssi.append(rssi)
                        self.showToast(message: "BT scan found", font: .systemFont(ofSize: 14.0))
                    }
                } else {
                    self.scaningTableAdapter.devices.append(device as! DIoTBluetoothDevice)
                    self.scaningTableAdapter.scanRssi.append(rssi)
                    self.showToast(message: "BT scan found", font: .systemFont(ofSize: 14.0))
                }
            }
            
            for i in 0 ..< self.scaningTableAdapter.devices.count {
                if (self.scaningTableAdapter.devices[i].address == device.address) {
                    self.scaningTableAdapter.scanRssi[i] = rssi
                    }
            }
            
            //reload data in table
            self.tableView.reloadData()
        }
    }
    
    func bluetoothManager(_ manager: DIoTBluetoothScanningManagerProtocol, didReceiveScanningError error: DIoTBluetoothManagerScanningError) {
        //do nothing
    }
}

//MARK: - subscribe on ble hardware actions
extension ScaningViewController: DIoTBluetoothStateManagerDelegate {
    func bluetoothManagerUndefinedBluetooth(_ manager: DIoTBluetoothConnectionManagerProtocol) {
        DispatchQueue.main.async {
            self.showToast(message: "BT undefined", font: .systemFont(ofSize: 14.0))
        }
    }
    
    func bluetoothManagerEnabledBluetooth(_ manager: DIoTBluetoothConnectionManagerProtocol) {
        DispatchQueue.main.async {
            self.showToast(message: "BT enabled", font: .systemFont(ofSize: 14.0))
        }
    }
    
    func bluetoothManagerDisabledBluetooth(_ manager: DIoTBluetoothConnectionManagerProtocol) {
        DispatchQueue.main.async {
            self.showToast(message: "BT disabled", font: .systemFont(ofSize: 14.0))
        }
    }
    
    func bluetoothManagerNotAllowedBluetooth(_ manager: DIoTBluetoothConnectionManagerProtocol) {
        DispatchQueue.main.async {
            self.showToast(message: "BT not allowed", font: .systemFont(ofSize: 14.0))
        }
    }
    
    func bluetoothManagerResetting(_ manager: DIoTBluetoothConnectionManagerProtocol) {
        DispatchQueue.main.async {
            self.showToast(message: "BT reseting", font: .systemFont(ofSize: 14.0))
        }
    }
}

//MARK: - next screen actions
extension ScaningViewController {
    func goNext(device: DIoTBluetoothDevice){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DeviceTabBarController") as! DeviceTabBarController
        DeviceTabBarController.device = device
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - hide keyboard
extension ScaningViewController {
    @objc func dismissKeyboard () {
        scaningTableHeader.scaningFilterTextField.resignFirstResponder()
    }
}
