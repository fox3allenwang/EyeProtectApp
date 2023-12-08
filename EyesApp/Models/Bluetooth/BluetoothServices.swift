//
//  BluetoothServices.swift
//  EyesApp
//
//  Created by imac-3282 on 2023/10/24.
//

import CoreBluetooth
import Foundation
import SwiftHelpers

class BluetoothServices: NSObject {
    
    static let shared = BluetoothServices()
    
    let bluelightRange = 60
    
    var central: CBCentralManager?
    var peripheral: CBPeripheralManager?
    
    weak var delegate: BluetoothServicesDelegate?
    
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
    
    func writeValue(type: CBCharacteristicWriteType, data: Data) {
        guard let peripheral = Lamp.peripheral,
              let characteristic = Lamp.characteristic else {
            return
        }
        for _ in 0 ... 19 {
            peripheral.writeValue(data, for: characteristic, type: type)
            Thread.sleep(forTimeInterval: 0.001)
        }
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
        if peripheral.name.isEqual(to: "BlueLight") {
            Bluelight.peripheral = peripheral
        }
        if peripheral.name.isEqual(to: "Lamp") {
            Lamp.peripheral = peripheral
        }
    }
    
    /// 連接裝置
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
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
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print(characteristic)
                if characteristic.uuid.isEqual(CBUUID(string: "FFE1")) {
                    if peripheral.isEqual(Bluelight.peripheral)  {
                        Bluelight.characteristic = characteristic
                        peripheral.readValue(for: characteristic)
                        peripheral.setNotifyValue(true, for: characteristic)
                    }
                    if peripheral.isEqual(Lamp.peripheral)  {
                        Lamp.characteristic = characteristic
                        peripheral.readValue(for: characteristic)
                        peripheral.setNotifyValue(true, for: characteristic)
                    }
                }
            }
        }
    }
    
    /// 特徵值變更
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        guard characteristic.isEqual(Bluelight.characteristic),
              let characteristicValue = characteristic.value,
              let ascii = String(data: characteristicValue, encoding: .utf8) else {
            return
        }
        let characteristicAscii = Character(ascii)
        let value = Double(characteristicAscii.asciiValue!)
        let finalValue: Double = 100 - (value - 60) * 1.5
        
        delegate?.getBLEPeripheralValue(value: Int(finalValue))
    }
}

// MARK: - BluetoothServicesDelegate

protocol BluetoothServicesDelegate: NSObjectProtocol {
    
    func getBLEPeripheralValue(value: Int)
}