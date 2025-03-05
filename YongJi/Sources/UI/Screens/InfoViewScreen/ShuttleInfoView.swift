//
//  ShuttleInfoView.swift
//  YongJiBus
//
//  Created by 김도경 on 3/7/24.
//

import SwiftUI
import MapKit

struct ShuttleInfoView: View {
    
    @ObservedObject var viewModel = InfoViewModel()
    @EnvironmentObject var appViewModel : AppViewModel
    
    //@State private var routePolyline: MKPolyline?
    
    @State private var mapItem : MKMapItem?
    
    @State private var cameraPosition : MapCameraPosition = .automatic
    
    @State private var selectedTab: RouteTab = .myongji

    enum RouteTab {
        case myongji, city, holiday
        
        var title: String {
            switch self {
            case .myongji:
                "명지대역 셔틀"
            case .city:
                "시내 셔틀"
            case .holiday:
                "주말 시내 셔틀"
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
                map

            HStack {
                Text("운행구간")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.primary)
                
                Spacer()
                
                Button(action: {
                    resetMapPosition()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.counterclockwise")
                        Text("지도 초기화")
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color("RowColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            
            // 탭 인터페이스
            if !appViewModel.isHoliday {
                HStack(spacing: 0) {
                    ForEach([RouteTab.myongji, .city], id: \.self) { tab in
                        Button(action: {
                            withAnimation {
                                if tab == .myongji {
                                    viewModel.switchToMyongjiRoute()
                                } else {
                                    viewModel.switchToCityRoute()
                                }
                                selectedTab = tab
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text(tab.title)
                                    .font(.subheadline)
                                    .fontWeight(selectedTab == tab ? .bold : .regular)
                                
                                Rectangle()
                                    .frame(height: 3)
                                    .foregroundColor(selectedTab == tab ? Color("RowNumColor") : Color.clear)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
            }

            ScrollView {
                if appViewModel.isHoliday {
                    holidayRouteListView
                } else {
                    routeListView
                }
            }
        }
        .onAppear {
            if appViewModel.isHoliday {
                viewModel.switchToHolidayRoute()
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
    
    var holidayRouteListView : some View {
        VStack(alignment: .leading) {
            Text("시내 방향")
                .fontWeight(.bold)
            routeRow(mapPoints: viewModel.getUpwardRoute())
            Text("학교 방향")
                .fontWeight(.bold)
            routeRow(mapPoints: viewModel.getDownwardRoute())
        }
        .padding(.horizontal)
    }
    
    var routeListView : some View {
        if selectedTab == .myongji {
            VStack(alignment: .leading) {
                Text("명지대 방향")
                    .fontWeight(.bold)
                routeRow(mapPoints: viewModel.getUpwardRoute())
                Text("학교 방향")
                    .fontWeight(.bold)
                routeRow(mapPoints: viewModel.getDownwardRoute())
            }
            .padding(.horizontal)
        } else {
            VStack(alignment: .leading) {
                Text("시내 방향")
                    .fontWeight(.bold)
                routeRow(mapPoints: viewModel.getUpwardRoute())
                Text("학교 방향")
                    .fontWeight(.bold)
                routeRow(mapPoints: viewModel.getDownwardRoute())
            }
            .padding(.horizontal)
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
        }
        .frame(height: UIScreen.main.bounds.height / 2.3)
        .mapStyle(.standard)
        .mapControls {
            MapUserLocationButton()
        }
        .onChange(of: mapItem) {
            self.cameraPosition = .item(mapItem!)
        }
    }
    
    private func resetMapPosition() {
        self.cameraPosition = .automatic
    }
}

///MARK : 추후 도입
//extension ShuttleInfoView {
//    private func getDirections() async {
//        let coordinates: [CLLocationCoordinate2D] = viewModel.mapPoints.map{ $0.points }
//        
//        guard coordinates.count >= 2 else { return }
//        
//        var routes: [MKRoute] = []
//        
//        var newCoors : [CLLocationCoordinate2D] = []
//        
//        
//        for i in 0..<coordinates.count - 1{
//            let sourcePlace = MKPlacemark(coordinate: coordinates[i])
//            let destinationPlace = MKPlacemark(coordinate: coordinates[i+1])
//            
//            let request = MKDirections.Request()
//            request.source = MKMapItem(placemark: sourcePlace)
//            request.destination = MKMapItem(placemark: destinationPlace)
//            request.transportType = .walking
//            
//            let directions = MKDirections(request: request)
//            
//            do {
//                let response = try await directions.calculate()
//                guard let route = response.routes.first else { return }
//                routes.append(route)
//                
//                let coords = route.polyline.coordinates()
//                newCoors.append(contentsOf: coords)
//                
//
//            } catch {
//                print("Error calculating directions: \(error.localizedDescription)")
//            }
//        }
//        
//        self.routePolyline = MKPolyline(coordinates: newCoors, count: newCoors.count)
//    }
//}

#Preview {
    ShuttleInfoView()
        .environmentObject(AppViewModel())
}
