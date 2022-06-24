//
//  ChannelsTableViewCell.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import UIKit

class ChannelsTableViewCell: UITableViewCell {

    @IBOutlet weak var channelNum: UILabel!
    @IBOutlet weak var channelServices: UILabel!
    @IBOutlet weak var dataButton: UIButton!
    @IBOutlet weak var cleanInputServicesButton: UIButton!
    @IBOutlet weak var setupFrequencyButton: UIButton!
    
    
    
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
        return CGFloat(131)
    }
}
