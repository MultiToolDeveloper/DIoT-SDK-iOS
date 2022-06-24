//
//  ScaningTableAdapter.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import Foundation
import UIKit
import DIoTSDK

class  ScaningTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var devices : [DIoTBluetoothDevice] = []
    var scanRssi : [Double] = []
    var connectionDelegate: ((DIoTBluetoothDevice) -> ())?
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: ScaningTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ScaningTableViewCell") as! ScaningTableViewCell
        cell.selectionStyle = .none
        
        cell.deviceNameLabel.text = devices[indexPath.item].name + "     rssi: \(scanRssi[indexPath.item])"
        cell.deviceIdLabel.text = devices[indexPath.item].deviceId.uuid.uuidString
        cell.connectButton.tag = indexPath.item
        cell.connectButton.addTarget(self, action: #selector(connect(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScaningTableViewCell.getHeight()
    }

    @objc func connect(_ sender: UIButton){
        if let delegate = connectionDelegate {
            delegate(devices[sender.tag])
        }
    }

}
