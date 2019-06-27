//
//  MapVC.swift
//  StreetView
//
//  Created by DerekYang on 2019/6/25.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MapVC: UIViewController {
	var m_selectLocation: CLLocationCoordinate2D?
	var detailView = DetailView()
	var detailViewlayoutbottom: NSLayoutConstraint?
	var msgLabel: UILabel!
	lazy var locationManager = CLLocationManager()
	var currentLocation: CLLocation!
	lazy var placesClient = GMSPlacesClient.shared()
	var zoomLevel: Float = 18.0
	var pinTarget: GMSMarker? = nil
	// An array to hold the list of likely places.
	var likelyPlaces: [GMSPlace] = []
	// The currently selected place.
	var selectedPlace: GMSPlace?
	
	var JSONArray = [SerachStore]()
	
	lazy var mapView = GMSMapView()
	fileprivate func getNowPlace() {
		placesClient.currentPlace{ (placeLikelihoodList, error) -> Void in
			if let error = error {
				print("Current Place error: \(error.localizedDescription)")
				return
			}
			
			if let placeLikelihoodList = placeLikelihoodList {
				let place = placeLikelihoodList.likelihoods.first?.place
				if let place = place {
					print("Current Place:" + place.name!)
				}
			}
		}
	}
	fileprivate func pin(_ info: SerachStore, index: Int, isDraggable: Bool, icon: String? = nil)  -> GMSMarker {
		let pin = CustomMarker(id: index, rank: info.rating ?? 0.0, icon: info.icon ?? "marker")
		pin.position = CLLocationCoordinate2D(latitude: info.geometry?.location.lat ?? 0, longitude: info.geometry?.location.lng ?? 0)
		pin.isDraggable = isDraggable
		pin.map = self.mapView
		pin.title = title
		pin.snippet = description
		pin.icon = GMSMarker.markerImage(with: .green)
		
		return pin
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		locationManager.requestWhenInUseAuthorization()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.distanceFilter = 50
		locationManager.startUpdatingLocation()
		locationManager.delegate = self
		
		self.view.setupFillWith(self.mapView)
		self.mapView.delegate = self
        // Do any additional setup after loading the view.
		let camera = GMSCameraPosition.camera(withLatitude: 34.23, longitude: 119.2, zoom: zoomLevel)
		self.mapView.camera = camera
//		self.mapView.mapType = .satellite
		self.mapView.isMyLocationEnabled = true
		
		self.msgLabel = UILabel(frame: CGRect.zero)
		self.msgLabel.backgroundColor = .orange
		self.msgLabel.numberOfLines = 0
		self.msgLabel.sizeToFit()
		self.view.addSubview(self.msgLabel)

		self.detailView.delegate = self
		self.view.addSubview(self.detailView)
		self.detailView.backgroundColor = .orange
		self.detailView.translatesAutoresizingMaskIntoConstraints = false
		self.detailView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
		self.detailView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
		detailViewlayoutbottom = self.detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height / 2)
		detailViewlayoutbottom?.isActive = true
		self.detailView.heightAnchor.constraint(equalToConstant: view.frame.height / 3.5).isActive = true
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	func getPhoto(_ reference: String, width: Int) {
		let urlStr = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(width)&photoreference=\(reference)&sensor=false&key=\(GOOGLE_API_KEY)"
		if let url = URL(string: urlStr) {
			self.detailView.m_imgView.downloadImage(from: url)
		}
	}
	
	func getList(_ nowLocation: CLLocation, radius: Int = 100) {
		UIView.animate(withDuration: 0.8, animations: { () in
			self.detailViewlayoutbottom?.constant = self.view.frame.height / 2
			super.view.layoutIfNeeded()
		})
		let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(nowLocation.coordinate.latitude),\(nowLocation.coordinate.longitude)&radius=\(radius)&type=restaurant&rankby=prominence&key=\(GOOGLE_API_KEY)")
		let request = URLRequest(url: url!)
		let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
			let decoder = JSONDecoder()
			
			if let data = data, let dataList = try? decoder.decode(JSONData.self, from: data) {
				for item in dataList.results{
					let index = self.JSONArray.count
					DispatchQueue.main.async {
						let _ = self.pin(item, index: index, isDraggable: false, icon: item.icon)
					}
					self.JSONArray.append(item)
				}
				DispatchQueue.main.async {
					print(self.JSONArray)
				}
			}
		}
		dataTask.resume()
	}
}

extension MapVC: GMSMapViewDelegate {
	func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
		print("Tap")
	}
	
	func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
//		print("Tap My location")
//		let acController = GMSAutocompleteViewController()
//		acController.delegate = self
//		present(acController, animated: true)
		self.mapView.clear()
		getList(self.currentLocation)
	}
	
//	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//		marker.map = nil
//		return true
//	}
	
	func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
		print("Tap location")
		let streetVC = StreetVC()
		streetVC.location = coordinate
		self.present(streetVC, animated: true)
	}
	
	func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
		
	}
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//		self.pinTarget?.map = nil
//		self.pinTarget = pin(marker.position, title: "love", isDraggable: true)
		UIView.animate(withDuration: 0.8, animations: { () in
			self.detailViewlayoutbottom?.constant = 0
			super.view.layoutIfNeeded()
		})
		self.m_selectLocation = marker.position
		if let mk = marker as? CustomMarker {
			
			
			self.detailView.star = JSONArray[mk.m_id].rating ?? 1.0
			self.detailView.title = JSONArray[mk.m_id].name ?? ""
			self.detailView.snippet = JSONArray[mk.m_id].scope ?? ""
			self.detailView.location = JSONArray[mk.m_id].vicinity ?? ""
			
			if let photos = JSONArray[mk.m_id].photos,
			let ref = photos[0].photo_reference,
			let width = photos[0].width {
				getPhoto(ref, width: Int(width))
			} else {
				DispatchQueue.main.async() {
					self.detailView.m_imgView.image = nil
				}
			}
		}
		return true
	}
	func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
	
	}
	func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
		print("Drag location")
	}
}

extension MapVC: CLLocationManagerDelegate {
	
	// Handle incoming location events.
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.currentLocation = locations.last!
		
		let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.coordinate.latitude,
											  longitude: self.currentLocation.coordinate.longitude,
											  zoom: zoomLevel)
		
		if mapView.isHidden {
			mapView.isHidden = false
			mapView.camera = camera
		} else {
			mapView.animate(to: camera)
		}
		
		listLikelyPlaces()
	}
	
	// Handle authorization for the location manager.
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .restricted:
			print("Location access was restricted.")
		case .denied:
			print("User denied access to location.")
			// Display the map using the default location.
			mapView.isHidden = false
		case .notDetermined:
			print("Location status not determined.")
		case .authorizedAlways: fallthrough
		case .authorizedWhenInUse:
			print("Location status is OK.")
		}
	}
	
	// Handle location manager errors.
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		locationManager.stopUpdatingLocation()
		print("Error: \(error)")
	}
	
	func listLikelyPlaces() {
		// Clean up from previous sessions.
		likelyPlaces.removeAll()
		
		placesClient.currentPlace{ (placeLikelihoods, error) -> Void in
			if let error = error {
				// TODO: Handle the error.
				print("Current Place error: \(error.localizedDescription)")
				return
			}

			// Get likely places and add to the list.
			if let likelihoodList = placeLikelihoods {
				for likelihood in likelihoodList.likelihoods {
					let place = likelihood.place
					self.likelyPlaces.append(place)
				}
			}
		}
	}
}


extension MapVC: GMSAutocompleteViewControllerDelegate {
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		// Get the place name from 'GMSAutocompleteViewController'
		// Then display the name in textField
		let name = place.name ?? "aaaaaaa"
		let address = place.formattedAddress ?? "bbbbbbb"
		self.msgLabel.text = name + " " + address
		self.msgLabel.sizeToFit()
		// Dismiss the GMSAutocompleteViewController when something is selected
		dismiss(animated: true, completion: nil)
	}
	func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
		// Handle the error
		print("Error: ", error.localizedDescription)
	}
	func wasCancelled(_ viewController: GMSAutocompleteViewController) {
		// Dismiss when the user canceled the action
		dismiss(animated: true, completion: nil)
	}
	
	func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	
	func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
}

extension MapVC: DetailViewDelegate {
	func detailViewCancel() {
		UIView.animate(withDuration: 0.8, animations: { () in
			self.detailViewlayoutbottom?.constant = self.view.frame.height / 2
			super.view.layoutIfNeeded()
		})
	}
	
	func detailViewGo() {
		if let position = self.m_selectLocation {
			let streetVC = StreetVC()
			streetVC.location = position
			self.present(streetVC, animated: true)
		}
		
	}
}
