//
//  Driver.swift
//  OrdersSimulation
//
//  Created by Tobiáš Hládek on 06/04/2022.
//

import Foundation

struct Driver: Codable, Hashable, Identifiable {
    let id: Int
    let passwordHash: String
    let email: String
    let token: String?
    var isActive: Bool {
        didSet {
            isUpdated = true
        }
    }
    var displayName: String {
        didSet {
            isUpdated = true
        }
    }
    var orders : [Order] = []
    var isUpdated = false
    private enum CodingKeys: String, CodingKey {
        case id, passwordHash, email, token, isActive, displayName
    }
    
    
}


