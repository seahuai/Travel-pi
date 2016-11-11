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
    fileprivate var nearDestination: [Destination] = [Destination]()
    fileprivate var hotDestination: [Destination] = [Destination]()
    fileprivate var otherDestination: [Destination] = [Destination]()
    
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
