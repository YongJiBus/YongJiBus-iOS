//
//  MapPoint.swift
//  YongJiBus
//
//  Created by 김도경 on 3/20/24.
//

import Foundation
import MapKit

struct MapPoint : Identifiable {
    var id = UUID()
    var name : String
    var points : CLLocationCoordinate2D
}
