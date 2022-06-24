# DIoT Android SDK

Welcome to DIoT Android SDK Demo Application page!
DIoT is a platform for different IoT devices provided by Daatrics LTD company.
Current SDK is released for both iOS and Android systems and and you are free to use in to implement connectivity between your phone and device via BLE.

## Initialization
The initialization process contains several steps:
1) Add SDK dependency to your app **build.gradle** module:

       dependencies {
           ...
           implementation 'com.github.MultiToolDeveloper:DIoT-SDK-Android:1.0.0'  
           ...
       }

2) Add jitpack.io repo to your root **settings.gradle** module:

       repositories {
           ...
           maven { url 'https://jitpack.io' }
           ...
       }

3) Add Bluetooth and Location permissions in **AndroidManifest.xml**

       <manifest
           ...
           <uses-permission android:name="android.permission.BLUETOOTH" />
           <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
           <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
           <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
           <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
           <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
           ...
           <application
               ...
           </application>
           ...
       </manifest>

4) Initialize SDK in Application singleton:

       class App : Application() {
           override fun onCreate() {
               super.onCreate()
               //do init the iot sdk
               DIoT.initialize(this)
           }
       }

## Scanning
The main module of the Bluetooth SDK part is DIoTBluetoothManager. This class is used as an additional level after the system classes BluetoothManager and BluetoothAdapter. Its tasks include: checking the status of the system BT adapter, scanning BLE devices, forwarding status events to subscribers of the service.

		interface DIoTBluetoothManagerProtocol {
			val context: Context
			val coroutineContext: CoroutineContext
			fun subscribe(subscriber: DIoTBluetoothManagerDelegate, subscriptionType: DIoTBluetoothManagerSubscriptionType)
			fun unsubscribe(subscriber: DIoTBluetoothManagerDelegate, subscriptionType: DIoTBluetoothManagerSubscriptionType)
			fun fetchBluetoothPowerState()
			fun startScan(service: UUID?, name: String?)
			fun stopScan()
		}
To get the scan result, you need to subscribe to DIoTBluetoothManager events for example:

		DIoT.bluetoothManager?.subscribe(this, DIoTBluetoothManagerSubscriptionType.scan)
		DIoT.bluetoothManager?.startScan(null, null)
		DIoT.bluetoothManager?.stopScan()

You will receive a callback to your delegate implementation:

		interface DIoTBluetoothManagerScanningDelegate: DIoTBluetoothManagerDelegate {
			fun didDiscoverDevice(manager: DIoTBluetoothManagerProtocol, device: DIoTBluetoothDevice, rssi: Int)
			fun didReceiveScanningError(manager: DIoTBluetoothManagerProtocol, error: DIoTBluetoothManagerScanningError)
		}

To get information about the status of the BT hardware module, you need to subscribe to DIoTBluetoothManager events, for example:

		DIoT.bluetoothManager?.subscribe(this, DIoTBluetoothManagerSubscriptionType.state)
		DIoT.bluetoothManager?.fetchBluetoothPowerState()

After the request next delegate will be triggered:

		interface DIoTBluetoothManagerStateDelegate: DIoTBluetoothManagerDelegate {
			fun bluetoothManagerEnabledBluetooth(manager: DIoTBluetoothManagerProtocol)
			fun bluetoothManagerDisabledBluetooth(manager: DIoTBluetoothManagerProtocol)
			fun bluetoothManagerNotAllowedBluetooth(manager: DIoTBluetoothManagerProtocol)
			fun bluetoothManagerNoBLESupport(manager: DIoTBluetoothManagerProtocol)
		}

## Connection

As a result of the scan, one or more DIoT devices will be returned, this class contains connection functions, a list of services and signal strength determination, as well as information about the device (name, id, etc.):

		interface DIoTBluetoothDeviceProtocol {
			var name: String
			var deviceId: DeviceId
			var address: String

			var connectionService: DIoTBluetoothDeviceConnectionServiceProtocol
			var deviceInformationService: GeneralDeviceInformationBluetoothServiceProtocol?
			var batteryService: GeneralBatteryBluetoothServiceProtocol?
			var commandInterfaceService: DIoTCommandInterfaceBluetoothServiceProtocol?
			var dataInterfaceService: (DIoTDataInterfaceBluetoothServiceProtocol)?
			var deviceIdentifierService: DIoTDeviceIdBluetoothServiceProtocol?
			var debugService: DIoTDebugBluetoothServiceProtocol?
		}

To connect to the device, you must use the connect method in the ConnectionService service of the DIoTBluetoothDevice class:

		var device: DIoTBluetoothDevice? = null
		device?.connectionService?.subscribe(this)
		device?.connectionService?.connect()

You have to use the connectionService.subscribe() function and implement a delegate interface inside you class to receive connection state callbacks:

		interface DIoTBluetoothDeviceConnectionServiceDelegate {
			fun didConnect(service: DIoTBluetoothDeviceConnectionServiceProtocol)
			fun didDisconnect(service: DIoTBluetoothDeviceConnectionServiceProtocol)
			fun didFailToConnect(service: DIoTBluetoothDeviceConnectionServiceProtocol)
			fun didReceiveError(service: DIoTBluetoothDeviceConnectionServiceProtocol, error: DIoTBluetoothDeviceConnectionError)
			fun didReceiveRSSI(service: DIoTBluetoothDeviceConnectionServiceProtocol, rssi: Int)
		}

## Data exchange
The data exchange is carried out through services designated in the DIoTBluetoothDevice class.

		interface DIoTBluetoothDeviceProtocol {
			var name: String
			var deviceId: DeviceId
			var address: String

			var connectionService: DIoTBluetoothDeviceConnectionServiceProtocol
			var deviceInformationService: GeneralDeviceInformationBluetoothServiceProtocol?
			var batteryService: GeneralBatteryBluetoothServiceProtocol?
			var commandInterfaceService: DIoTCommandInterfaceBluetoothServiceProtocol?
			var dataInterfaceService: (DIoTDataInterfaceBluetoothServiceProtocol)?
			var deviceIdentifierService: DIoTDeviceIdBluetoothServiceProtocol?
			var debugService: DIoTDebugBluetoothServiceProtocol?
		}
Each service contains methods related to the data involved in this service, as well as methods and corresponding class delegates that the signatories must correspond to. You can subscribe  and unsubscribe on events with:

		fun subscribe(subscriber:)
		fun unsubscribe(subscriber:)

## Data request example

Let's try to get data from the DIoT Command Interface service.

1) Subscribe to receive data from the DIoT Command Interface service

   		device?.commandInterfaceService?.subscribe(this)
2) Implement delegate methods:

		//DIoTCommandInterfaceBluetoothServiceDelegate
		override fun didReceiveCommandFeatures(
			service: DIoTCommandInterfaceBluetoothServiceProtocol,
			dataFeatures: ArrayList<DIoTFeatureData>
		) {
		}

		override fun didReceiveCommandChannels(
			service: DIoTCommandInterfaceBluetoothServiceProtocol,
			dataChannels: ArrayList<DIoTChannelData>
		) {
		}

		override fun didReceiveCommandRate(
			service: DIoTCommandInterfaceBluetoothServiceProtocol,
			dataRates: ArrayList<DIoTRateData>
		) {
		}

		override fun didReceiveError(
			service: DIoTCommandInterfaceBluetoothServiceProtocol,
			error: DIoTCommandInterfaceBluetoothServiceError
		) {
		}

		override fun didWriteCommandFeatures(service: DIoTCommandInterfaceBluetoothServiceProtocol) {
		}

		override fun didWriteCommandChannels(service: DIoTCommandInterfaceBluetoothServiceProtocol) {
		}

		override fun didWriteCommandRate(service: DIoTCommandInterfaceBluetoothServiceProtocol) {
		}

		override fun subscriptionFeaturesStatusChange(
			service: DIoTCommandInterfaceBluetoothServiceProtocol,
			enabled: Boolean
		) {
		}

		override fun subscriptionChannelsStatusChange(
			service: DIoTCommandInterfaceBluetoothServiceProtocol,
			enabled: Boolean

		) {
		}

		override fun subscriptionRatesStatusChange(
			service: DIoTCommandInterfaceBluetoothServiceProtocol,
			enabled: Boolean
		) {
		}

3) Request data

All possible data requests are showed in class interface source file:

		interface DIoTCommandInterfaceBluetoothServiceProtocol {
			fun fetchFeatures()
			fun fetchChannels()
			fun fetchRates()
			fun fetchFeature(code: DIoTFeatureCode)
			fun fetchChannel(channel: Int)
			fun fetchRate(channel: Int)
			fun notifyFeatures(enable: Boolean)
			fun notifyChannels(enable: Boolean)
			fun notifyRates(enable: Boolean)

			fun setFeature(feature: DIoTFeatureData)
			fun cleanFeature(code: DIoTFeatureCode)
			fun cleanFeatures()
			fun setChannel(channel: Int, code: DIoTFeatureCode)
			fun cleanChannel(channel: Int)
			fun cleanChannels()
			fun setRate(channel: Int, rate: Int)
			fun cleanRate(channel: Int)
			fun cleanRates()

			fun subscribe(subscriber: DIoTCommandInterfaceBluetoothServiceDelegate)
			fun unsubscribe(subscriber: DIoTCommandInterfaceBluetoothServiceDelegate)
		}

We an use it as an example:

		device?.commandInterfaceService?.fetchFeature(featureData.getFeatureCode())
		device?.commandInterfaceService?.cleanFeature(featureData.getFeatureCode())
		device?.commandInterfaceService?.setChannel(number, featureData.getFeatureCode())
		device?.commandInterfaceService?.fetchFeatures()
		...

A data response will be received in the delegate which was set up by subscribe function previously.

4) Unsubscribe from data events

   		device?.commandInterfaceService?.unsubscribe(this)
