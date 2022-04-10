//
//  PlaningModel.swift
//  OrdersSimulation
//
//  Created by Tobiáš Hládek on 10/04/2022.
//

import Foundation

struct PathModelWrapper: Codable, Hashable {
    let pathToPickup: PathModel
    let pathToDeliver: PathModel
    let fullPath: PathModel
}

struct PlaninngModel: Codable, Hashable {
    let driver: Driver
    let path: PathModelWrapper
    private enum CodingKeys: String, CodingKey {
        case driver = "rider"
        case path
    }
}

struct PathModel: Codable, Hashable {
    let navigationLink: String?
    let cost: Double
    let averageSpeed: Double
    let travelTimeSecs: Double
    let distanceMeters: Double
}
