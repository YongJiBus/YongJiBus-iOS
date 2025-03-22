//
//  GiheungInfoViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 3/4/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation


//MARK: WORKING FOR UPDATE

class GiheungInfoViewModel : ObservableObject {
    @Published var mapPoints: [MapPoint] = [
        MapPoint(name: "버스관리사무소", points: CLLocationCoordinate2D(latitude: 37.22420, longitude: 127.18766), direction: .upward),
        MapPoint(name: "기흥역 5번 출구", points: CLLocationCoordinate2D(latitude: 37.27464, longitude: 127.11580), direction: .upward)
    ]
    
    var waypoints: [CLLocationCoordinate2D] {
        mapPoints.map { $0.points }
    }
    
}
