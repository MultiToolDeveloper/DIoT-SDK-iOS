//
//  ServicesTableAdapter.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import Foundation
import UIKit
import DIoTSDK

class  ServicesTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var features : [DIoTFeatureData] = []
    var connectionDelegate: ((DIoTFeatureData) -> ())?
    var updateDelegate: ((DIoTFeatureData) -> ())?
    var writeDelegate: ((DIoTFeatureData) -> ())?
    var resetDelegate: ((DIoTFeatureData) -> ())?

    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ServicesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ServicesTableViewCell") as! ServicesTableViewCell
        cell.selectionStyle = .none
        
        let feature = features[indexPath.item]
        cell.serviceNameLabel.text = feature.getNameString()
        cell.serviceDataLabel.text = feature.getDataString()
        
        cell.connectButton.tag = indexPath.item
        cell.connectButton.addTarget(self, action: #selector(connect(_:)), for: .touchUpInside)
        cell.updateButton.tag = indexPath.item
        cell.updateButton.addTarget(self, action: #selector(update(_:)), for: .touchUpInside)
        cell.writeData.tag = indexPath.item
        cell.writeData.addTarget(self, action: #selector(write(_:)), for: .touchUpInside)
        cell.resetData.tag = indexPath.item
        cell.resetData.addTarget(self, action: #selector(reset(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ServicesTableViewCell.getHeight()
    }

    @objc func connect(_ sender: UIButton){
        if let delegate = connectionDelegate {
            delegate(features[sender.tag])
        }
    }
    
    @objc func update(_ sender: UIButton){
        if let delegate = updateDelegate {
            delegate(features[sender.tag])
        }
    }

    @objc func write(_ sender: UIButton){
        if let delegate = writeDelegate {
            delegate(features[sender.tag])
        }
    }
    
    @objc func reset(_ sender: UIButton){
        if let delegate = resetDelegate {
            delegate(features[sender.tag])
        }
    }
}
