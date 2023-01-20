//
//  ViewController.swift
//  Maps
//
//  Created by Darshan Jain on 2023-01-20.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
	
	@IBOutlet weak var mapView: MKMapView!
	
	@IBOutlet weak var mapConfigStackView: UIStackView!
	
	@IBOutlet weak var zoomInBtn: UIButton!
	@IBOutlet weak var zoomOutBtn: UIButton!
	
	@IBOutlet weak var zoomStackView: UIStackView!
	@IBOutlet weak var zoomStackBottomConstraint: NSLayoutConstraint!
	
	lazy var currentLocationBtn = MKUserTrackingButton(mapView: mapView)
	lazy var compassBtn = MKCompassButton(mapView: mapView)
	
	var locationManager = CLLocationManager()
	
	var currentLocation: CLLocationCoordinate2D?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		mapView.delegate = self
		
		locationManager.delegate = self
		
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		
		mapView.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: MKMapCameraZoomDefault ,maxCenterCoordinateDistance: MKMapCameraZoomDefault), animated: true)
		
		currentLocationBtn.backgroundColor = .white
		currentLocationBtn.heightAnchor.constraint(equalTo: currentLocationBtn.widthAnchor, multiplier: 1).isActive = true
		currentLocationBtn.layer.cornerRadius = 4
		mapConfigStackView.addArrangedSubview(currentLocationBtn)
		
		mapView.showsCompass = false
		compassBtn.compassVisibility = .adaptive
		compassBtn.heightAnchor.constraint(equalTo: compassBtn.widthAnchor, multiplier: 1).isActive = true
		mapConfigStackView.addArrangedSubview(compassBtn)
		currentLocationBtn.widthAnchor.constraint(equalToConstant: compassBtn.frame.width).isActive = true
		
	}
	
	@IBAction func onZoomInPress() {
		zoomMap(byFactor: 0.25)
	}
	
	@IBAction func onZoomOutPress() {
		zoomMap(byFactor: 4)
	}
	
	@IBAction func onDimensionClick(_ sender: UIButton) {
		let camera = self.mapView.camera
		let mapCamera = MKMapCamera()
		mapCamera.centerCoordinate = camera.centerCoordinate
		mapCamera.centerCoordinateDistance = camera.centerCoordinateDistance
		if camera.pitch > 0 {
			sender.setImage(UIImage(systemName: "view.3d"), for: .normal)
			mapCamera.pitch = 0
		} else {
			sender.setImage(UIImage(systemName: "view.2d"), for: .normal)
			mapCamera.pitch = 70
		}
		self.mapView.setCamera(mapCamera, animated: true)
	}
	
}

extension MapViewController: MKMapViewDelegate{
	func zoomMap(byFactor delta: Double) {
		let camera = mapView.camera.copy() as! MKMapCamera
		camera.centerCoordinateDistance *= delta
		mapView.setCamera(camera, animated: true)
	}
	
}


extension MapViewController: CLLocationManagerDelegate{
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let userLocation = locations.first{
			if currentLocation == nil {
				let camera = mapView.camera.copy() as! MKMapCamera
				camera.centerCoordinateDistance = 5000
				camera.centerCoordinate = userLocation.coordinate
				mapView.setCamera(camera, animated: true)
			}
			currentLocation = userLocation.coordinate
		}
	}
	
}
