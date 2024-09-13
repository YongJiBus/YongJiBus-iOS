//
//  InfoViewModel.swift
//  YongJiBus
//
//  Created by 김도경 on 3/20/24.
//

import Foundation
import MapKit


//MARK: WORKING FOR UPDATE

class InfoViewModel : ObservableObject {
    var mapPoints : [MapPoint] = [
        MapPoint(name: "버스사무소", points: CLLocationCoordinate2D(latitude: 37.22420, longitude: 127.18766)),
        MapPoint(name: "상공회의소", points: CLLocationCoordinate2D(latitude: 37.23038, longitude: 127.18813))
    ]
}
