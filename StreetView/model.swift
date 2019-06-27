//
//  model.swift
//  StreetView
//
//  Created by DerekYang on 2019/6/26.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import Foundation

struct JSONData : Decodable {
	let results : [SerachStore]
	let status : String?
}
//geometry
struct Geometry : Decodable{
	let location : Location
	struct Location : Decodable {
		let lat : Double?
		let lng : Double?
	}
}
//opening_hours
struct Opening_hours : Decodable {
	let open_now : Bool?
}
//photos
struct Photos : Decodable {
	let height : Double?
	let html_attributions : [String]
	let photo_reference : String?
	let width : Double?
}
//plus_code
struct Plus_code : Decodable {
	let compound_code : String?
	let global_code : String?
}

//Distance Matrix Requests

struct DistanceMatrixRequests : Decodable {
	let destination_addresses : [String]?
	let origin_addresses : [String]?
	let rows : [Elements]?
	let status : String?
}

struct Elements : Decodable {
	let elements : [Distance]?
	struct Distance : Decodable {
		let distance : Text?
	}
	struct Text : Decodable {
		let text : String?
		let value : Double?
	}
}

struct SerachStore : Decodable {
	let geometry : Geometry?
	let icon : String?
	let id : String?
	let name : String?
	let opening_hours : Opening_hours?
	let photos : [Photos]?
	let place_id : String?
	let plus_code : Plus_code?
	let rating : Double?
	let reference : String?
	let scope : String?
	let types : [String]?
	let user_ratings_total : Int?
	let vicinity : String?
	//let distanceValue : String?
}
