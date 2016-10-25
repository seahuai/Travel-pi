//
//  LocationTool.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/25.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import CoreLocation

class LocationTool: NSObject {

//    var location: CLLocation?
    var isUpdate:Bool = true{
        didSet{
            if !isUpdate{
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    fileprivate var callBack: (_ location: CLLocation) -> ()
    
    init(callBack: @escaping (_ location: CLLocation) -> ()) {
        self.callBack = callBack
        super.init()
        locationManager.startUpdatingLocation()
    }
    
    fileprivate lazy var locationManager: CLLocationManager = {
        let locationManger = CLLocationManager()
        locationManger.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        return locationManger
    }()
    
}

extension LocationTool: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last{
            callBack(location)
            print(location)
        }
        
        
    }
}
