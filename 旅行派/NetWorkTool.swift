//
//  NetWorkTool.swift
//  旅行派
//
//  Created by 张思槐 on 16/10/24.
//  Copyright © 2016年 zhangsihuai. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class NetWorkTool: NSObject {

    static let sharedInstance = NetWorkTool()
    
}

//MARK:获取每周精选游记
extension NetWorkTool{
    
    func getWeekChoice(finished: @escaping (_ error: Error?, _ result: [String: AnyObject]?) -> ()){
        Alamofire.request("http://q.chanyouji.com/api/v1/albums/92.json", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                let result = response.result.value as? [String: AnyObject]
                finished(nil, result?["data"] as? [String: AnyObject])
            case .failure:
                finished(response.result.error, nil)
            }
        }
    }
}

//MARK:获取游记
extension NetWorkTool{
    
    func getTravelNotes(finished: @escaping (_ error: Error?, _ result: [[String: AnyObject]]?) -> ()){
//        let parameters = ["page":"1","per]
        Alamofire.request("http://q.chanyouji.com/api/v1/timelines.json?interests=&page=1&per=50", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                let result = response.result.value as? [String: AnyObject]
                finished(nil, result?["data"] as? [[String: AnyObject]])
            case .failure:
                finished(response.result.error, nil)
            }
        }
    }
    
    func getTravelNotes(district_id:Int, finished: @escaping (_ error: Error?, _ result: [[String: AnyObject]]?) -> ()){
        Alamofire.request("http://q.chanyouji.com/api/v1/user_activities.json?district_id=\(district_id)&filter=&page=1&sort=", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                let result = response.result.value as! [String: AnyObject]
                let user_activities = result["data"] as! [String: AnyObject]
                finished(nil, user_activities["user_activities"] as? [[String : AnyObject]])
            case .failure:
                finished(response.result.error, nil)
            }
        }
    }
    
    
    
}

//MARK:获取热门旅游城市
extension NetWorkTool{

    func getHotDestination(area: Area,finished: @escaping (_ error: Error?, _ result: [[String: AnyObject]]?) -> ()){
        let url: String
        switch area {
        case .China:
            url = "http://q.chanyouji.com/api/v2/destinations/list.json?area=china"
        case .Asia:
            url = "http://q.chanyouji.com/api/v2/destinations/list.json?area=asia"
        case .Europe:
            url = "http://q.chanyouji.com/api/v2/destinations/list.json?area=europe"
        }
//        let parameters = ["area": _area]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                let result = response.result.value as? [String: AnyObject]
                finished(nil, result?["data"] as? [[String: AnyObject]])
            case .failure:
                finished(response.result.error, nil)
            }
        }
    }
}

//MARK:获取周边的旅游景点
extension NetWorkTool{
    //以后参数改为CLLocation类型
    func getNearbyDestination(location: CLLocation, finished: @escaping (_ error: Error?, _ result: [[String: AnyObject]]?) -> ()){
//        let parameters = ["lat": lat, "lng": lng]
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        let url = "http://q.chanyouji.com/api/v2/destinations/nearby.json?lat=\(lat)&lng=\(lng)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                let result = response.result.value as? [String: AnyObject]
                finished(nil, result?["data"] as? [[String: AnyObject]])
            case .failure:
                finished(response.result.error, nil)
            }
        }
    }
}

//MARK:获取景区详细信息
extension NetWorkTool{
    //data->destination
    func getDestinationInformation(id: Int, finished: @escaping (_ error: Error?, _ result: [String: AnyObject]?) -> ()){
        let url = "http://q.chanyouji.com/api/v3/destinations/\(id).json"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                let result = response.result.value as? [String: AnyObject]
                finished(nil, result?["data"] as? [String: AnyObject])
            case .failure:
                finished(response.result.error, nil)
            }
        }
    }
    
}

//MARK:搜索接口
extension NetWorkTool{
    
    func searchDestination(text: String, finished: @escaping (_ error: Error?, _ destination: Destination?) -> ()){
        let url = "http://q.chanyouji.com/api/v2/search.json"
        let textItem = URLQueryItem(name: "q", value: text)
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = [textItem]
        guard let urlRequest = urlComponents?.url else { finished(NSError(), nil);return }
        Alamofire.request(urlRequest, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                let result = response.result.value as? [String: AnyObject]
                let data = result?["data"] as? [String: AnyObject]
                let hitted = data?["hitted"] as? [String: AnyObject]
                if let dict = hitted?["destination"] as? [String: AnyObject]{
                    let destination = Destination(dict: dict)
                    finished(nil, destination)
                }else{
                    finished(nil, nil)
                }
            case .failure:
                finished(response.result.error, nil)
            }
        }
    }
}


