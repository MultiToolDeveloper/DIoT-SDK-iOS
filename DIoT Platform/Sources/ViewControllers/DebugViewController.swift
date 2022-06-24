//
//  DebugViewController.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 25.04.2022.
//

import UIKit
import DIoTSDK

class DebugViewController: UIViewController {

    @IBOutlet weak var terminalTextView: UITextView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    private var progressDialog: ProgressDialog? = nil
    
    var device: DIoTBluetoothDevice? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.terminalTextView.text = ""
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        terminalTextView.addGestureRecognizer(tapGesture)
        
        startAvoidingKeyboard()
        
        //show loading
        progressDialog = ProgressDialog.showDialog(parentVC: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let device = DeviceTabBarController.device {
            device.debugService?.subscribe(subscriber: self)
            device.debugService?.notifyDebug(enable: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let device = DeviceTabBarController.device {
            device.debugService?.unsubscribe(subscriber: self)
            device.debugService?.notifyDebug(enable: false)
        }
    }

    @IBAction func sendCommand(_ sender: Any) {
        guard let device = DeviceTabBarController.device else { return }
        guard let command = inputTextField.text else { return }
        device.debugService?.sendDebug(command: command)
    }
}

extension DebugViewController: DIoTDebugBluetoothServiceDelegate {
    func debugService(_ service: DIoTDebugBluetoothServiceProtocol, didReceiveLogs logs: DebugLogPart) {
        //do something
        DispatchQueue.main.async {
            self.terminalTextView.text += logs
        }
    }
    
    func debugService(_ service: DIoTDebugBluetoothServiceProtocol, subscriptionStatusChange enabled: Bool) {
        //do something
        DispatchQueue.main.async {
            self.showToast(message: "Debug service supsribtion: \(enabled)", font: .systemFont(ofSize: 14.0))
            self.progressDialog?.dismiss(animated: true)
        }
    }
}

//MARK: - hide keyboard
extension DebugViewController {
    @objc func dismissKeyboard () {
        inputTextField.resignFirstResponder()
    }
}
