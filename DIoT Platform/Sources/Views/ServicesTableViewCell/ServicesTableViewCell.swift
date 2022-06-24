//
//  ServicesTableViewCell.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import UIKit

class ServicesTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceDataLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var writeData: UIButton!
    @IBOutlet weak var resetData: UIButton!
    
    
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
        return CGFloat(133)
    }
}
