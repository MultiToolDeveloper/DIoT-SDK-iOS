//
//  ScaningTableViewCell.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import UIKit

class ScaningTableViewCell: UITableViewCell {

    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceIdLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Get height
    static func getHeight() -> CGFloat {
        return CGFloat(83)
    }
}
