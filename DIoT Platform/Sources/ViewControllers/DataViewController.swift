//
//  DataViewController.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import UIKit
import DIoTSDK

class DataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataTableAdapter = DataTableAdapter()
    private var dateTableHeader = DataTableViewHeader()
    
    private var progressDialog: ProgressDialog? = nil
    
    var channel: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        //setup table
        tableView.delegate = dataTableAdapter
        tableView.dataSource = dataTableAdapter
        tableView.register(
            UINib(nibName: "DataTableViewCell", bundle: nil),
            forCellReuseIdentifier: "DataTableViewCell"
        )
        tableView.tableHeaderView = dateTableHeader
        tableView.sectionHeaderHeight = DataTableViewHeader.getHeight()
                
        //setup table header
        dateTableHeader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: DataTableViewHeader.getHeight())
        dateTableHeader.channelLabel.text = "Channel \(channel)"
        
        //show loading
        progressDialog = ProgressDialog.showDialog(parentVC: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let device = DeviceTabBarController.device else {return}
        guard let channel = channel else { return }
        device.dataInterfaceService?.subscribe(subscriber: self)
        device.dataInterfaceService?.notifyData(channelNumber: channel, enable: true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guard let device = DeviceTabBarController.device else {return}
        guard let channel = channel else { return }
        device.dataInterfaceService?.notifyData(channelNumber: channel, enable: false)
        device.dataInterfaceService?.unsubscribe(subscriber: self)
    }
}

extension DataViewController: DIoTDataInterfaceBluetoothServiceDelegate {
    func dataInterfaceBluetoothService(_ service: DIoTDataInterfaceBluetoothServiceProtocol, subscriptionDataChannelStatusChange enabled: Bool, channelNumber: Int) {
        //do something
        DispatchQueue.main.async {
            self.showToast(message: "Data channel \(channelNumber) supsribtion: \(enabled)", font: .systemFont(ofSize: 14.0))
            self.progressDialog?.dismiss(animated: true)
        }
    }
    
    func dataInterfaceBluetoothService(_ service: DIoTDataInterfaceBluetoothServiceProtocol, didReceiveDataChannel features: [DIoTFeatureData], channelNumber: Int) {
        DispatchQueue.main.async {
            self.dataTableAdapter.features = features
            self.tableView.reloadData()
        }
    }
    
    func dataInterfaceBluetoothService(_ service: DIoTDataInterfaceBluetoothServiceProtocol, didReceiveError error: DIoTDataInterfaceBluetoothServiceError) {
        //do something
        DispatchQueue.main.async {
            self.showToast(message: "Data interface error", font: .systemFont(ofSize: 14.0))
        }
    }
    
    
}
