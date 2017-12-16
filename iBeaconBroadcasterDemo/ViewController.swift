//
//  ViewController.swift
//  iBeaconBroadcasterDemo
//
//  Created by cowbjt on 2017/12/16.
//  Copyright © 2017年 cowbjt. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

let defaultUuid = "594650A2-8621-401F-B5DE-6EB3EE398170"
let beaconId = "beacon.9487"

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var btn: UIButton!

    private let peripheralManager = CBPeripheralManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnClick(_ sender: Any) {
        if btn.title(for: .normal) == "Stop" {
            stopBroadcast()
            btn.setTitle("Start", for: .normal)
            return
        }

        startBroadcast()
        btn.setTitle("Stop", for: .normal)
    }
}

private extension ViewController {
    func startBroadcast() {
        guard let beaconUuid = UUID(uuidString: defaultUuid) else {
            print("Error uuid")
            return
        }

        let major: CLBeaconMajorValue = 94
        let minor: CLBeaconMinorValue = 87
        let beaconID = "tw.cowbjt.beacon"

        let region = CLBeaconRegion(proximityUUID: beaconUuid, major: major, minor: minor, identifier: beaconID)
        print("broadcast info: \(region)")

        let peripheralData = region.peripheralData(withMeasuredPower: nil)
        print("broadcast data: \(peripheralData)")

        peripheralManager.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
    }

    func stopBroadcast() {
        peripheralManager.stopAdvertising()
    }
}

// MARK: CBPeripheralManagerDelegate

extension ViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {

        label.text = "Bluetooth OFF"

        switch peripheral.state {
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            print("poweredOn")
            label.text = "Bluetooth OK"
        case .resetting:
            print("resetting")
        case .unauthorized:
            print("unauthorized")
        case .unsupported:
            print("unsupported")
        case .unknown:
            print("unknown")
        }
    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let err = error {
            print("\(err.localizedDescription)")
            return
        }

        print("Start to broadcast")
    }
}
