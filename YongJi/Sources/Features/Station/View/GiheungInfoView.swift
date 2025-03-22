//
//  GiheungInfoView.swift
//  YongJiBus
//
//  Created by 김도경 on 3/4/25.
//  Copyright © 2025 yongjibus.org. All rights reserved.
//

import SwiftUI
import MapKit

struct GiheungInfoView: View {
    @State private var cameraPosition : MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.27464, longitude: 127.11580),
        span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
    ))
    private let mapPoint = MapPoint(name: "기흥역 5번 출구", points: CLLocationCoordinate2D(latitude: 37.27464, longitude: 127.11580), direction: .upward)
    
    var body: some View {
        VStack(spacing: 20) {
            map
            descriptionView
            Spacer()
        }
    }
    
    var map : some View {
        Map(position: $cameraPosition){
            Annotation(mapPoint.name, coordinate: mapPoint.points) {
                Image(systemName: "bus.fill")
                    .resizable()
                    .frame(width: 13, height: 13)
                    .padding(3)
                    .foregroundStyle(Color("RowNumColor"))
                    .background(.white)
                    .clipShape(Circle())
            }
        }
        .frame(height: UIScreen.main.bounds.height / 2.3)
        .mapStyle(.standard) 
        .mapControls {
            MapUserLocationButton()
        }
    }
    
    var descriptionView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("탑승 안내")
                .font(.title2)
                .fontWeight(.bold)
            
            // 기흥역 안내
            VStack(alignment: .leading, spacing: 5) {
                Text("기흥역")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 12) {
                    Image(systemName: "bus.fill")
                        .font(.title2)
                        .foregroundColor(Color("RowNumColor"))
                        .frame(width: 40, height: 40)
                        .background(Color("RowNumColor").opacity(0.2))
                        .clipShape(Circle())
                    
                    Text("5번 출구 앞 버스정류장에서 기다리면 됩니다")
                        .font(.body)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

            // 학교 안내
            VStack(alignment: .leading, spacing: 5) {
                Text("학교")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 12) {
                    Image(systemName: "building.columns.fill")
                        .font(.title2)
                        .foregroundColor(Color("RowNumColor"))
                        .frame(width: 40, height: 40)
                        .background(Color("RowNumColor").opacity(0.2))
                        .clipShape(Circle())
                    
                    Text("버스관리소 앞에서 줄서서 기다리면 됩니다")
                        .font(.body)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding(.top, 10)
        .padding(.horizontal)
    }
}

#Preview {
    GiheungInfoView()
}
