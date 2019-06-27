//
//  CustomMarker.swift
//  StreetView
//
//  Created by DerekYang on 2019/6/26.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import GoogleMaps

class CustomMarker: GMSMarker {
	
	var m_id: Int = 0
	
	init(id: Int, rank: Double, icon: String) {
		super.init()
		
		self.m_id = id
		
		let iconView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 80, height: 50)))
		iconView.backgroundColor = UIColor.clear
		
		let img = UIImage(named: icon)
		let imageicon = UIImageView(image: img)
		imageicon.contentMode = .scaleAspectFit
		if let url = URL(string: icon) {
			imageicon.downloadImage(from: url)
		}
		
		imageicon.translatesAutoresizingMaskIntoConstraints = false
		iconView.addSubview(imageicon)
		imageicon.centerXAnchor.constraint(equalTo: iconView.centerXAnchor, constant: 0).isActive = true
		imageicon.centerYAnchor.constraint(equalTo: iconView.centerYAnchor, constant: 0).isActive = true
		imageicon.heightAnchor.constraint(equalToConstant: 25).isActive = true
		imageicon.widthAnchor.constraint(equalToConstant: 25).isActive = true
		
		let label = UILabel()
		label.text = "\(rank)"
		label.textAlignment = .center
		label.font = UIFont(name: label.font.fontName, size: 12)
		label.textColor = .white
		label.translatesAutoresizingMaskIntoConstraints = false
		iconView.addSubview(label)
		
		label.centerXAnchor.constraint(equalTo: iconView.centerXAnchor, constant: 0).isActive = true
		label.centerYAnchor.constraint(equalTo: imageicon.centerYAnchor, constant: 0).isActive = true
		
		self.iconView = iconView
	}
}


extension UIImageView {
	
	func downloadImage(from url: URL) {
		print("Download Started")
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data, error == nil else {
				return
			}
			print(response?.suggestedFilename ?? url.lastPathComponent)

			print("Download Finished")
			DispatchQueue.main.async() {
				self.image = UIImage(data: data)
			}
		}.resume()
	}
}
