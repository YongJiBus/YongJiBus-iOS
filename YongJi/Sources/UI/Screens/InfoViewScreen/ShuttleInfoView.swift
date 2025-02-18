//
//  ShuttleInfoView.swift
//  YongJiBus
//
//  Created by 김도경 on 3/7/24.
//

import SwiftUI
import MapKit


//MARK: WORKING FOR UPDATE

struct ShuttleInfoView: View {
    
    @ObservedObject var viewModel = InfoViewModel()
    
    @State private var routePolyline: MKPolyline?
    
    @State private var mapItem : MKMapItem?
    
    @State private var cameraPosition : MapCameraPosition = .automatic

    var body: some View {
        VStack(alignment: .leading,spacing: 20) {
                map

            Text("운행구간")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.primary)
                .padding(.leading)
            ScrollView {
                VStack(alignment: .leading) {
                    Text("명지대 방향")
                        .fontWeight(.bold)
                    routeRow(mapPoints: viewModel.getUpwardRoute())
                    Text("학교 방향")
                        .fontWeight(.bold)
                    routeRow(mapPoints: viewModel.getDownwardRoute())
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func routeRow(mapPoints : [MapPoint]) -> some View {
        ForEach(Array(mapPoints.enumerated()), id: \.element.id) { index, mapPoint in
            VStack(spacing: 4) {
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(Color("RowNumColor"))
                        .shadow(radius: 1)
                        .padding(.leading, 6)
                    Text(mapPoint.getName())
                        .font(.body)
                        .foregroundStyle(Color.primary.opacity(0.9))
                    Spacer()
                }
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color("RowColor").opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .onTapGesture {
                    self.mapItem = MKMapItem(placemark: MKPlacemark(coordinate: mapPoint.points))
                }
                
                if index < mapPoints.count - 1 {
                    ArrowShape()
                        .frame(width: 15, height: 20)
                        .foregroundStyle(Color("RowColor").opacity(0.5))
                        .padding(.top, -18)
                }
            }
        }
    }
    
    // 화살표 도형 정의
    struct ArrowShape: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            // 화살표 기둥
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height/3))
            
            // 화살표 머리
            path.move(to: CGPoint(x: rect.midX - rect.width/2, y: rect.maxY - rect.height/3))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX + rect.width/2, y: rect.maxY - rect.height/3))
            
            return path
        }
    }
    
    var map : some View {
        Map(position: $cameraPosition){
            ForEach(viewModel.mapPoints.filter {$0.direction != .empty}){ mapPoint in
                Annotation(mapPoint.name, coordinate: mapPoint.points) {
                    Image(systemName: "bus.fill")
                        .resizable()
                        .frame(width: 9, height: 9)
                        .padding(3)
                        .foregroundStyle(Color("RowNumColor"))
                        .background(.white)
                        .clipShape(Circle())
                }
            }
            if let polyline = routePolyline {
                MapPolyline(polyline)
                    .stroke(Color.blue, lineWidth: 3)
            }
        }
        .frame(height: UIScreen.main.bounds.height / 2)
//        .task{
//            await getDirections()
//        }
        .mapStyle(.standard)
        .mapControls {
            MapUserLocationButton()
        }
        .onChange(of: mapItem) {
            self.cameraPosition = .item(mapItem!)
        }
    }
}

extension ShuttleInfoView {
    private func getDirections() async {
        let coordinates: [CLLocationCoordinate2D] = viewModel.mapPoints.map{ $0.points }
        
        guard coordinates.count >= 2 else { return }
        
        var routes: [MKRoute] = []
        
        var newCoors : [CLLocationCoordinate2D] = []
        
        
        for i in 0..<coordinates.count - 1{
            let sourcePlace = MKPlacemark(coordinate: coordinates[i])
            let destinationPlace = MKPlacemark(coordinate: coordinates[i+1])
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: sourcePlace)
            request.destination = MKMapItem(placemark: destinationPlace)
            request.transportType = .walking
            
            let directions = MKDirections(request: request)
            
            do {
                let response = try await directions.calculate()
                guard let route = response.routes.first else { return }
                routes.append(route)
                
                let coords = route.polyline.coordinates()
                newCoors.append(contentsOf: coords)
                

            } catch {
                print("Error calculating directions: \(error.localizedDescription)")
            }
        }
        
        self.routePolyline = MKPolyline(coordinates: newCoors, count: newCoors.count)
    }
}

#Preview {
    ShuttleInfoView()
}
