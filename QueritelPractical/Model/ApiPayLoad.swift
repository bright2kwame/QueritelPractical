//
//  ApiPayLoad.swift
//  QueritelPractical
//
//  Created by Bright Ahedor on 24/06/2021.
//

import Foundation



struct ApiPayLoad:  Codable {
    let status: String
    let user_data: UserData
}

struct UserData: Codable {
    let fname: String
    let lname: String
    let email: String
    let gender: String
    let registration_date: String
    let image_url: String
    let phone_number: String
    let country: String
    let image_name: String
}




