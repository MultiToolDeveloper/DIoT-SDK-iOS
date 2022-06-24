//
//  RatesViewController.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 02.06.2022.
//

import UIKit
import DIoTSDK

class RatesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var ratesTableAdapter = RatesTableAdapter()
    private var ratesTableHeader = RatesTableViewHeader()
    
    var isActive = false

    override func viewDidLoad() {
        super.viewDidLoad()

        //setup table
        tableView.delegate = ratesTableAdapter
        tableView.dataSource = ratesTableAdapter
        tableView.register(
            UINib(nibName: "RatesTableViewCell", bundle: nil),
            forCellReuseIdentifier: "RatesTableViewCell"
        )
        tableView.tableHeaderView = ratesTableHeader
        tableView.sectionHeaderHeight = ChannelsTableViewHeader.getHeight()
                
        //setup table header
        ratesTableHeader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: ChannelsTableViewHeader.getHeight())
        ratesTableHeader.updateButton.addTarget(self, action: #selector(updateAll), for: .touchUpInside)
        ratesTableHeader.resetAll.addTarget(self, action: #selector(resetAll), for: .touchUpInside)
        
        //add connection delegate
        ratesTableAdapter.dataDelegate = { [weak self] number in
            guard let self = self else { return }
            guard let device = DeviceTabBarController.device else { return }
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
            viewController.channel = number
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        //add rate delegate
        ratesTableAdapter.rateDelegate = { [weak self] number in
            guard let self = self else { return }
            guard let device = DeviceTabBarController.device else { return }
            
            var alert = UIAlertController(title: "Set rate", message: "Enter a number in ms", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.text = "100"
            })
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (action) -> Void in
                let textField = (alert!.textFields![0]) as UITextField
                device.commandInterfaceService?.setRate(channel: number, rate: UInt32(textField.text ?? "100") ?? 100)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (action) -> Void in
            }))
            self.tabBarController!.present(alert, animated: true, completion: nil)
        }
        
        //add clean delegate
        ratesTableAdapter.cleanDelegate = { [weak self] number in
            guard let self = self else { return }
            guard let device = DeviceTabBarController.device else { return }
            device.commandInterfaceService?.cleanRate(channel: number)
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
            device.commandInterfaceService?.fetchRates()
        }
    }
    
    @objc func resetAll(){
        if let device = DeviceTabBarController.device {
            device.commandInterfaceService?.cleanRates()
        }
    }
}

//MARK: - DIoTCommandInterfaceBluetoothServiceDelegate
extension RatesViewController:  DIoTCommandInterfaceBluetoothServiceDelegate {
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, subscriptionFeaturesStatusChange enabled: Bool) {
        //do nothing
    }
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, subscriptionChannelsStatusChange enabled: Bool) {
        //do nothing
    }
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, subscriptionRatesStatusChange enabled: Bool) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.showToast(message: "Command interface rates supsribtion: \(enabled)", font: .systemFont(ofSize: 14.0))
        }
    }
    
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveCommandFeatures features: [DIoTFeatureData]) {
        //do nothing
    }
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveCommandChannels channels: [DIoTChannelData]) {
        //do nothing
    }
    
    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveCommandRate rates: [DIoTRateData]) {
        guard isActive else { return }
        DispatchQueue.main.async {
            self.ratesTableAdapter.rates = rates
            self.tableView.reloadData()
        }
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
            self.showToast(message: "Command interface rates write completed", font: .systemFont(ofSize: 14.0))
        }
    }
}


