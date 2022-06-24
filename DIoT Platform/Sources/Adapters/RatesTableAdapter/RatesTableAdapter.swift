//
//  RatesTableAdapter.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 02.06.2022.
//

import Foundation
import UIKit
import DIoTSDK

class  RatesTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var rates : [DIoTRateData] = []
    var dataDelegate: ((Int) -> ())?
    var rateDelegate: ((Int) -> ())?
    var cleanDelegate: ((Int) -> ())?
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: RatesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RatesTableViewCell") as! RatesTableViewCell
        cell.selectionStyle = .none
        
        let rateData = rates[indexPath.item]
        cell.channelNum.text = "Channel \(rateData.channelNumber)"
        cell.channelRate.text = "Rate \(rateData.rate)"
        
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
        return RatesTableViewCell.getHeight()
    }


    @objc func data(_ sender: UIButton){
        if let delegate = dataDelegate {
            delegate(rates[sender.tag].channelNumber)
        }
    }
    
    @objc func rate(_ sender: UIButton){
        if let delegate = rateDelegate {
            delegate(rates[sender.tag].channelNumber)
        }
    }
    
    @objc func clean(_ sender: UIButton){
        if let delegate = cleanDelegate {
            delegate(rates[sender.tag].channelNumber)
        }
    }
}
