//
//  Order.swift
//  OrdersSimulation
//
//  Created by Tobiáš Hládek on 07/04/2022.
//

import Foundation
struct Possition: Codable, Hashable {
    let lat: Double
    let lng: Double
}

struct Order: Codable, Hashable {
    let id: Int
    let customerId: Int
    let restaurantId: Int
    let riderId: Int?
    let price: Int
    let from: Possition
    let to: Possition
    let pickedAt: Date?
    let deliveredAt: Date?
    let createdAt: Date?
}

struct SimpleOrder: Codable, Hashable {
    let id: Int
    let customerId: Int
    let restaurantId: Int
    let riderId: Int?
    let price: Int
}
