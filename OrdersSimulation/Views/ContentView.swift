//
//  ContentView.swift
//  OrdersSimulation
//
//  Created by Tobiáš Hládek on 06/04/2022.
//

import SwiftUI

enum ActionSheets: String, Identifiable {
    var id: String { rawValue }
    case createDriver
    case users
    case updateDrivers
}

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    @ObservedObject var calendar: Calendar = Calendar()

    @State var selectedSheet: ActionSheets?

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.primary, .secondary]), startPoint: .top, endPoint: .bottom)

            GeometryReader { geometry in
                let height = geometry.size.height
                let width = geometry.size.width
                let ratio = 0.8
                HStack {
                    Spacer().frame(width: width*ratio)

                    VStack(alignment: .center) {
                        
                        Text("Olalalalalalla")
                        Button("Fetch Drivers") {
                            viewModel.fetchActiveUsers {
                                print("Success")
                            }
                        }

                        Button("Update drivers") {
                            selectedSheet = .updateDrivers
                        }
                        Button("Users") {
                            selectedSheet = .users
                        }
                        
                        Button("Start simulation") {
                            viewModel.startSimulation(calendar: calendar)
                        }
                        Button("TEST"){
                            let querry = [
                                "customer_id":"2699",
                                "restaurant_id":"9",
                                "price":"123456",
                            ]

                            APIManager.post(from: Routing.createOrder, parameters: querry) { (result: Result<SimpleOrder, Error>)  in
                                switch result {
                                case .success(let order):
                                    print(order.id)
                                case .failure(let failure):
                                    print(failure)
                                }
                            }
                        }
                        Button("RESET") {
                            calendar.reset()
                        }
                        
                    }
                    .frame(width: width * (1-ratio), height: height)
                    .background(Color.white.opacity(0.1))
                }
            }


            HStack{
                Text("\(viewModel.drivers.count)")
                Text("\(calendar.time)")

                VStack{
                    Spacer()
                    Image("Brand")
                        .resizable()
                        .tint(Color.white)
                        .frame(width: 140, height: 40)
                        .padding(5)
                }
                Spacer()
            }

        }
        .frame(width: 1000, height: 600)
        .sheet(item: $selectedSheet, content: { item in
            switch item {
            case .createDriver: EmptyView()
            case .updateDrivers: UpdateDrivers(sheet: $selectedSheet)
            case .users: UsersView(sheet: $selectedSheet)
            }
        })



    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
