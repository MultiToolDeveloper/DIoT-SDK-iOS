//
//  ServicesViewController.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import UIKit
import DIoTSDK

class ServicesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var servicesTableAdapter = ServicesTableAdapter()
    private var servicesTableHeader = ServicesTableViewHeader()
    
    var isActive = false

    override func viewDidLoad() {
        super.viewDidLoad()

        //setup table
        tableView.delegate = servicesTableAdapter
        tableView.dataSource = servicesTableAdapter
        tableView.register(
            UINib(nibName: "ServicesTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ServicesTableViewCell"
        )
        tableView.tableHeaderView = servicesTableHeader
        tableView.sectionHeaderHeight = ScaningTableViewHeader.getHeight()
                
        //setup table header
        servicesTableHeader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: ServicesTableViewHeader.getHeight()) 
        servicesTableHeader.updateAllButton.addTarget(self, action: #selector(updateAll), for: .touchUpInside)
        servicesTableHeader.resetAll.addTarget(self, action: #selector(resetAll), for: .touchUpInside)
        
        //add connection delegate
        servicesTableAdapter.connectionDelegate = { [weak self] feature in
            guard let self = self else { return }
            guard let device = DeviceTabBarController.device else { return }
            
            var alert = UIAlertController(title: "Set channel", message: "Enter a number 1-9", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.text = "1"
            })
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (action) -> Void in
                let textField = (alert!.textFields![0]) as UITextField
                device.commandInterfaceService?.setChannel(channel: Int(textField.text ?? "1") ?? 1, code: feature.getFeatureCode())
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (action) -> Void in
            }))
            self.tabBarController!.present(alert, animated: true, completion: nil)
        }
        
        //add update delegate
        servicesTableAdapter.updateDelegate = { [weak self] feature in
            guard let self = self else { return }
            guard let device = DeviceTabBarController.device else { return }
            device.commandInterfaceService?.fetchFeature(code: feature.getFeatureCode())
        }
        
        //add write delegate
        servicesTableAdapter.writeDelegate = { [weak self] feature in
            guard let self = self else { return }
            guard let device = DeviceTabBarController.device else { return }
            
            var alert = UIAlertController(title: "Set data", message: "Enter 4 data bytes in hex like: 1122bbff", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.text = "00000000"
            })
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (action) -> Void in
                var feature = feature
                let textField = (alert!.textFields![0]) as UITextField
                let data = textField.text?.hexadecimal
                guard let data = data else { return }
                feature = DIoTFeatureData.getFeature(from: feature.getFeatureCode(), value: [UInt8](data))
                device.commandInterfaceService?.setFeature(feature: feature)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (action) -> Void in
            }))
            self.tabBarController!.present(alert, animated: true, completion: nil)
        }
        
        //add reset delegate
        servicesTableAdapter.resetDelegate = { [weak self] feature in
            guard let self = self else { return }
            guard let device = DeviceTabBarController.device else { return }
            device.commandInterfaceService?.cleanFeature(code: feature.getFeatureCode())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateAll()
        isActive = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isActive = false
    }
    
    //MARK: - update and reset all
    @objc func updateAll(){
        if let device = DeviceTabBarController.device {
            device.commandInterfaceService?.fetchFeatures()
        }
    }

    @objc func resetAll(){
        if let device = DeviceTabBarController.device {
            device.commandInterfaceService?.cleanFeatures()
        }
    }
}

//MARK: - DIoTCommandInterfaceBluetoothServiceDelegate
extension ServicesViewController:  DIoTCommandInterfaceBluetoothServiceDelegate {
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, subscriptionFeaturesStatusChange enabled: Bool) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.showToast(message: "Command interface features supsribtion: \(enabled)", font: .systemFont(ofSize: 14.0))
        }
    }
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, subscriptionChannelsStatusChange enabled: Bool) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.showToast(message: "Command interface channels supsribtion: \(enabled)", font: .systemFont(ofSize: 14.0))
        }
    }
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, subscriptionRatesStatusChange enabled: Bool) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.showToast(message: "Command interface rates supsribtion: \(enabled)", font: .systemFont(ofSize: 14.0))
        }
    }
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveCommandFeatures features: [DIoTFeatureData]) {
        guard isActive else { return }
        DispatchQueue.main.async {
            //update list of futures
            self.servicesTableAdapter.features = features
            self.tableView.reloadData()
        }
    }
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveCommandChannels channels: [DIoTChannelData]) {
        //do nothing
    }
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveCommandRate rates: [DIoTRateData]) {
        //do nothing
    }
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveError error: DIoTCommandInterfaceBluetoothServiceError) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.showToast(message: "Command interface error", font: .systemFont(ofSize: 14.0))
        }
    }
    
    func commandInterfaceBluetoothServiceDidWriteCommandFeatures(_ service: DIoTCommandInterfaceBluetoothServiceProtocol) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.showToast(message: "Command interface feature write completed", font: .systemFont(ofSize: 14.0))
        }
    }
    
    func commandInterfaceBluetoothServiceDidWriteCommandChannels(_ service: DIoTCommandInterfaceBluetoothServiceProtocol) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.showToast(message: "Command interface channels write completed", font: .systemFont(ofSize: 14.0))
        }
    }
    
    func commandInterfaceBluetoothServiceDidWriteCommandRate(_ service: DIoTCommandInterfaceBluetoothServiceProtocol) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.showToast(message: "Command interface reates write completed", font: .systemFont(ofSize: 14.0))
        }
    }
}
