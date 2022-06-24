//
//  ProgressDialog.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 14.06.2022.
//

import Foundation
import UIKit

class ProgressDialog: UIViewController {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.layer.cornerRadius = 20
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(named: "app_setings_button")?.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        progress.startAnimating()
    }

    static func showDialog(parentVC: UIViewController) -> ProgressDialog {
        let dialogViewController = ProgressDialog()
        dialogViewController.modalPresentationStyle = .custom
        dialogViewController.modalTransitionStyle = .crossDissolve
        parentVC.present(dialogViewController, animated: true)
        
        return dialogViewController
    }
}
