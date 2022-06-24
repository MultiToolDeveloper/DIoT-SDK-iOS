//
//  DataTableViewHeader.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import Foundation
import UIKit

class DataTableViewHeader: UIView {

    @IBOutlet weak var channelLabel: UILabel!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Sutup from NIB
    private func setupView() {

        //configure view
        let view = viewFromNibForClass()
        view.frame =  bounds
        view.clipsToBounds = true
        // Auto-layout stuff.
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        
        // Show the view.
        addSubview(view)
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let rootViews = nib.instantiate(withOwner: self, options: nil)
        
        return rootViews.first as! UIView
    }
    
    // MARK: - Get height
    static func getHeight() -> CGFloat {
        return CGFloat(52)
    }

}

