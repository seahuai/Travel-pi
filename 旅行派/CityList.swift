//
//  CityList.swift
//  旅行派
//
//  Created by 张思槐 on 16/11/11.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

class CityList: NSObject {
    static let sharedInstance = CityList()
    var nearDestination: [Destination] = [Destination]()
    var chinaDestination: [Destination] = [Destination]()
    var hotDestination: [Destination] = [Destination]()
    var otherDestination: [Destination] = [Destination]()
    
    func addObject(china: [Destination]){
        chinaDestination = china
        print("china:\(chinaDestination.count)")
    }
    
    func addObject(hot: [Destination]){
        hotDestination = hot
        print("hot:\(hotDestination.count)")
    }
    
    func addObject(near: [Destination]){
        nearDestination = near
        print("near:\(nearDestination.count)")
    }
    
    func addObject(other: [Destination]){
        otherDestination = other
        print("other:\(otherDestination.count)")
    }
}
