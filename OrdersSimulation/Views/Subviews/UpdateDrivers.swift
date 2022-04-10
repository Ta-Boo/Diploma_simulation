//
//  CreateOrder.swift
//  OrdersSimulation
//
//  Created by Tobiáš Hládek on 07/04/2022.
//

import SwiftUI

class UpdateDriversViewModel: ObservableObject{
    @Published var drivers: [Driver] = []
    let dispatcher = DispatchGroup()

    init() {
        fetchDrivers()
    }
    
    private func fetchDrivers() {
        APIManager.fetchData(from: Routing.drivers) { [weak self] (result: Result<[Driver], Error>) in
            switch result {
            case .success(let fetchedDrivers):
                self?.drivers = fetchedDrivers
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func updateEditedDrivers(completion: @escaping EmptyClosure) {
        let toBeUpdated = drivers.filter({$0.isUpdated})
        var updated = 0
        for driver in toBeUpdated {
            func update(result: Result<String, Error>) {
                switch result {
                case .success(let message):
                    print(message)
                    updated += 1
                case .failure(let failure):
                    print(failure)
                }
                dispatcher.leave()
            }
            dispatcher.enter()
            let querry = ["id":"\(driver.id)"]

            if driver.isActive {
                APIManager.post(from: Routing.activateDriver, parameters: querry) { (result: Result<String, Error>) in update(result: result)}
            } else {
                APIManager.post(from: Routing.deActivateDriver, parameters: querry) { update(result: $0)}
            }
            
        }
        dispatcher.notify(queue: .main) {
            completion()
        }

        
    }
}


struct UpdateDrivers: View {
    @Binding var sheet: ActionSheets?
    @ObservedObject var viewModel = UpdateDriversViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {

                Table(viewModel.drivers.sorted(by: {$0.id < $1.id})) {
//                    TableColumn("Display name") { driver in
//                        TextField("Enter display name...", text: $viewModel.drivers.first(where: {$0.id == driver.id})!.displayName)
//                    }
                    TableColumn("Display Name", value: \.displayName)
                    TableColumn("email", value: \.email)
                    TableColumn("Is active") { driver in
                        Toggle("",isOn: $viewModel.drivers.first(where: {$0.id == driver.id})!.isActive)
                            .toggleStyle(SwitchToggleStyle(tint: .secondary))
                    }
                }
                HStack {
                    Button("Dismiss") {
                        sheet = nil
                    }.padding()
                    Button("Update") {
                        viewModel.updateEditedDrivers {
                            sheet = nil
                        }
                    }.padding()
                }
                

            }
            
        }
        .frame(width: 750, height: 500)
        
    }
    init(sheet: Binding<ActionSheets?>) {
        _sheet = sheet
    }
}

