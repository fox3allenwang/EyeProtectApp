//
//  BluetoothServices.swift
//  EyesApp
//
//  Created by imac-3282 on 2023/10/24.
//

import Foundation
import CoreBluetooth

class BluetoothServices: NSObject {
    
    static let shared = BluetoothServices()
    
    var central: CBCentralManager?
    var peripheral: CBPeripheralManager?
    
    ///  初始化：副線程
    private override init() {
        super.init()
        
        let queue = DispatchQueue.global()
        central = CBCentralManager(delegate: self, queue: queue)
    }
    
    /// 掃描藍芽裝置
    func startScan() {
        central?.scanForPeripherals(withServices: nil)
    }
    
    /// 停止掃描
    func stopScan() {
        central?.stopScan()
    }
    
    /// 連接藍牙週邊設備
    /// - Parameters:
    ///   - peripheral: 要連接的藍牙周邊設備
    func connectPeripheral(peripheral: CBPeripheral) {
        central?.connect(peripheral, options: nil)
    }
    
    /// 中斷與藍芽週邊設備的連接
    /// - Parameters:
    ///   - peripheral: 要中斷連接的藍牙周邊設備
    func disconnectPeripheral(peripheral: CBPeripheral) {
        central?.cancelPeripheralConnection(peripheral)
    }
}

// MARK: - CBCentralManagerDelegate

extension BluetoothServices: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            print("poweredOn")
        @unknown default:
            print("藍芽裝置未知狀態")
        }
        
        startScan()
    }
    
    /// 發現裝置
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
    }
    
    /// 連接裝置
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    
}

// MARK: - CBPeripheralDelegate

extension BluetoothServices: CBPeripheralDelegate {
    
    /// 發現服務
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                print(service)
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    /// 服務更改
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
    }
    
    /// 發現對應服務的特徵
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

    }
    
    /// 特徵值變更
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
    }
}

// MARK: - CBPeripheralManagerDelegate

extension BluetoothServices: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            print("poweredOn")
        @unknown default:
            print("藍芽裝置未知狀態")
        }
    }
}