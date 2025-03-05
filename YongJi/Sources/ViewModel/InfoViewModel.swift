//
//  InfoViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 3/20/24.
//

import Foundation
import MapKit
import CoreLocation


//MARK: WORKING FOR UPDATE

class InfoViewModel : ObservableObject {
    @Published var mapPoints: [MapPoint] = []
    
    init(){
        mapPoints = _myongjiPoint
    }
    
    let _myongjiPoint : [MapPoint] = [
        MapPoint(name: "버스관리사무소", points: CLLocationCoordinate2D(latitude: 37.22420, longitude: 127.18766), direction: .upward),
        MapPoint(name: "이마트", points: CLLocationCoordinate2D(latitude: 37.23052, longitude: 127.18816), direction: .upward),
        MapPoint(name: "진입로(노브랜드 앞)", points: CLLocationCoordinate2D(latitude: 37.23403, longitude: 127.18877), direction: .upward),
        MapPoint(name: "경전철 명지대역", points: CLLocationCoordinate2D(latitude: 37.23842, longitude: 127.18965), direction: .upward),
        MapPoint(name: "진입로(역북동 주민센터)", points: CLLocationCoordinate2D(latitude: 37.23397, longitude: 127.18865), direction: .downward),
        MapPoint(name: "이마트(투썸 앞)", points: CLLocationCoordinate2D(latitude: 37.23140, longitude: 127.18818), direction: .downward),
        MapPoint(name: "명진당", points: CLLocationCoordinate2D(latitude: 37.22235, longitude: 127.18890), direction: .downward),
        MapPoint(name: "제3공학관", points: CLLocationCoordinate2D(latitude: 37.21949, longitude: 127.18389), direction: .downward),
        MapPoint(name: "함박관", points: CLLocationCoordinate2D(latitude: 37.22162, longitude: 127.18841), direction: .downward),
        MapPoint(name: "창조관", points: CLLocationCoordinate2D(latitude: 37.22280, longitude: 127.18855), direction: .downward),
        MapPoint(name: "버스관리사무소", points: CLLocationCoordinate2D(latitude: 37.22420, longitude: 127.18766), direction: .downward)
    ]
    
    
   var _cityPoint : [MapPoint] = [
         MapPoint(name: "버스관리사무소", points: CLLocationCoordinate2D(latitude: 37.22420, longitude: 127.18766), direction: .upward),
        MapPoint(name: "이마트", points: CLLocationCoordinate2D(latitude: 37.23052, longitude: 127.18816), direction: .upward),
        MapPoint(name: "진입로(노브랜드 앞)", points: CLLocationCoordinate2D(latitude: 37.23403, longitude: 127.18877), direction: .upward),
        MapPoint(name: "동부경찰서", points: CLLocationCoordinate2D(latitude: 37.23477, longitude: 127.19821), direction: .upward),
        MapPoint(name: "용인CGV", points: CLLocationCoordinate2D(latitude: 37.23527, longitude: 127.20567), direction: .upward),
         MapPoint(name: "중앙공영주차장", points: CLLocationCoordinate2D(latitude: 37.23412, longitude: 127.20890), direction: .downward),
        MapPoint(name: "진입로(역북동 주민센터)", points: CLLocationCoordinate2D(latitude: 37.23397, longitude: 127.18865), direction: .downward),
        MapPoint(name: "이마트(투썸 앞)", points: CLLocationCoordinate2D(latitude: 37.23140, longitude: 127.18818), direction: .downward),
        MapPoint(name: "제1공학관", points: CLLocationCoordinate2D(latitude: 37.22274, longitude: 127.18677), direction: .downward),
        MapPoint(name: "제3공학관", points: CLLocationCoordinate2D(latitude: 37.21949, longitude: 127.18389), direction: .downward),
        MapPoint(name: "함박관", points: CLLocationCoordinate2D(latitude: 37.22162, longitude: 127.18841), direction: .downward),
        MapPoint(name: "창조관", points: CLLocationCoordinate2D(latitude: 37.22280, longitude: 127.18855), direction: .downward),
        MapPoint(name: "버스관리사무소", points: CLLocationCoordinate2D(latitude: 37.22420, longitude: 127.18766), direction: .downward)
    ]

    var _holidayPoint : [MapPoint] = [
        MapPoint(name: "생활관(명현관)", points: CLLocationCoordinate2D(latitude: 37.22300, longitude: 127.18199), direction: .upward),
        MapPoint(name: "함박관", points: CLLocationCoordinate2D(latitude: 37.22162, longitude: 127.18841), direction: .upward),
        MapPoint(name: "정문", points: CLLocationCoordinate2D(latitude: 37.22418, longitude: 127.18788), direction: .upward),
        MapPoint(name: "이마트", points: CLLocationCoordinate2D(latitude: 37.23052, longitude: 127.18816), direction: .upward),
        MapPoint(name: "진입로(노브랜드 앞)", points: CLLocationCoordinate2D(latitude: 37.23403, longitude: 127.18877), direction: .upward),
        MapPoint(name: "동부경찰서", points: CLLocationCoordinate2D(latitude: 37.23477, longitude: 127.19821), direction: .upward),
        MapPoint(name: "용인CGV", points: CLLocationCoordinate2D(latitude: 37.23527, longitude: 127.20567), direction: .upward),
        MapPoint(name: "중앙공영주차장", points: CLLocationCoordinate2D(latitude: 37.23412, longitude: 127.20890), direction: .downward),
        MapPoint(name: "경전철 명지대역", points: CLLocationCoordinate2D(latitude: 37.23842, longitude: 127.18965), direction: .downward),
        MapPoint(name: "진입로(역북동 주민센터)", points: CLLocationCoordinate2D(latitude: 37.23397, longitude: 127.18865), direction: .downward),
        MapPoint(name: "이마트(투썸 앞)", points: CLLocationCoordinate2D(latitude: 37.23140, longitude: 127.18818), direction: .downward),
        MapPoint(name: "제1공학관", points: CLLocationCoordinate2D(latitude: 37.22274, longitude: 127.18677), direction: .downward),
        MapPoint(name: "생활관(명현관)", points: CLLocationCoordinate2D(latitude: 37.22300, longitude: 127.18199), direction: .downward)
    ]

    var waypoints: [CLLocationCoordinate2D] {
        mapPoints.map { $0.points }
    }
    
}

extension InfoViewModel {
    public func getUpwardRoute() -> [MapPoint]{
        return mapPoints.filter{ $0.direction == .upward}
    }
    
    public func getDownwardRoute() -> [MapPoint] {
        return mapPoints.filter{ $0.direction == .downward}
    }
    
    public func switchToMyongjiRoute() {
        mapPoints = _myongjiPoint
    }
    
    public func switchToCityRoute() {
        mapPoints = _cityPoint
    }
    
    public func switchToHolidayRoute(){
        mapPoints = _holidayPoint
    }
}
