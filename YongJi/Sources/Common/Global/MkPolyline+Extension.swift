//
//  MkPolyline+Extension.swift
//  YongJiBus
//
//  Created by 김도경 on 2/10/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import MapKit

extension MKPolyline {
    func coordinates() -> [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
