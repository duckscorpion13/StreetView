//
//  StreetVC.swift
//  StreetView
//
//  Created by DerekYang on 2019/6/25.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import GoogleMaps

class StreetVC: UIViewController {

	var location = CLLocationCoordinate2D(latitude: -33.732, longitude: 150.312) {
		didSet {
			self.panoramaView.moveNearCoordinate(self.location)
		}
	}
	
    lazy var panoramaView = GMSPanoramaView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.setupFillWith(self.panoramaView)
		
		let btn = UIButton(frame: CGRect(x: 20, y: 20, width: 60, height: 40))
		btn.setTitle("Leave", for: .normal)
		btn.addTarget(self, action: #selector(leave), for: .touchUpInside)
		self.view.addSubview(btn)
	
        self.panoramaView.delegate = self
		
		self.panoramaView.moveNearCoordinate(self.location)
    }
	@objc func leave() {
		self.dismiss(animated: true)
	}
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
           self.panoramaView.camera = GMSPanoramaCamera(heading: 180, pitch: -10, zoom: 1)
        }
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension StreetVC: GMSPanoramaViewDelegate {
    func panoramaView(_ view: GMSPanoramaView, error: Error, onMoveNearCoordinate coordinate: CLLocationCoordinate2D) {
        print(error.localizedDescription)
		dismiss(animated: true)
    }
}

extension UIView {
	func setupFillWith(_ component: UIView) {
		self.addSubview(component)
		component.translatesAutoresizingMaskIntoConstraints = false
		if #available(iOS 11.0, *) {
			component.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
		} else {
			component.topAnchor.constraint(equalTo: self.readableContentGuide.topAnchor).isActive = true
		}
		component.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		component.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		component.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
	}
}
