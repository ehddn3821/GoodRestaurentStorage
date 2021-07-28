//
//  MainViewController.swift
//  GoodRestaurantStorage
//
//  Created by dwKang on 2021/07/26.
//

import UIKit
import NMapsMap

class MainViewController: UIViewController {
    
    let mapView = NMFMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = view.frame
        view.addSubview(mapView)
        
        setCamera()
        setMarker()
    }
    
    // 위치 띄우기
    func setCamera() {
        let camPosition =  NMGLatLng(lat: 37.506685278292885, lng: 127.05381755571074)
        let cameraUpdate = NMFCameraUpdate(scrollTo: camPosition, zoomTo: 19.0)
        mapView.moveCamera(cameraUpdate)
    }
    
    // 마커 띄우기
    func setMarker() {
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: 37.507051989968026, lng: 127.05361037468846)
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor.red
        marker.width = 30
        marker.height = 40
        marker.mapView = mapView
        
        // 정보창 생성
        let infoWindow = NMFInfoWindow()
        let dataSource = NMFInfoWindowDefaultTextSource.data()
        dataSource.title = "APPG"
        infoWindow.dataSource = dataSource
        
        // 마커에 달아주기
        infoWindow.open(with: marker)
    }
}
