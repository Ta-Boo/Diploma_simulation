//
//  CreateOrder.swift
//  OrdersSimulation
//
//  Created by Tobiáš Hládek on 07/04/2022.
//

import SwiftUI

class UsersViewModel: ObservableObject{
    @Published var customers: [Customer] = []

    init() {
        fetchUsers()
    }
    
    private func fetchUsers() {
        APIManager.fetchData(from: Routing.customers) { [weak self] (result: Result<[Customer], Error>) in
            switch result {
            case .success(let fetchedCustomers):
                self?.customers = fetchedCustomers
            case .failure(let failure):
                print(failure)
            }
        }
    }
}


struct UsersView: View {
    @Binding var sheet: ActionSheets?
    @ObservedObject var viewModel = UsersViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Table(viewModel.customers) {
                    TableColumn("email", value: \.email)
                    TableColumn("Latitude:", value: \.latitude)
                    TableColumn("Longitude:", value: \.longitude)
                }
                HStack {
                    Button("Dismiss") {
                        sheet = nil
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

