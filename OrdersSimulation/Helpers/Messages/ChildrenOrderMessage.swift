//
//  ReceiveOrderMessage.swift
//  OrdersSimulation
//
//  Created by Tobiáš Hládek on 09/04/2022.
//

import Foundation

class ReceiveOrderMessage: Message {
    init(time: UInt) {
        super.init(time: time, messageType: .receiveOrder)
    }
    
    override func execute(calendar: Calendar) {
        super.execute(calendar: calendar)
        let customer = calendar.customers.randomElement(using: &calendar.randomGenerator)!.id
        let restaurant = calendar.restaurants.randomElement(using: &calendar.randomGenerator)!.id
        let price = Int.random(in: 500...15000)
        let querry = [
            "customer_id":"\(customer)",
            "restaurant_id":"\(restaurant)",
            "price":"\(price)",
        ]
        let semaphore =  DispatchSemaphore(value: 0)
        APIManager.syncPost(from: Routing.createOrder, parameters: querry) { (result: Result<SimpleOrder, Error>)  in
            switch result {
            case .success(let order):
                calendar.addMessage(AsignDriverMessage(time: self.time, order: order))
            case .failure(let failure):
                print("failure")
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
    
}

class AsignDriverMessage: Message {
    let order: SimpleOrder
    init(time: UInt, order: SimpleOrder) {
        self.order = order
        super.init(time: time, messageType: .assignOrder)
    }
    
    override func execute(calendar: Calendar) {
        super.execute(calendar: calendar)
        let semaphore = DispatchSemaphore(value: 0)
        let querry = ["order_id":"\(order.id)"]
        APIManager.syncPost(from: Routing.assignOrder, parameters: querry) { (result: Result<PlaninngModel, Error>)  in
            switch result {
            case .success(let path):
                calendar.addMessage(PickupOrderMessage(time: self.time + UInt(path.path.pathToPickup.travelTimeSecs), order: self.order))
                calendar.addMessage(DeliverOrderMessage(time: self.time
                                                       + UInt(path.path.pathToPickup.travelTimeSecs)
                                                       + UInt(path.path.pathToDeliver.travelTimeSecs), order: self.order))
            case .failure(let failure):
                print(failure)
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
}

class PickupOrderMessage: Message {
    let order: SimpleOrder
    init(time: UInt, order: SimpleOrder) {
        self.order = order
        super.init(time: time, messageType: .pickOrder)
    }
    
    override func execute(calendar: Calendar) {
        super.execute(calendar: calendar)
        let semaphore = DispatchSemaphore(value: 0)
        let querry = ["order_id":"\(order.id)"]
        APIManager.syncPost(from: Routing.pickupOrder, parameters: querry) { (result: Result<Order, Error>)  in
            switch result {
            case .success(let path):
                let _ = ""
            case .failure(let failure):
                print(failure)
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
}

class DeliverOrderMessage: Message {
    let order: SimpleOrder
    init(time: UInt, order: SimpleOrder) {
        self.order = order
        super.init(time: time, messageType: .deliverOrder)
    }
    
    override func execute(calendar: Calendar) {
        super.execute(calendar: calendar)
        let semaphore = DispatchSemaphore(value: 0)
        let querry = ["order_id":"\(order.id)"]
        APIManager.syncPost(from: Routing.deliverOrder, parameters: querry) { (result: Result<Order, Error>)  in
            switch result {
            case .success(let path):
                let _ = ""
            case .failure(let failure):
                print(failure)
            }
            semaphore.signal()
        }
        semaphore.wait()

    }
}

