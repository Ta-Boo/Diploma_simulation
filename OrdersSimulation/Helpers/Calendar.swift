//
//  Calendar.swift
//  OrdersSimulation
//
//  Created by Tobiáš Hládek on 08/04/2022.
//
import Foundation
import SwiftPriorityQueue




class Calendar: ObservableObject {
    var messages: PriorityQueue<Message> = PriorityQueue(ascending: true)
    @Published var time: UInt = 0
    var indexer = 0
    var triangularGenerator = TriangularGenerator(from: 60, mean: 600, to: 1500, seeder: SeededRandomNumberGenerator(seed: 1))
    var randomGenerator = SeededRandomNumberGenerator(seed: 1)
    
    var drivers: [Driver] = []
    var customers: [Customer] = []
    var restaurants: [Restaurant] = []
    
    
    func addMessage(_ message: Message) {
        indexer += 1
        message.id = indexer
        messages.push(message)
    }
    init() {
        setup()
    }
    
    private func setup() {
        APIManager.fetchData(from: Routing.drivers) { [weak self] (result: Result<[Driver], Error>) in
            switch result {
            case .success(let fetchedDrivers):
                self?.drivers = fetchedDrivers
            case .failure(let failure):
                print(failure)
            }
        }
        
        APIManager.fetchData(from: Routing.customers) { [weak self] (result: Result<[Customer], Error>) in
            switch result {
            case .success(let fetchedCustomers):
                self?.customers = fetchedCustomers
            case .failure(let failure):
                print(failure)
            }
        }
        
        APIManager.fetchData(from: Routing.restaurants) { [weak self] (result: Result<[Restaurant], Error>) in
            switch result {
            case .success(let fetchedRestaurants):
                self?.restaurants = fetchedRestaurants
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func executeTask() {
        let message = messages.pop()
        DispatchQueue.global().async {
            print("olaaaa")
        }
        message?.execute(calendar: self)
    }
    
    private func helper() {
        var generator = SeededRandomNumberGenerator(seed: 1)
        let points = stride(from: 0, through: 2000, by: 1).map{ _->(Double, Double) in
            let lat = Double.random(in: 18.7068965...18.7798626, using: &generator)
            let lng = Double.random(in: 49.1869280...49.2333820, using: &generator)
            return (lat, lng)
        }
        for point in points {
//            print("\(point.0)\t\(point.1)")
        }
        
        let nightGenerator =  TriangularGenerator(from: 0, mean: 32400, to: 36000, seeder: SeededRandomNumberGenerator(seed: 1))
        let morningGenerator =  TriangularGenerator(from: 32400, mean: 41400, to: 52400, seeder: SeededRandomNumberGenerator(seed: 1))
        let eveningGenerator =  TriangularGenerator(from: 48000, mean: 67600, to: 86400, seeder: SeededRandomNumberGenerator(seed: 1))

        let night = stride(from: 1, through: 120, by: 1).map { _ in "\(Int(nightGenerator.next()))"}.sorted()
        let morning = stride(from: 1, through: 1100, by: 1).map { _ in "\(Int(morningGenerator.next()))"}.sorted()
        let evening = stride(from: 1, through: 500, by: 1).map { _ in "\(Int(eveningGenerator.next()))"}.sorted()
        let merged = night + morning + evening
        for time in merged {
            print(time)
        }
    }
    
    func prepareOrders() {
        if let path = Bundle.main.path(forResource: "OrdersTimes", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let times = data.components(separatedBy: .newlines).dropLast().map {UInt($0)!}
                for time in times{//[0...10] {
                    addMessage(ReceiveOrderMessage(time: time))
                }
            } catch {
                print(error)
            }
        }
    }
    
    func resetOrders(completion : @escaping EmptyClosure) {
        APIManager.post(from: Routing.reset) { [weak self] (result: Result<String, Error>) in
            switch result {
            case .success(_):
                self?.setup()
            case .failure(let error):
                print(error)
                fatalError("Something very, very bad happened")
            }
        }
    }
    
    func reset() {
        time = 0
        resetOrders() {
            
        }
    }
    
    func startSimulation() {
//        resetOrders() {
            self.prepareOrders()
            print("[SIMULATION STARTED]")
            while !self.messages.isEmpty {
                self.executeTask()
            }
            print("[SIMULATION FINISHED]")
//        }
    }
    
}

