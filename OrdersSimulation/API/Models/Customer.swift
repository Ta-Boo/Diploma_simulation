//
//  Driver.swift
//  OrdersSimulation
//
//  Created by Tobiáš Hládek on 06/04/2022.
//

import Foundation

struct Customer: Codable, Hashable, Identifiable {
    let id: Int
    let addressId: Int?
    let email: String
    let position: Possition
}

extension Customer {
    var longitude: String {
        get { return String(format: "%f", position.lng)}
    }
    var latitude: String {
        get { return String(format: "%f", position.lat)}
    }
}
