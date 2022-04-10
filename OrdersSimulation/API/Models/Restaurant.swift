import Foundation

struct Restaurant: Codable, Hashable {
    let id: Int
    let addressId: Int
    let locationId: Int?
    let name: String
    let position: Possition
}

