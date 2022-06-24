//
//  ScaningTableViewHeader.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import UIKit

class ScaningTableViewHeader: UIView {

    @IBOutlet weak var scaningFilterLabel: UILabel!
    @IBOutlet weak var scaningFilterTextField: UITextField!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var ResultsLabel: UILabel!
    
    
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
        return CGFloat(144)
    }

}
