//
//  Route.swift
//  旅行派
//
//  Created by 张思槐 on 17/2/13.
//  Copyright © 2017年 zhangsihuai. All rights reserved.
//

import UIKit

class Route: NSObject {
    
    static let shared: Route = Route()
    var unreadNum: Int = 0
    var routes: [RouteModel] = [RouteModel]()
    var routesIndex: [Int] = [Int]()
    func addRoute(route: RouteModel){
        routes.append(route)
    }
    
    func cellHeight(index: Int) -> CGFloat{
        return routes[index].cellHeight
    }
}
