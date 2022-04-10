//
//  ContentViewModel.swift
//  OrdersSimulation
//
//  Created by Tobiáš Hládek on 07/04/2022.
//

import SwiftUI
typealias EmptyClosure = ()->Void

class ContentViewModel: ObservableObject {
    @Published var drivers : [Driver] = []
    
    func fetchActiveUsers(completion: EmptyClosure? = nil){
        APIManager.fetchData(from: Routing.activeDrivers) { (result: Result<[Driver], Error>)  in
            switch result {
            case .success(let drivers):
                self.drivers = drivers
                completion?()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func fetchOrder(id: Int, completion: EmptyClosure? = nil){
        APIManager.fetchData(from: Routing.getOrder(id: id)) { (result: Result<Order, Error>)  in
            switch result {
            case .success(let order):
                completion?()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func startSimulation(calendar: Calendar) {
        calendar.startSimulation()
    }
    
}
