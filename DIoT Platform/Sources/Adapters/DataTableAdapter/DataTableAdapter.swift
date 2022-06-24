//
//  DataTableAdapter.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import Foundation
import UIKit
import DIoTSDK

class  DataTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var features : [DIoTFeatureData] = []
    
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
        var cell: DataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell") as! DataTableViewCell
        cell.selectionStyle = .none
        
        let feature = features[indexPath.item]
        cell.serviceNameLabel.text = feature.getNameString()
        cell.dataLabel.text = feature.getDataString()
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DataTableViewCell.getHeight()
    }


}
