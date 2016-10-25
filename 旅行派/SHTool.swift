//
//  SHTool.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/24.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit

//class SHTool: NSObject {
//    
//    static let sharedInstance = SHTool()
//
//}
//
////MARK:游记相关
//extension SHTool{
//    
//    func travelAlbum(){
//        var resultDict: [String: AnyObject] = [String: AnyObject]()
//        
//        NetWorkTool.sharedInstance.getWeekChoice { (error, result) in
//            if error != nil{print(error); return}
//            if let result = result{
//                print("getResult")
//               resultDict = result
//            }
//        }
//       
//        let album = TravelAlbum(dict: resultDict)
//    }
//    
//    
//    class func travelNotes() -> [TravelNote]{
//        var notes: [TravelNote] = [TravelNote]()
//        NetWorkTool.sharedInstance.getTravelNotes { (error, result) in
//            if error != nil{print(error); return}
//            if let result = result{
//                for dict in result{
//                    let note = TravelNote(dict: dict["activity"] as! [String: AnyObject])
//                    notes.append(note)
//                }
//            }
//        }
//        return notes
//    }
//    
//    class func travelNotes(district_id:Int) -> [TravelNote]{
//        var notes: [TravelNote] = [TravelNote]()
//        NetWorkTool.sharedInstance.getTravelNotes(district_id: district_id) { (error, result) in
//            if error != nil{print(error); return}
//            if let result = result{
//                for dict in result{
//                    let note = TravelNote(dict: dict)
//                    notes.append(note)
//                }
//            }
//        }
//        
//        return notes
//        
//    }
//    
//}
//
//
////MARK:景点相关
//extension SHTool{
//    
//    class func nearbyDestinations(lat:Double, lng: Double) -> [Destination]{
//        var destinations: [Destination] = [Destination]()
//        NetWorkTool.sharedInstance.getNearbyDestination(lat: lat, lng: lng) { (error, result) in
//            if error != nil{print(error); return}
//            if let result = result{
//                for dict in result{
//                    let destination = Destination(dict: dict)
//                    destinations.append(destination)
//                }
//            }
//        }
//        
//        return destinations
//    }
//    
//    class func hotDestinations(area: Area) -> [Destination]{
//        var destinations: [Destination] = [Destination]()
//        NetWorkTool.sharedInstance.getHotDestination(area: area) { (error, result) in
//            if error != nil{print(error); return}
//            if let result = result{
//                for dict in result{
//                    let destination = Destination(dict: dict)
//                    destinations.append(destination)
//                }
//            }
//        }
//        
//        return destinations
//    }
//    
//    
//}
//
//
//
//
//
//




