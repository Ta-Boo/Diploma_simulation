//
//  Message.swift
//  OrdersSimulation
//
//  Created by Tobiáš Hládek on 09/04/2022.
//

import Foundation

enum MessageType: String {
    case receiveOrder
    case pickOrder
    case deliverOrder
    case assignOrder
}

class Message: Comparable {
    var id: Int = -1
    let time: UInt
    let messageType: MessageType
    var description: String {
        get {
            return "Message[\(id)]: \(messageType.rawValue) at: \(time)."
        }
    }
    
    init(time: UInt, messageType: MessageType) {
        self.time = time
        self.messageType = messageType
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.time < rhs.time
    }
    
    func execute(calendar: Calendar) {
        print(description)
        calendar.time = time
        
    }
    
}
