//
//  ChannelsTableAdapter.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//


import Foundation
import UIKit
import DIoTSDK

class  ChannelsTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var channels : [DIoTChannelData] = []
    var dataDelegate: ((Int) -> ())?
    var rateDelegate: ((Int) -> ())?
    var cleanDelegate: ((Int) -> ())?
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ChannelsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChannelsTableViewCell") as! ChannelsTableViewCell
        cell.selectionStyle = .none
        
        let channelData = channels[indexPath.item]
        cell.channelNum.text = "Channel \(channelData.channelNumber)"
        cell.channelServices.text = "Feature \(channelData.feature.getNameString())"
        
        cell.dataButton.tag = indexPath.item
        cell.dataButton.addTarget(self, action: #selector(data(_:)), for: .touchUpInside)
        cell.setupFrequencyButton.tag = indexPath.item
        cell.setupFrequencyButton.addTarget(self, action: #selector(rate(_:)), for: .touchUpInside)
        cell.cleanInputServicesButton.tag = indexPath.item
        cell.cleanInputServicesButton.addTarget(self, action: #selector(clean(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ChannelsTableViewCell.getHeight()
    }


    @objc func data(_ sender: UIButton){
        if let delegate = dataDelegate {
            delegate(channels[sender.tag].channelNumber)
        }
    }
    
    @objc func rate(_ sender: UIButton){
        if let delegate = rateDelegate {
            delegate(channels[sender.tag].channelNumber)
        }
    }
    
    @objc func clean(_ sender: UIButton){
        if let delegate = cleanDelegate {
            delegate(channels[sender.tag].channelNumber)
        }
    }
}
