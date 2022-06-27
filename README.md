# DIoT Android SDK

**Welcome to DIoT Android SDK Application page!**

DIoT is a platform for different IoT devices provided by Daatrics LTD company.
The current SDK is released for iOS and Android systems and and you are free to use it to implement a connectivity between your phone and device via BLE. 

SDK project also contains demo apps with a whole work flow implementation.

## Initialization

The initialization process contains several steps:
1) Init pods inside your project directory:

       pod init

2) Add a dependency to your **Podfile**:

       pod 'DIoTSDK', :git => 'git@github.com:MultiToolDeveloper/DIoT-SDK-iOS.git'
       
3) Install pods with command:

       pod install
       
4) Use generated **.xcworkspace** file instead of **.xcodeproj**

5) Make sure that you added bluetooth usage description to the **info.plist** flie

        Privacy - Bluetooth Peripheral Usage Description
		Privacy - Bluetooth Always Usage Description


## Scanning

The main SDK Bluetooth module is DIoTBluetoothManager. This class is used as an additional level after the system classes BluetoothManager and BluetoothAdapter. It is used to: check the status of the system BT adapter, scann BLE devices, forward status events to subscribers of the service.

		public protocol DIoTBluetoothManagerProtocol: class {
		    var queue: DispatchQueue { get }
		    func subscribe(_ subscriber: DIoTBluetoothManagerDelegate, to subscriptionType: DIoTBluetoothManagerSubscriptionType)
		    func unsubscribe(_ subscriber: DIoTBluetoothManagerDelegate, from subscriptionType: DIoTBluetoothManagerSubscriptionType)
		}

		public protocol DIoTBluetoothStateManagerProtocol: DIoTBluetoothManagerProtocol {
		    func fetchBluetoothPowerState()
		}

		public protocol DIoTBluetoothScanningManagerProtocol: DIoTBluetoothManagerProtocol {
		    func startScan(withServices services: [BluetoothServiceType]?, allowDuplicates: Bool)
		    func stopScan()
		}

		public protocol DIoTBluetoothConnectionManagerProtocol: DIoTBluetoothManagerProtocol {
		    func retrievePeripherals(withIdentifiers identifiers: [UUID], competion: @escaping ([PeripheralProtocol]) -> Void)
		    func retrievePeripheral(withIdentifier identifier: UUID, competion: @escaping (PeripheralProtocol?) -> Void)
		    func connect(to peripheral: PeripheralProtocol)
		    func disconnect(from peripheral: PeripheralProtocol)
		}
		
To get the scan result, you need to subscribe to DIoTBluetoothManager events, for example:

		DIoT.bluetoothManager.subscribe(self, to: .scan)
		DIoT.bluetoothManager.startScan(withServices: nil, allowDuplicates: true)
		DIoT.bluetoothManager.stopScan()

You will receive a callback to your delegate implementation:

		public protocol DIoTBluetoothScanningManagerDelegate: DIoTBluetoothManagerDelegate {
		    func bluetoothManager(
		        _ manager: DIoTBluetoothScanningManagerProtocol,
		        didDiscoverDevice device: DIoTBluetoothDeviceProtocol,
		        rssi: Double
		    )
		    func bluetoothManager(
		        _ manager: DIoTBluetoothScanningManagerProtocol,
		        didReceiveScanningError error: DIoTBluetoothManagerScanningError
		    )
		}

To get information about the status of the BT hardware module, you need to subscribe to DIoTBluetoothManager events, for example:

		DIoT.bluetoothManager.subscribe(self, to: .state)
		DIoT.bluetoothManager.fetchBluetoothPowerState()

After the request next delegate will be triggered:

		public protocol DIoTBluetoothStateManagerDelegate: DIoTBluetoothManagerDelegate {
		    func bluetoothManagerUndefinedBluetooth(_ manager: DIoTBluetoothConnectionManagerProtocol)
		    func bluetoothManagerEnabledBluetooth(_ manager: DIoTBluetoothConnectionManagerProtocol)
		    func bluetoothManagerDisabledBluetooth(_ manager: DIoTBluetoothConnectionManagerProtocol)
		    func bluetoothManagerNotAllowedBluetooth(_ manager: DIoTBluetoothConnectionManagerProtocol)
		    func bluetoothManagerResetting(_ manager: DIoTBluetoothConnectionManagerProtocol)
		}

## Device

As a result of the scan, one or more DIoT devices will be returned, this class contains connection functions, a list of services and signal strength determination, as well as information about the device (name, id, etc.):

		public protocol DIoTBluetoothDeviceProtocol {
		    var name: String { get }
		    var deviceId: DeviceId { get }
		    var address: String { get }
		    
		    var connectionService: DIoTBluetoothDeviceConnectionServiceProtocol? { get }
		    var deviceInformationService: GeneralDeviceInformationBluetoothServiceProtocol? { get }
		    var batteryService: GeneralBatteryBluetoothServiceProtocol? { get }
		    var commandInterfaceService: DIoTCommandInterfaceBluetoothServiceProtocol? { get }
		    var dataInterfaceService: DIoTDataInterfaceBluetoothServiceProtocol? { get }
		    var deviceIdentifierService: DIoTDeviceIdBluetoothServiceProtocol? { get }
		    var debugService: DIoTDebugBluetoothServiceProtocol? { get }
		}

Device structure contains services and functions with data structures is used to communication with IoT device via BLE connection.

- connectionService is used to connect and disconnect to current device
- deviceInformationService is used to get device's version information
- batteryService is used to get device's battery information
- commandInterfaceService is used to get current device features, and setup connection between features and data channels (for example: 1 -  get list of the current device features; 2 - get one of those features and connect it to the data channel; 3 - set up the data rate on the target data channel). The data rate sets up like integer number in ms (the current channel update delay), default data rate is 0 or auto update.
- dataInterfaceService is used to get data from the connected features (each device content up to 9 data channels with indexes: 1...9)
- deviceIdentifierService - is used to receive device UUID
- debugService - is used to communicate with internal CLI

## Connection

To connect to the device, you must use the connect method in the ConnectionService service of the DIoTBluetoothDevice class:

		var device: DIoTBluetoothDevice? = ... //result of a scan
		if  let device = device {
			device.connectionService?.subscribe(subscriber: self)
			device.connectionService?.connect()
		}

You have to use the connectionService.subscribe() function and implement a delegate interface inside you class to receive connection state callbacks:

		public protocol DIoTBluetoothDeviceConnectionServiceDelegate: class {
		    func diotDevice(_ service: DIoTBluetoothDeviceConnectionServiceProtocol, didReceiveRSSI rssi: Double)
		    func diotDeviceDidConnect(_ service: DIoTBluetoothDeviceConnectionServiceProtocol)
		    func diotDeviceDidDisconnect(_ service: DIoTBluetoothDeviceConnectionServiceProtocol)
		    func diotDeviceDidFailToConnect(_ service: DIoTBluetoothDeviceConnectionServiceProtocol)
		    func diotDevice(_ service: DIoTBluetoothDeviceConnectionServiceProtocol, didReceiveError error: GeneralBluetoothDeviceError)
		}

## Data exchange

The data exchange is carried out through services designated in the DIoTBluetoothDevice class.

		public protocol DIoTBluetoothDeviceProtocol {
		    var name: String { get }
		    var deviceId: DeviceId { get }
		    var address: String { get }
		    
		    var connectionService: DIoTBluetoothDeviceConnectionServiceProtocol? { get }
		    var deviceInformationService: GeneralDeviceInformationBluetoothServiceProtocol? { get }
		    var batteryService: GeneralBatteryBluetoothServiceProtocol? { get }
		    var commandInterfaceService: DIoTCommandInterfaceBluetoothServiceProtocol? { get }
		    var dataInterfaceService: DIoTDataInterfaceBluetoothServiceProtocol? { get }
		    var deviceIdentifierService: DIoTDeviceIdBluetoothServiceProtocol? { get }
		    var debugService: DIoTDebugBluetoothServiceProtocol? { get }
		}
Each service contains methods related to the data involved in this service, as well as methods and corresponding class delegates that the signatories must correspond to. You can subscribe  and unsubscribe on events with:

		func subscribe(subscriber:)
		func unsubscribe(subscriber:)

## Data request example

Let's try to get data from the DIoT Command Interface service.

1) Subscribe to receive data from the DIoT Command Interface service

   		device.commandInterfaceService?.subscribe(subscriber: self)
2) Implement the DIoTCommandInterfaceBluetoothServiceDelegate methods:

		    extension ServicesViewController:  DIoTCommandInterfaceBluetoothServiceDelegate {
	    
		    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, subscriptionFeaturesStatusChange enabled: Bool) {
		        guard isActive else { return }
		        DispatchQueue.main.async {
		            self.showToast(message: "Command interface features supsribtion: \(enabled)", font: .systemFont(ofSize: 14.0))
		        }
		    }
		    
		    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, subscriptionChannelsStatusChange enabled: Bool) {
		        guard isActive else { return }
		        DispatchQueue.main.async {
		            self.showToast(message: "Command interface channels supsribtion: \(enabled)", font: .systemFont(ofSize: 14.0))
		        }
		    }
		    
		    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, subscriptionRatesStatusChange enabled: Bool) {
		        guard isActive else { return }
		        DispatchQueue.main.async {
		            self.showToast(message: "Command interface rates supsribtion: \(enabled)", font: .systemFont(ofSize: 14.0))
		        }
		    }
		    
		    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveCommandFeatures features: [DIoTFeatureData]) {
		        guard isActive else { return }
		        DispatchQueue.main.async {
		            //update list of futures
		            self.servicesTableAdapter.features = features
		            self.tableView.reloadData()
		        }
		    }
		    
		    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveCommandChannels channels: [DIoTChannelData]) {
		        //do nothing
		    }
		    
		    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveCommandRate rates: [DIoTRateData]) {
		        //do nothing
		    }
		    
		    func commandInterfaceBluetoothService(_ service: DIoTCommandInterfaceBluetoothServiceProtocol, didReceiveError error: DIoTCommandInterfaceBluetoothServiceError) {
		        guard isActive else { return }
		        DispatchQueue.main.async {
		            self.showToast(message: "Command interface error", font: .systemFont(ofSize: 14.0))
		        }
		    }
		    
		    func commandInterfaceBluetoothServiceDidWriteCommandFeatures(_ service: DIoTCommandInterfaceBluetoothServiceProtocol) {
		        guard isActive else { return }
		        DispatchQueue.main.async {
		            self.showToast(message: "Command interface feature write completed", font: .systemFont(ofSize: 14.0))
		        }
		    }
		    
		    func commandInterfaceBluetoothServiceDidWriteCommandChannels(_ service: DIoTCommandInterfaceBluetoothServiceProtocol) {
		        guard isActive else { return }
		        DispatchQueue.main.async {
		            self.showToast(message: "Command interface channels write completed", font: .systemFont(ofSize: 14.0))
		        }
		    }
		    
		    func commandInterfaceBluetoothServiceDidWriteCommandRate(_ service: DIoTCommandInterfaceBluetoothServiceProtocol) {
		        guard isActive else { return }
		        DispatchQueue.main.async {
		            self.showToast(message: "Command interface reates write completed", font: .systemFont(ofSize: 14.0))
		        }
		    }
		}

3) Request data

All possible data requests are showed in the class interface source file:

		public protocol DIoTCommandInterfaceBluetoothServiceProtocol: BluetoothServiceProtocol {
		    func fetchFeatures()
		    func fetchChannels()
		    func fetchRates()
		    func fetchFeature(code: DIoTFeatureCode)
		    func fetchChannel(channel: Int)
		    func fetchRate(channel: Int)
		    func notifyFeatures(enable: Bool)
		    func notifyChannels(enable: Bool)
		    func notifyRates(enable: Bool)

		    func setFeature(feature: DIoTFeatureData)
		    func cleanFeature(code: DIoTFeatureCode)
		    func cleanFeatures()
		    func setChannel(channel: Int, code: DIoTFeatureCode)
		    func cleanChannel(channel: Int)
		    func cleanChannels()
		    func setRate(channel: Int, rate: UInt32)
		    func cleanRate(channel: Int)
		    func cleanRates()
		    
		    func subscribe(subscriber: DIoTCommandInterfaceBluetoothServiceDelegate)
		    func unsubscribe(subscriber: DIoTCommandInterfaceBluetoothServiceDelegate)
		}

For an example:

		device.commandInterfaceService?.fetchFeature(code: feature.getFeatureCode())
		device.commandInterfaceService?.cleanFeature(code: feature.getFeatureCode())
		device.commandInterfaceService?.setChannel(channel: int, code: feature.getFeatureCode())
		device.commandInterfaceService?.fetchFeatures()
		...

A data response will be received in the delegate which was set up by subscribe function previously.

4) Unsubscribe from data events

   		device.commandInterfaceService?.unsubscribe(subscriber: self)
