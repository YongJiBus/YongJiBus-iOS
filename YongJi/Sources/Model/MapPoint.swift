import Foundation
import CoreLocation

struct MapPoint: Identifiable {
    let id = UUID()
    let name: String
    let points: CLLocationCoordinate2D
    let direction: Direction
    
    enum Direction {
        case upward 
        case downward
        case empty
    }
}

extension MapPoint {
    public func getName() -> String {
        switch direction {
        case .upward:
            return name
        case .downward:
            return name
        case .empty:
            return ""
        }
        
    }
}
